import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import 'package:preference_list/preference_list.dart';
import 'package:system_tray/system_tray.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final SystemTray _systemTray = SystemTray();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    initSystemTray();
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  Future<void> initSystemTray() async {
    String path;
    if (Platform.isMacOS) {
      path = p.joinAll(['AppIcon']);
    } else {
      throw ("not supported platform");
    }

    // We first init the systray menu and then add the menu entries
    await _systemTray.initSystemTray("system tray2",
        iconPath: path, toolTip: "How to use system tray with Flutter");

    await _systemTray.setContextMenu(
      [
        MenuItem(
          label: 'Show',
          onClicked: () {
            // appWindow.show();
            windowManager.show();
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
            windowManager.terminate();
          },
        ),
      ],
    );

    // handle system tray event
    _systemTray.registerSystemTrayEventHandler((eventName) {
      print("eventName: $eventName");
      if (eventName == "leftMouseUp") {
        windowManager.show();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: HomePage(), // blur, focus etc.
      ),
    );
  }
}

final windowManager = WindowManager.instance;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WindowListener {
  // Size? _minSize;
  // Size? _maxSize;
  // bool _isMovable = true;
  // bool _isAlwaysOnTop = false;
  // bool _hasShadow = true;
  // Size _size = _kSizes.first;

  bool _isFullScreen = false;
  bool _isResizable = false;
  bool _isMinimizable = false;
  bool _isClosable = false;

  @override
  void initState() {
    windowManager.addListener(this);
    windowManager.setFullScreen(_isFullScreen);
    windowManager.setResizable(_isResizable);
    windowManager.setMinimizable(_isMinimizable);
    windowManager.setClosable(_isClosable);
    windowManager.setSize(Size(1000, 600));
    super.initState();
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  // call swift code
  static const platform = const MethodChannel('samples.flutter.dev/battery');
  String _batteryLevel = 'Unknown battery level.';

  Future<void> _getBatteryLevel() async {
    // Get battery level.
    String batteryLevel;
    try {
      final int result = await platform.invokeMethod('getBatteryLevel');
      batteryLevel = 'Battery level at $result % .';
    } on PlatformException catch (e) {
      batteryLevel = "Failed to get battery level: '${e.message}'.";
    }

    setState(() {
      _batteryLevel = batteryLevel;
    });
  }

  Widget _buildHotkeyPane() {
    return PreferenceList(
      children: <Widget>[
        PreferenceListSection(
          children: [
            PreferenceListItem(
              title: Text('plugin'),
              onTap: () async {
                print("yes?");
                _getBatteryLevel();
              },
            ),
            PreferenceListItem(
              title: Text('terminate'),
              onTap: () async {
                await windowManager.terminate();
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPane() {
    Widget pane;
    if (true) {
      pane = _buildHotkeyPane();
    } else if (false) {
      // pane = _buildAppsPane();
    } else {
      // pane = _buildUpdatePane();
    }
    return pane;
  }

  Widget _buildBody(BuildContext context) {
    return Row(
      children: [
        Expanded(
            flex: 1,
            child: Container(
                child: Column(
              children: [
                Text("Hotkey"),
                Text("Apps"),
                Text("Update"),
              ],
            ))),
        Expanded(flex: 9, child: _buildPane()),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // switch preference or keyboard window
    final showPreference = true;
    return Scaffold(
      body: Container(
          child: showPreference
              ? _buildBody(context)
              : /*_buildKeyboard(context)*/ _buildBody(context)),
    );
  }

  final Map<String, Function> eventFuncs = {
    "blur": () => {windowManager.hide()},
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
