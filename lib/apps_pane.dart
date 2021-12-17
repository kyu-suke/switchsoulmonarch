import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:switchsoulmonarch/keyboard.dart';
import 'package:switchsoulmonarch/state/apps_state.dart';

class AppsPane extends StatefulWidget {
  const AppsPane({Key? key}) : super(key: key);

  @override
  _AppsPaneState createState() => _AppsPaneState();
}

class _AppsPaneState extends State<AppsPane> {
  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  final ShortcutApps _icons = {};

  // call swift code
  static const platform = MethodChannel('samples.flutter.dev/hoge');

  Future<void> _getHoge(String hoge, String key) async {

    try {
      final result =
          await platform.invokeMethod('getBatteryLevel', <String, dynamic>{
        "hoge": hoge,
      });

      // print(result);
      //     final aaa = base64Encode(result);
      //     print(aaa);
      // final bbb = base64Decode(aaa);
      // print(bbb);

      context.read(appsStateNotifier.notifier).register(
          ShortcutApp(key: key, icon: result, path: ""));
      setState(() {

        _icons[key] = ShortcutApp(key: key, icon: result, path: "");
      });
    } on PlatformException catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  void _selectFolder(String key) async {
    _resetState();
    try {
      String? path = await FilePicker.platform.getDirectoryPath(
          pickDirectory: false,
          allowedExtensions: ["app"],
          type: FileType.custom);
      setState(() {
        // _directoryPath = path;
        // _userAborted = path == null;
        _getHoge(path!, key);
      });
    } on PlatformException catch (e) {
      _logException('Unsupported operation' + e.toString());
    } catch (e) {
      _logException(e.toString());
    } finally {
      // setState(() => _isLoading = false);
    }
  }

  void _logException(String message) {
    _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
    _scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  void _resetState() {
    if (!mounted) {
      return;
    }
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        final _icons = watch(appsStateNotifier).apps ?? {};

print("==~~~~~~~=======~~~~~~~~=~=");
print(_icons);
        return Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  KeyboardPage(fn: _selectFolder, icons: _icons),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
