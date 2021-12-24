import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:switchsoulmonarch/keyboard.dart';
import 'package:switchsoulmonarch/state/apps_state.dart';

class AppsPane extends StatefulWidget {
  const AppsPane({Key? key}) : super(key: key);

  @override
  _AppsPaneState createState() => _AppsPaneState();
}

class _AppsPaneState extends State<AppsPane> {
  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  static const platform = MethodChannel('samples.flutter.dev/hoge');

  Future<void> _getHoge(String hoge, String key, WidgetRef ref) async {
    try {
      final result =
          await platform.invokeMethod('getBatteryLevel', <String, dynamic>{
        "hoge": hoge,
      });

      print(result);
      ref.read(appsStateNotifier.notifier).register(
          ShortcutApp(key: key, icon: result["image"], path: result["path"]));
    } on PlatformException catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  Function _selectFolder(WidgetRef ref) {
    return (String key) async {
      _resetState();
      try {
        String? path = await FilePicker.platform.getDirectoryPath(
            pickDirectory: false,
            allowedExtensions: ["app"],
            type: FileType.custom);
        setState(() {
          _getHoge(path!, key, ref);
        });
      } on PlatformException catch (e) {
        _logException('Unsupported operation' + e.toString());
      } catch (e) {
        _logException(e.toString());
      } finally {
        // setState(() => _isLoading = false);
      }
    };
  }

  void _deleteApp(String key, WidgetRef ref) async {
    ref.read(appsStateNotifier.notifier).delete(key);
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
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final _icons = ref.watch(appsStateNotifier).apps ?? {};
        return Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  KeyboardPage(
                      fn: _selectFolder(ref),
                      icons: _icons,
                      deleteApp: _deleteApp),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
