import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:preference_list/preference_list.dart';
import 'package:switchsoulmonarch/system_tray.dart';
import 'package:switchsoulmonarch/keyboard.dart';
import 'package:switchsoulmonarch/hotkey_pane.dart';
import 'package:switchsoulmonarch/apps_pane.dart';
import 'package:system_tray/system_tray.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(HomePage());
}

// class MyApp extends StatefulWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   @override
//   State<MyApp> createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> {
//   SystemTray _systemTray = SystemTray();
//
//   @override
//   void initState() {
//     super.initState();
//     final SsmSystemTray systemTray = SsmSystemTray();
//     systemTray
//         .getSystemTray(() {
//       setState((){
//         selectedWindow = "shortcuts";
//       });
//       windowManager.show();
//     }, windowManager.terminate)
//         .then((value) => _systemTray = value);
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         body: HomePage(), // blur, focus etc.
//       ),
//     );
//   }
// }

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

  String selectedPane = "hotkey";
  String selectedWindow = "preference";

  bool _isFullScreen = false;
  bool _isResizable = false;
  bool _isMinimizable = false;
  bool _isClosable = false;



  SystemTray _systemTray = SystemTray();


  @override
  void initState() {
    windowManager.addListener(this);
    windowManager.setFullScreen(_isFullScreen);
    windowManager.setResizable(_isResizable);
    windowManager.setMinimizable(_isMinimizable);
    windowManager.setClosable(_isClosable);
    windowManager.setSize(Size(1300, 600));


    final SsmSystemTray systemTray = SsmSystemTray();
    systemTray
        .getSystemTray(() {
      setState((){
        selectedWindow = "preference";
        print("hoge");
        windowManager.show();
      });
    }, windowManager.terminate)
        .then((value) => _systemTray = value);
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

  void showShortcutWindow() {
    setState((){
      selectedWindow = "shortcuts";
    });
    windowManager.show();
  }

  Widget _buildHotkeyPane() {
    return HotKeyPane(fn: showShortcutWindow);
    // return PreferenceList(
    //   children: <Widget>[
    //     PreferenceListSection(
    //       children: [
    //         PreferenceListItem(
    //           title: Text('plugin'),
    //           onTap: () async {
    //             print("yes?");
    //             _getBatteryLevel();
    //           },
    //         ),
    //         PreferenceListItem(
    //           title: Text('terminate'),
    //           onTap: () async {
    //             await windowManager.terminate();
    //           },
    //         ),
    //       ],
    //     ),
    //   ],
    // );
  }


  Widget _buildAppsPane() {
    return AppsPane();
    // return Center(
    //   child: Text("here will be put keyboard layout container")
    // );
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
        onPressed: () => setState(()=> {}),
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
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(0),
                ),
              )),
          onPressed: () => setState(()=> selectedPane = pane),
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
    return KeyboardPage(fn:(){});
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
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: Container(
  //         child: selectedWindow == "preference"
  //         // child: selectedWindow != "preference"
  //             ? _buildBody(context)
  //             : _buildKeyboard(context)),
  //   );
  // }

  final Map<String, Function> eventFuncs = {
    "blur": () => {/*can i use hideOnDeactives?*/windowManager.hide()},
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
