import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:switchsoulmonarch/keyboard.dart';
import 'package:switchsoulmonarch/state/apps_state.dart';
import 'package:switchsoulmonarch/state/mode_state.dart';

class AppsPane extends StatelessWidget {
  const AppsPane({Key? key, required this.show}) : super(key: key);

  final Function show;

  static const platform = MethodChannel('switch.soul.monarch/channel');

  Future<void> _getApp(String appPath, String key, WidgetRef ref) async {
    try {
      final result = await platform.invokeMethod('getApp', <String, dynamic>{
        "appPath": appPath,
      });

      ref.read(appsStateNotifier.notifier).register(
          ShortcutApp(key: key, icon: result["image"], path: result["path"]));
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Function _selectFolder(WidgetRef ref) {
    return (String key) async {
      ref.read(modeStateNotifier.notifier).setCanHide(false);
      try {
        final path = await FilePicker.platform.pickFiles(
            lockParentWindow: true,
            allowedExtensions: ["app"],
            type: FileType.custom);
        show();
        ref.read(modeStateNotifier.notifier).setCanHide(true);
        _getApp(path!.files.first.path!, key, ref);
      } on PlatformException catch (e) {
        print(e);
      } catch (e) {
        print(e);
      }
    };
  }

  Function _deleteApp(WidgetRef ref) {
    return (String key) async {
      ref.read(appsStateNotifier.notifier).delete(key);
    };
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
                      deleteApp: _deleteApp(ref)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
