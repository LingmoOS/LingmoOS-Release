/*
    SPDX-FileCopyrightText: 2007-2008 Robert Knight <robertknight@gmail.com>
    SPDX-License-Identifier: GPL-2.0-or-later
*/

// Own
#include "ShellCommand.h"

// some versions of gcc(4.3) require explicit include
#include <cstdlib>

// Qt
#include <QDir>

using Konsole::ShellCommand;

ShellCommand::ShellCommand(const QString &fullCommand)
{
    bool inQuotes = false;

    QString builder;

    for ( int i = 0 ; i < fullCommand.count() ; i++ ) {
        QChar ch = fullCommand[i];

        const bool isLastChar = ( i == fullCommand.count() - 1 );
        const bool isQuote = ( ch == QLatin1Char('\'') || ch == QLatin1Char('\"') );

        if ( !isLastChar && isQuote ) {
            inQuotes = !inQuotes;
        } else {
            if ( (!ch.isSpace() || inQuotes) && !isQuote ) {
                builder.append(ch);
            }

            if ( (ch.isSpace() && !inQuotes) || ( i == fullCommand.count()-1 ) ) {
                _arguments << builder;
                builder.clear();
            }
        }
    }
}

ShellCommand::ShellCommand(const QString &aCommand, const QStringList &aArguments)
{
    _arguments = aArguments;

    if (!_arguments.isEmpty()) {
        _arguments[0] = aCommand;
    }
}

QString ShellCommand::fullCommand() const
{
    QStringList quotedArgs(_arguments);
    for (int i = 0; i < quotedArgs.count(); i++) {
        QString arg = quotedArgs.at(i);
        bool hasSpace = false;
        for (int j = 0; j < arg.count(); j++) {
            if (arg[j].isSpace()) {
                hasSpace = true;
            }
        }
        if (hasSpace) {
            quotedArgs[i] = QLatin1Char('\"') + arg + QLatin1Char('\"');
        }
    }
    return quotedArgs.join(QLatin1Char(' '));
}

QString ShellCommand::command() const
{
    if (!_arguments.isEmpty()) {
        return _arguments[0];
    }
    return QString();
}

QStringList ShellCommand::arguments() const
{
    return _arguments;
}

QStringList ShellCommand::expand(const QStringList &items)
{
    QStringList result;
    result.reserve(items.size());

    for (const QString &item : items) {
        result << expand(item);
    }

    return result;
}

QString ShellCommand::expand(const QString &text)
{
    QString result = text;
    expandEnv(result);
    return result;
}

bool ShellCommand::isValidEnvCharacter(const QChar &ch)
{
    const ushort code = ch.unicode();
    return isValidLeadingEnvCharacter(ch) || ('0' <= code && code <= '9');
}

bool ShellCommand::isValidLeadingEnvCharacter(const QChar &ch)
{
    const ushort code = ch.unicode();
    return (code == '_') || ('A' <= code && code <= 'Z');
}

/*
 * expandEnv
 *
 * Expand environment variables in text. Escaped '$' characters are ignored.
 * Return true if any variables were expanded
 */
bool ShellCommand::expandEnv(QString &text)
{
    // Current path
    if (text == "$PWD") {
        text = QDir::currentPath();
        return true;
    }

    const QLatin1Char dollarChar('$');
    const QLatin1Char backslashChar('\\');

    int dollarPos = 0;
    bool expanded = false;

    // find and expand all environment variables beginning with '$'
    while ((dollarPos = text.indexOf(dollarChar, dollarPos)) != -1) {
        // if '$' is the last character, there is no way of expanding
        if (dollarPos == text.length() - 1) {
            break;
        }

        // skip escaped '$'
        if (dollarPos > 0 && text.at(dollarPos - 1) == backslashChar) {
            dollarPos++;
            continue;
        }

        // if '$' is followed by an invalid leading character, skip this '$'
        if (!isValidLeadingEnvCharacter(text.at(dollarPos + 1))) {
            dollarPos++;
            continue;
        }

        int endPos = dollarPos + 1;
        Q_ASSERT(endPos < text.length());
        while (endPos < text.length() && isValidEnvCharacter(text.at(endPos))) {
            endPos++;
        }

        const int len = endPos - dollarPos;
        const QString key = text.mid(dollarPos + 1, len - 1);
        const QString value = QString::fromLocal8Bit(qgetenv(key.toLocal8Bit().constData()));

        if (!value.isEmpty()) {
            text.replace(dollarPos, len, value);
            expanded = true;
            dollarPos = dollarPos + value.length();
        } else {
            dollarPos = endPos;
        }
    }

    return expanded;
}
