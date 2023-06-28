//2023-04-25-01:07
#include "desktop.h"
#include "desktop/desktopsettings.h"
#include <QApplication>

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_UseHighDpiPixmaps, true);
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling, true);

    // Register QML Type.
    const char *uri = "Cute.Desktop";

    qmlRegisterType<DesktopSettings>(uri, 1, 0, "DesktopSettings");

    Desktop desktop(argc,argv);
    return desktop.run();
}