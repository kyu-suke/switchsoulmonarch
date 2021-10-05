import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:switchsoulmonarch/keyboard.dart';

class AppsPane extends StatefulWidget {
  @override
  _AppsPaneState createState() => _AppsPaneState();
}

class _AppsPaneState extends State<AppsPane> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  String? _fileName;
  String? _saveAsFileName;
  List<PlatformFile>? _paths;
  String? _directoryPath;
  String? _extension;
  bool _isLoading = false;
  bool _userAborted = false;
  bool _multiPick = false;
  FileType _pickingType = FileType.custom;
  TextEditingController _controller = TextEditingController(text: "app");


  Image? sampleimage;


  // call swift code
  static const platform = const MethodChannel('samples.flutter.dev/hoge');
  String _batteryLevel = 'Unknown battery level.';

  Future<void> _getHoge(String hoge) async {
    print("fuga");
    // Get battery level.
    String batteryLevel;
    try {
      final result = await platform.invokeMethod('getBatteryLevel', <String, dynamic>{
        "hoge": hoge,
      });
      print("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
      print(result);
      sampleimage = Image.memory(result);
      batteryLevel = 'Battery level at $result % .';
    } on PlatformException catch (e) {
      batteryLevel = "Failed to get battery level: '${e.message}'.";
    }
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => _extension = _controller.text);
  }

  void _selectFolder() async {
    _resetState();
    try {
      String? path = await FilePicker.platform.getDirectoryPath(
          pickDirectory: false,
          allowedExtensions: ["app"],
          type: FileType.custom
      );
      setState(() {
        _directoryPath = path;
        _userAborted = path == null;
        _getHoge(path!);
      });
    } on PlatformException catch (e) {
      _logException('Unsupported operation' + e.toString());
    } catch (e) {
      _logException(e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }


  void _logException(String message) {
    print(message);
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
      _isLoading = true;
      _directoryPath = null;
      _fileName = null;
      _paths = null;
      _saveAsFileName = null;
      _userAborted = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: _scaffoldMessengerKey,
      home: Scaffold(
        key: _scaffoldKey,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  KeyboardPage(fn: _selectFolder),
                  Padding(
                    padding: const EdgeInsets.only(top: 50.0, bottom: 20.0),
                    child: Column(
                      children: <Widget>[
                        ElevatedButton(
                          onPressed: () => _selectFolder(),
                          child: const Text('Pick folder'),
                        ),
                      ],
                    ),
                  ),
                  Builder(
                    builder: (BuildContext context) => _isLoading
                        ? Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: const CircularProgressIndicator(),
                    )
                        : _userAborted
                        ? Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: const Text(
                        'User has aborted the dialog',
                      ),
                    )
                        : _directoryPath != null
                        ? ListTile(
                      title: const Text('Directory path'),
                      subtitle: Text(_directoryPath!),
                    )
                        : _paths != null
                        ? Container(
                      padding:
                      const EdgeInsets.only(bottom: 30.0),
                      height:
                      MediaQuery.of(context).size.height *
                          0.50,
                      child: Scrollbar(
                          child: ListView.separated(
                            itemCount: _paths != null &&
                                _paths!.isNotEmpty
                                ? _paths!.length
                                : 1,
                            itemBuilder: (BuildContext context,
                                int index) {
                              final bool isMultiPath =
                                  _paths != null &&
                                      _paths!.isNotEmpty;
                              final String name =
                                  'File $index: ' +
                                      (isMultiPath
                                          ? _paths!
                                          .map((e) => e.name)
                                          .toList()[index]
                                          : _fileName ?? '...');
                              final path = _paths!
                                  .map((e) => e.path)
                                  .toList()[index]
                                  .toString();

                              return ListTile(
                                title: Text(
                                  name,
                                ),
                                subtitle: Text(path),
                              );
                            },
                            separatorBuilder:
                                (BuildContext context,
                                int index) =>
                            const Divider(),
                          )),
                    )
                        : _saveAsFileName != null
                        ? ListTile(
                      title: const Text('Save file'),
                      subtitle: Text(_saveAsFileName!),
                    )
                        : const SizedBox(),
                  ),
                  sampleimage == null ? Text("noneeeeeeeeeeeeeeeeeeee") : sampleimage!
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
