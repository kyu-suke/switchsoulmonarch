import 'dart:async';

import 'package:tray_manager/tray_manager.dart';

class SsmSystemTray with TrayListener {
  Future<TrayManager> getSystemTray(
      Function showPreference, Function exitApp) async {
    return initSystemTray(showPreference, exitApp)
        .then((value) => _trayManager);
  }

  final TrayManager _trayManager = TrayManager.instance;
  Function? showPreference;
  Function? exitApp;

  Future<void> initSystemTray(
      Function showPreferenceFunction, Function exitAppFunction) async {
    TrayManager.instance.addListener(this);
    await TrayManager.instance.setIcon("assets/appIcon/ssm_32.png");
    showPreference = showPreferenceFunction;
    exitApp = exitAppFunction;

    List<MenuItem> items = [
      MenuItem(label: 'Shortcuts'),
      MenuItem.separator(),
      MenuItem(label: 'Preference'),
      MenuItem.separator(),
      MenuItem(label: 'Exit'),
    ];
    final menu = Menu(items: items);
    await TrayManager.instance.setContextMenu(menu);
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
    switch (menuItem.label) {
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
