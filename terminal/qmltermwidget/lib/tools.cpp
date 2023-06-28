#include "tools.h"

#include <QCoreApplication>
#include <QDir>
#include <QtDebug>


/*! Helper function to get possible location of layout files.
By default the KB_LAYOUT_DIR is used (linux/BSD/macports).
But in some cases (apple bundle) there can be more locations).
*/
QString get_kb_layout_dir()
{
//    qDebug() << __FILE__ << __FUNCTION__;

    QString rval = QString();
    QString k(qgetenv("KB_LAYOUT_DIR"));
    QDir d(k);

    qDebug() << "default KB_LAYOUT_DIR: " << k;

    if (d.exists())
    {
        rval = k.append(QLatin1Char('/'));
        return rval;
    }

    // subdir in the app location
    d.setPath(QCoreApplication::applicationDirPath() + QLatin1String("/kb-layouts/"));
    //qDebug() << d.path();
    if (d.exists())
        return QCoreApplication::applicationDirPath() + QLatin1String("/kb-layouts/");
#ifdef Q_WS_MAC
    d.setPath(QCoreApplication::applicationDirPath() + "/../Resources/kb-layouts/");
    if (d.exists())
        return QCoreApplication::applicationDirPath() + "/../Resources/kb-layouts/";
#endif
    qDebug() << "Cannot find KB_LAYOUT_DIR. Default:" << k;
    return QString();
}

/*! Helper function to add custom location of color schemes.
*/
namespace {
    QStringList custom_color_schemes_dirs;
}
void add_custom_color_scheme_dir(const QString& custom_dir)
{
    if (!custom_color_schemes_dirs.contains(custom_dir))
        custom_color_schemes_dirs << custom_dir;
}

/*! Helper function to get possible locations of color schemes.
By default the COLORSCHEMES_DIR is used (linux/BSD/macports).
But in some cases (apple bundle) there can be more locations).
*/
const QStringList get_color_schemes_dirs()
{
//    qDebug() << __FILE__ << __FUNCTION__;

    QStringList rval;
    QString k(qgetenv("COLORSCHEMES_DIR"));
    QDir d(k);

//    qDebug() << "default COLORSCHEMES_DIR: " << k;

    if (d.exists())
        rval << k.append(QLatin1Char('/'));

    // subdir in the app location
    d.setPath(QCoreApplication::applicationDirPath() + QLatin1String("/color-schemes/"));
    //qDebug() << d.path();
    if (d.exists())
    {
        if (!rval.isEmpty())
            rval.clear();
        rval << (QCoreApplication::applicationDirPath() + QLatin1String("/color-schemes/"));
    }
#ifdef Q_WS_MAC
    d.setPath(QCoreApplication::applicationDirPath() + "/../Resources/color-schemes/");
    if (d.exists())
    {
        if (!rval.isEmpty())
            rval.clear();
        rval << (QCoreApplication::applicationDirPath() + "/../Resources/color-schemes/");
    }
#endif
    for (const QString& custom_dir : const_cast<const QStringList&>(custom_color_schemes_dirs))
    {
        d.setPath(custom_dir);
        if (d.exists())
            rval << custom_dir;
    }
#ifdef QT_DEBUG
    if(!rval.isEmpty()) {
        qDebug() << "Using color-schemes: " << rval;
    } else {
        qDebug() << "Cannot find color-schemes in any location!";
    }
#endif
    return rval;
}
