import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:switchsoulmonarch/apps_pane.dart';
import 'package:switchsoulmonarch/database/apps_provider.dart';
import 'package:switchsoulmonarch/database/show_keyboard_window_provider.dart';
import 'package:switchsoulmonarch/hotkey_pane.dart';
import 'package:switchsoulmonarch/shortcut_window.dart';
import 'package:switchsoulmonarch/state/apps_state.dart';
import 'package:switchsoulmonarch/state/mode_state.dart';
import 'package:switchsoulmonarch/state/hotkey_holder_state.dart';
import 'package:switchsoulmonarch/system_tray.dart';
import 'package:window_manager/window_manager.dart';

final windowManager = WindowManager.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  // Use it only after calling `hiddenWindowAtLaunch`
  windowManager.waitUntilReadyToShow().then((_) async {
    await windowManager.setAsFrameless();
    await windowManager.show();
    await windowManager.setSkipTaskbar(true);
  });

  runApp(ProviderScope(
    child: HomePage(keyCombo: await getKeyCombo(), apps: await getApps()),
  ));
}

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key, this.keyCombo, this.apps}) : super(key: key);
  final SsmKeyCombo? keyCombo;
  final ShortcutApps? apps;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> with WindowListener {
  String selectedPane = "hotkey";

  final bool _isFullScreen = false;
  final bool _isResizable = false;
  final bool _isMinimizable = false;
  final bool _isClosable = false;

  @override
  void initState() {
    if (widget.keyCombo != null) {
      ref
          .read(windowHotKeyStateNotifier.notifier)
          .set(widget.keyCombo!.keyCombo!);
    }
    if (widget.apps != null) {
      ref.read(appsStateNotifier.notifier).setAll(widget.apps!);
    }

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
        ref.read(modeStateNotifier.notifier).setMode("preference");
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

  Future<void> showShortcutWindow() async {
      ref.read(modeStateNotifier.notifier).setMode("shortcuts");
    windowManager.setSize(const Size(1171, 470));
    windowManager.show();
  }

  Widget _buildHotkeyPane() {
    return HotKeyPane(fn: showShortcutWindow);
  }

  Widget _buildAppsPane() {
    return AppsPane(show: windowManager.show,);
  }

  Widget _buildUpdatePane() {
    return Center(
      child: Column(
        children: [
          OutlinedButton(
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
          OutlinedButton(
            child: Text("初期化。ホットキーとアプリ設定全部消します"),
            style: OutlinedButton.styleFrom(
                primary: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(0),
                  ),
                )),
            onPressed: () => setState(() => {}),
          ),
        ],
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
                _leftSideButton("Preference", "update"),
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
    return Consumer(
      builder: (context, ref, child) {
        final mode = ref.watch(modeStateNotifier).mode;
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            body: Container(
                child: mode == "preference"
                    ? _buildBody(context)
                    : _buildKeyboard(context)),
          ),
        );
      },
    );
    // return MaterialApp(
    //   debugShowCheckedModeBanner: false,
    //   home: Scaffold(
    //     body: Container(
    //         child: selectedWindow == "preference"
    //             ? _buildBody(context)
    //             : _buildKeyboard(context)),
    //   ),
    // );
  }

  final Map<String, Function> eventFuncs = {
    "blur": () => {windowManager.hide()},
  };

  @override
  void onWindowEvent(String eventName) {
    print('[WindowManager] onWindowEvent: $eventName');
    print(ref.watch(modeStateNotifier).canHide);
    final eventFunc = eventFuncs[eventName];
    if (eventFunc != null) {
      final canHide = ref.watch(modeStateNotifier).canHide;
      if (canHide) {
        eventFunc();
      }

    }
  }
}

// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
//
// void main() => runApp(const MyApp());
//
// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   static const String _title = 'Flutter Code Sample';
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: _title,
//       home: Scaffold(
//         appBar: AppBar(title: const Text(_title)),
//         body: const MyStatefulWidget(),
//       ),
//     );
//   }
// }
//
// class MyStatefulWidget extends StatefulWidget {
//   const MyStatefulWidget({Key? key}) : super(key: key);
//
//   @override
//   State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
// }
//
// class _MyStatefulWidgetState extends State<MyStatefulWidget> {
// // The node used to request the keyboard focus.
//   final FocusNode _focusNode = FocusNode();
// // The message to display.
//   String? _message;
//
// // Focus nodes need to be disposed.
//   @override
//   void dispose() {
//     _focusNode.dispose();
//     super.dispose();
//   }
//
// // Handles the key events from the RawKeyboardListener and update the
// // _message.
//   void _handleKeyEvent(RawKeyEvent event) {
//     setState(() {
//       if (event.logicalKey == LogicalKeyboardKey.keyQ) {
//         _message = 'Pressed the "Q" key!';
//       } else {
//         if (kReleaseMode) {
//           _message =
//           'Not a Q: Pressed 0x${event.logicalKey.keyId.toRadixString(16)}';
//         } else {
//           // The debugName will only print useful information in debug mode.
//           _message = 'Not a Q: Pressed ${event.logicalKey.debugName}';
//         }
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final TextTheme textTheme = Theme.of(context).textTheme;
//     return Container(
//       color: Colors.white,
//       alignment: Alignment.center,
//       child: DefaultTextStyle(
//         style: textTheme.headline4!,
//         child: RawKeyboardListener(
//           focusNode: _focusNode,
//           onKey: _handleKeyEvent,
//           child: AnimatedBuilder(
//             animation: _focusNode,
//             builder: (BuildContext context, Widget? child) {
//               if (!_focusNode.hasFocus) {
//                 return GestureDetector(
//                   onTap: () {
//                     FocusScope.of(context).requestFocus(_focusNode);
//                   },
//                   child: const Text('Tap to focus'),
//                 );
//               }
//               return Text(_message ?? 'Press a key');
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }
