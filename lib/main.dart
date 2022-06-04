import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:switchsoulmonarch/apps_pane.dart';
import 'package:switchsoulmonarch/database/apps_provider.dart';
import 'package:switchsoulmonarch/database/show_keyboard_window_provider.dart';
import 'package:switchsoulmonarch/hotkey_pane.dart';
import 'package:switchsoulmonarch/shortcut_window.dart';
import 'package:switchsoulmonarch/state/apps_state.dart';
import 'package:switchsoulmonarch/state/hotkey_holder_state.dart';
import 'package:switchsoulmonarch/state/mode_state.dart';
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
    windowManager.setResizable(false);
    windowManager.setSize(const Size(434, 130));

    // system tray setting
    final SsmSystemTray systemTray = SsmSystemTray();
    systemTray.getSystemTray(showPreference, terminateApp);
    super.initState();
  }

  static const platform = MethodChannel('switch.soul.monarch/channel');

  void showPreference() {
    ref.read(modeStateNotifier.notifier).setMode("preference");
    if (selectedPane == "apps") {
      windowManager.setSize(const Size(1300, 500), animate: false);
    } else {
      windowManager.setSize(const Size(434, 130), animate: false);
    }
    windowManager.show();
  }

  void terminateApp() {
    try {
      platform.invokeMethod('terminate', {});
    } on PlatformException catch (e) {
      print(e);
    }
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
    return AppsPane(
      show: windowManager.show,
    );
  }

  Widget _buildPane() {
    Widget pane;
    pane = _buildHotkeyPane();
    if (selectedPane == "apps") {
      pane = _buildAppsPane();
    }
    return pane;
  }

  Widget _leftSideButton(String label, String pane) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                  primary: Colors.black,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(0),
                    ),
                  )),
              child: Text(label),
              onPressed: () async {
                setState(() => selectedPane = pane);
                if (selectedPane == "apps") {
                  await windowManager.setSize(const Size(1300, 500),
                      animate: false);
                } else {
                  await windowManager.setSize(const Size(434, 130),
                      animate: false);
                }
              }),
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    return Row(
      children: [
        Expanded(
            flex: selectedPane == "apps" ? 1 : 3,
            child: Column(
              children: [
                _leftSideButton("Hotkey", "hotkey"),
                _leftSideButton("Apps", "apps"),
              ],
            )),
        Expanded(flex: selectedPane == "apps" ? 9 : 7, child: _buildPane()),
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
  }

  final Map<String, Function> eventFuncs = {
    "blur": () => {windowManager.hide()},
  };

  @override
  void onWindowEvent(String eventName) async {
    final size = await windowManager.getSize();
    print('[WindowManager] onWindowEvent: $eventName, size: $size');
    final eventFunc = eventFuncs[eventName];
    if (eventFunc != null) {
      final canHide = ref.watch(modeStateNotifier).canHide;
      if (canHide) {
        eventFunc();
      }
    }
  }
}
