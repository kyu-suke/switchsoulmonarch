import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:switchsoulmonarch/apps_pane.dart';
import 'package:switchsoulmonarch/database/show_keyboard_window_provider.dart';
import 'package:switchsoulmonarch/database/apps_provider.dart';
import 'package:switchsoulmonarch/hotkey_pane.dart';
import 'package:switchsoulmonarch/keyboard.dart';
import 'package:switchsoulmonarch/state/apps_state.dart';
import 'package:switchsoulmonarch/state/hotkey_holder_state.dart';
import 'package:switchsoulmonarch/system_tray.dart';
import 'package:switchsoulmonarch/shortcut_window.dart';
import 'package:window_manager/window_manager.dart';

final windowManager = WindowManager.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  // Use it only after calling `hiddenWindowAtLaunch`
  windowManager.waitUntilReadyToShow().then((_) async {
    // await windowManager.setAsFrameless();
    await windowManager.setSize(Size(800, 600));
    await windowManager.show();
  });

  runApp(ProviderScope(
    child: HomePage(keyCombo: await getKeyCombo(), apps: await getApps()),
  ));
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key, this.keyCombo, this.apps}) : super(key: key);
  final SsmKeyCombo? keyCombo;
  final ShortcutApps? apps;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WindowListener {
  String selectedPane = "hotkey";
  String selectedWindow = "preference";

  final bool _isFullScreen = false;
  final bool _isResizable = false;
  final bool _isMinimizable = false;
  final bool _isClosable = false;

  @override
  void initState() {
    print("!!!!!!!!!!!!!!!!");
    if (widget.keyCombo != null) {
      context
          .read(windowHotKeyStateNotifier.notifier)
          .set(widget.keyCombo!.keyCombo!);
    }
    if (widget.apps != null) {
      context
          .read(appsStateNotifier.notifier)
          .setAll(widget.apps!);
    }
    print("===================");

    // window setting
    windowManager.addListener(this);
    // windowManager.setFullScreen(_isFullScreen);
    // windowManager.setResizable(_isResizable);
    // windowManager.setMinimizable(_isMinimizable);
    // windowManager.setClosable(_isClosable);
    windowManager.setSize(const Size(1300, 500));

    // system tray setting
    final SsmSystemTray systemTray = SsmSystemTray();
    systemTray.getSystemTray(() {
      setState(() {
        selectedWindow = "preference";
        print("hoge");
      });
      windowManager.setSize(const Size(1300, 500));
      windowManager.show();
    }, () {} /*windowManager.terminate*/ /* TODO implement terminate in swift */);
    super.initState();
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  // call swift code
  static const platform = MethodChannel('samples.flutter.dev/battery');

  Future<void> _getBatteryLevel() async {
    // Get battery level.
    String batteryLevel;
    try {
      final int result = await platform.invokeMethod('getBatteryLevel');
      batteryLevel = 'Battery level at $result % .';
    } on PlatformException catch (e) {
      batteryLevel = "Failed to get battery level: '${e.message}'.";
    }

    setState(() {});
  }

  Future<void> showShortcutWindow() async {
    setState(() {
      selectedWindow = "shortcuts";
    });
    windowManager.setSize(const Size(1200, 500));
    windowManager.show();
  }

  Widget _buildHotkeyPane() {
    return HotKeyPane(fn: showShortcutWindow);
  }

  Widget _buildAppsPane() {
    return AppsPane();
  }

  Widget _buildUpdatePane() {
    return Center(
      child: OutlinedButton(
        child: Text("Check for updates"),
        style: OutlinedButton.styleFrom(
            primary: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(0),
              ),
            )),
        onPressed: () => setState(() => {}),
      ),
    );
  }

  Widget _buildPane() {
    Widget pane;
    if (selectedPane == "hotkey") {
      pane = _buildHotkeyPane();
    } else if (selectedPane == "apps") {
      pane = _buildAppsPane();
    } else {
      pane = _buildUpdatePane();
    }
    return pane;
  }

  Widget _leftSideButton(String label, String pane) {
    return Row(
      children: [
        Expanded(
            child: OutlinedButton(
          child: Text(label),
          style: OutlinedButton.styleFrom(
              primary: Colors.black,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(0),
                ),
              )),
          onPressed: () => setState(() => selectedPane = pane),
        )),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    return Row(
      children: [
        Expanded(
            flex: 1,
            child: Container(
                child: Column(
              children: [
                _leftSideButton("Hotkey", "hotkey"),
                _leftSideButton("Apps", "apps"),
                _leftSideButton("Update", "update"),
              ],
            ))),
        Expanded(flex: 9, child: _buildPane()),
      ],
    );
  }

  Widget _buildKeyboard(BuildContext context) {
    return ShortcutWindow();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
            child: selectedWindow == "preference"
                // child: selectedWindow != "preference"
                ? _buildBody(context)
                : _buildKeyboard(context)),
      ),
    );
  }

  final Map<String, Function> eventFuncs = {
    "blur": () => {/*can i use hideOnDeactives?*/ windowManager.hide()},
  };

  @override
  void onWindowEvent(String eventName) {
    print('[WindowManager] onWindowEvent: $eventName');
    final eventFunc = eventFuncs[eventName];
    if (eventFunc != null) {
      // eventFunc();
    }
  }
}
