#include "application.h"
#include <QCommandLineParser>
#include <QDBusPendingCall>
#include <QTranslator>
#include <QLocale>
#include <QIcon>

#include "settingsuiadaptor.h"
#include "fontsmodel.h"
#include "fonts/fonts.h"
#include "appearance.h"
#include "battery.h"
#include "batteryhistorymodel.h"
#include "brightness.h"
#include "about.h"
#include "background.h"
#include "language.h"
#include "password.h"
#include "powermanager.h"
#include "touchpad.h"
#include "networkproxy.h"
#include "notifications.h"
#include "defaultapplications.h"
#include "accessibility.h"
#include "cursor/cursorthememodel.h"
#include "cursor/mouse.h"

#include "datetime/time.h"
#include "datetime/timezonemap.h"

const QString ModuleDirectory = "/usr/lib/cute-settings/modules";

static QObject *passwordSingleton(QQmlEngine *engine, QJSEngine *scriptEngine)
{
    Q_UNUSED(engine);
    Q_UNUSED(scriptEngine);

    Password *object = new Password();
    return object;
}

Application::Application(int &argc, char **argv)
    : QApplication(argc, argv)
{
    setWindowIcon(QIcon::fromTheme("preferences-system"));
    setOrganizationName("cuteos");

    QCommandLineParser parser;
    parser.setApplicationDescription(QStringLiteral("Cute Settings"));
    parser.addHelpOption();

    QCommandLineOption moduleOption("m", "Switch to module", "module");
    parser.addOption(moduleOption);
    parser.process(*this);

    const QString module = parser.value(moduleOption);

    if (!QDBusConnection::sessionBus().registerService("com.cute.SettingsUI")) {
        QDBusInterface iface("com.cute.SettingsUI", "/SettingsUI", "com.cute.SettingsUI", QDBusConnection::sessionBus());
        if (iface.isValid())
            iface.call("switchToPage", module);
        return;
    }

    new SettingsUIAdaptor(this);
    QDBusConnection::sessionBus().registerObject(QStringLiteral("/SettingsUI"), this);

    // QML
    const char *uri = "Cute.Settings";
    qmlRegisterType<Appearance>(uri, 1, 0, "Appearance");
    qmlRegisterType<FontsModel>(uri, 1, 0, "FontsModel");
    qmlRegisterType<Brightness>(uri, 1, 0, "Brightness");
    qmlRegisterType<Battery>(uri, 1, 0, "Battery");
    qmlRegisterType<BatteryHistoryModel>(uri, 1, 0, "BatteryHistoryModel");
    qmlRegisterType<CursorThemeModel>(uri, 1, 0, "CursorThemeModel");
    qmlRegisterType<About>(uri, 1, 0, "About");
    qmlRegisterType<Background>(uri, 1, 0, "Background");
    qmlRegisterType<Language>(uri, 1, 0, "Language");
    qmlRegisterType<Fonts>(uri, 1, 0, "Fonts");
    qmlRegisterType<PowerManager>(uri, 1, 0, "PowerManager");
    qmlRegisterType<Mouse>(uri, 1, 0, "Mouse");
    qmlRegisterType<Time>(uri, 1, 0, "Time");
    qmlRegisterType<TimeZoneMap>(uri, 1, 0, "TimeZoneMap");
    qmlRegisterType<Touchpad>(uri, 1, 0, "Touchpad");
    qmlRegisterType<NetworkProxy>(uri, 1, 0, "NetworkProxy");
    qmlRegisterType<Notifications>(uri, 1, 0, "Notifications");
    qmlRegisterType<DefaultApplications>(uri, 1, 0, "DefaultApplications");
    qmlRegisterType<Accessibility>(uri, 1, 0, "Accessibility");
    qmlRegisterSingletonType<Password>(uri, 1, 0, "Password", passwordSingleton);

#if QT_VERSION < QT_VERSION_CHECK(5, 14, 0)
    qmlRegisterType<QAbstractItemModel>();
#else
    qmlRegisterAnonymousType<QAbstractItemModel>(uri, 1);
#endif

    // Translations
    QLocale locale;
    QString qmFilePath = QString("%1/%2.qm").arg("/usr/share/cute-settings/translations/").arg(locale.name());
    if (QFile::exists(qmFilePath)) {
        QTranslator *translator = new QTranslator(QApplication::instance());
        if (translator->load(qmFilePath)) {
            QApplication::installTranslator(translator);
        } else {
            translator->deleteLater();
        }
    }

    m_engine.addImportPath(QStringLiteral("qrc:/"));
    m_engine.load(QUrl(QStringLiteral("qrc:/qml/main.qml")));

    if (!module.isEmpty()) {
        switchToPage(module);
    }

    insertPlugin();

    QApplication::exec();
}

void Application::insertPlugin()
{
    QDir moduleDir(ModuleDirectory);
    if (!moduleDir.exists()) {
        qDebug() << "module directory not exists";
        return;
    }
    auto moduleList = moduleDir.entryInfoList();
    for (auto i : moduleList) {
        QString path = i.absoluteFilePath();

        if (!QLibrary::isLibrary(path))
            continue;

        qDebug() << "loading module: " << i;
        QElapsedTimer et;
        et.start();
        QPluginLoader loader(path);

        QObject *instance = loader.instance();
        if (!instance) {
            qDebug() << loader.errorString();
            continue;
        }

        instance->setParent(this);

        auto *module = qobject_cast<ModuleInterface *>(instance);
        if (!module) {
            return;
        }
        qDebug() << "load plugin Name: " << module->name() << module->title();
        qDebug() << "load this plugin using time: " << et.elapsed() << "ms";

        if(module->enabled())
        {
            addPage(module->title(),module->name(),module->qmlPath(),module->iconPath(),module->iconColor().name(),module->category());
        }
    }
}

void Application::addPage(QString title,QString name,QString page,QString iconSource,QString iconColor,QString category)
{
    QObject *mainObject = m_engine.rootObjects().first();

    if (mainObject) {
        QMetaObject::invokeMethod(mainObject, "addPage", Q_ARG(QVariant, title), Q_ARG(QVariant, name), Q_ARG(QVariant, page), Q_ARG(QVariant, iconSource), Q_ARG(QVariant, iconColor), Q_ARG(QVariant, category));
    }
}

void Application::switchToPage(const QString &name)
{
    QObject *mainObject = m_engine.rootObjects().first();

    if (mainObject) {
        QMetaObject::invokeMethod(mainObject, "switchPageFromName", Q_ARG(QVariant, name));
    }
}
