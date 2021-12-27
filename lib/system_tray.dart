import 'dart:async';

import 'package:tray_manager/tray_manager.dart';

class SsmSystemTray with TrayListener {
  Future<TrayManager> getSystemTray(Function fn1, Function fn2) async {
    return initSystemTray(fn1, fn2).then((value) => _trayManager);
  }

  // final SystemTray _systemTray = SystemTray();
  final TrayManager _trayManager = TrayManager.instance;
  Function? showPreference;
  Function? exitApp;

  Future<void> initSystemTray(Function fn1, Function fn2) async {
    TrayManager.instance.addListener(this);
    await TrayManager.instance.setIcon("assets/appIcon/ssm_32.png");
    showPreference = fn1;
    exitApp = fn2;

    List<MenuItem> items = [
      MenuItem(title: 'Shortcuts'),
      MenuItem.separator,
      MenuItem(title: 'Preference'),
      MenuItem.separator,
      MenuItem(title: 'Exit'),
    ];
    await TrayManager.instance.setContextMenu(items);

    // // handle system tray event
    // _systemTray.registerSystemTrayEventHandler((eventName) {
    //   print("eventName: $eventName");
    //   if (eventName == "leftMouseUp") {
    //     // windowManager.show();
    //     fn1();
    //   }
    // });
  }

  @override
  void onTrayIconMouseDown() {
    TrayManager.instance.popUpContextMenu();
  }

  @override
  void onTrayIconRightMouseDown() {
    TrayManager.instance.popUpContextMenu();
  }

  @override
  void onTrayIconRightMouseUp() {
    print(TrayManager.instance.getBounds());
  }

  @override
  void onTrayMenuItemClick(MenuItem menuItem) {
    switch (menuItem.title) {
      case "Shortcuts":
        break;
      case "Preference":
        showPreference!();
        break;
      case "Exit":
        exitApp!();
        break;
    }
  }
}
