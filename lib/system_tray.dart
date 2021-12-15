import 'dart:async';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:system_tray/system_tray.dart';

class SsmSystemTray {
  Future<SystemTray> getSystemTray(Function fn1, Function fn2) async {
    return initSystemTray(fn1, fn2).then((value) => _systemTray);
  }

  final SystemTray _systemTray = SystemTray();

  Future<void> initSystemTray(Function fn1, Function fn2) async {
    String path;
    if (Platform.isMacOS) {
      path = p.joinAll(['AppIcon']);
    } else {
      throw ("not supported platform");
    }

    // We first init the systray menu and then add the menu entries
    await _systemTray.initSystemTray(title: "system tray2",
        iconPath: path, toolTip: "How to use system tray with Flutter");

    await _systemTray.setContextMenu(
      [
        MenuItem(
          label: 'Show',
          onClicked: () {
            // appWindow.show();
            fn1();
            // windowManager.show();
          },
        ),
        MenuSeparator(),
        SubMenu(
          label: "SubMenu",
          children: [
            MenuItem(
              label: 'SubItem1',
              enabled: false,
              onClicked: () {
                print("click SubItem1");
              },
            ),
            MenuItem(label: 'SubItem2'),
            MenuItem(label: 'SubItem3'),
          ],
        ),
        MenuSeparator(),
        MenuItem(
          label: 'Exit',
          onClicked: () {
            // appWindow.hide();
            // appWindow.close();
            // windowManager.terminate();
            fn2();
          },
        ),
      ],
    );

    // handle system tray event
    _systemTray.registerSystemTrayEventHandler((eventName) {
      print("eventName: $eventName");
      if (eventName == "leftMouseUp") {
        // windowManager.show();
        fn1();
      }
    });
  }
}
