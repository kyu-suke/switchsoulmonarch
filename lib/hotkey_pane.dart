import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:preference_list/preference_list.dart';

class HotKeyPane extends StatefulWidget {
  HotKeyPane({Key? key, required Function fn}) :
    showFunc = fn;

  Function showFunc;
  @override
  _HotKeyPaneState createState() => _HotKeyPaneState(showFunc: showFunc);
}

class _HotKeyPaneState extends State<HotKeyPane> {
  _HotKeyPaneState({Key? key, required Function showFunc}) : showFunc = showFunc;


  List<HotKey> _registeredHotKeyList = [];

  Function showFunc;

  @override
  void initState() {
    super.initState();
    HotKeyManager.instance.unregisterAll();
  }

  void _keyDownHandler(HotKey hotKey) {
    String log = 'keyDown ${hotKey.toString()} (${hotKey.scope})';
    // BotToast.showText(text: log);
    print(log);
    showFunc();
  }

  void _keyUpHandler(HotKey hotKey) {
    String log = 'keyUp   ${hotKey.toString()} (${hotKey.scope})';
    // BotToast.showText(text: log);
    print(log);
  }

  void _handleHotKeyRegister(HotKey hotKey) async {
    await HotKeyManager.instance.register(
      hotKey,
      keyDownHandler: _keyDownHandler,
      keyUpHandler: _keyUpHandler,
    );
    setState(() {
      _registeredHotKeyList = HotKeyManager.instance.registeredHotKeyList;
    });
  }

  void _handleHotKeyUnregister(HotKey hotKey) async {
    await HotKeyManager.instance.unregister(hotKey);
    setState(() {
      _registeredHotKeyList = HotKeyManager.instance.registeredHotKeyList;
    });
  }

  Future<void> _handleClickRegisterNewHotKey() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return RecordHotKeyDialog(
          onHotKeyRecorded: (newHotKey) => _handleHotKeyRegister(newHotKey),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context) {
    return PreferenceList(
      children: <Widget>[
        PreferenceListSection(
          title: Text('REGISTERED HOTKEY LIST'),
          children: [
            for (var registeredHotKey in _registeredHotKeyList)
              PreferenceListItem(
                padding: EdgeInsets.all(12),
                title: Row(
                  children: [
                    HotKeyVirtualView(hotKey: registeredHotKey),
                    SizedBox(width: 10),
                    Text(
                      registeredHotKey.scope.toString(),
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                accessoryView: Container(
                  width: 40,
                  height: 40,
                  child: CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Icon(
                          CupertinoIcons.delete,
                          size: 18,
                          color: Colors.red,
                        ),
                      ],
                    ),
                    onPressed: () => _handleHotKeyUnregister(registeredHotKey),
                  ),
                ),
              ),
            PreferenceListItem(
              title: Text(
                'Register a new HotKey',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),
              ),
              accessoryView: Container(),
              onTap: () {
                _handleClickRegisterNewHotKey();
              },
            ),
          ],
        ),
        PreferenceListSection(
          children: [
            PreferenceListItem(
              title: Text(
                'Unregister all HotKeys',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),
              ),
              accessoryView: Container(),
              onTap: () async {
                await HotKeyManager.instance.unregisterAll();
                _registeredHotKeyList =
                    HotKeyManager.instance.registeredHotKeyList;
                setState(() {});
              },
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return  _buildBody(context);
  }
}

class RecordHotKeyDialog extends StatefulWidget {
  final ValueChanged<HotKey> onHotKeyRecorded;

  const RecordHotKeyDialog({
    Key? key,
    required this.onHotKeyRecorded,
  }) : super(key: key);

  @override
  _RecordHotKeyDialogState createState() => _RecordHotKeyDialogState();
}

class _RecordHotKeyDialogState extends State<RecordHotKeyDialog> {
  HotKey _hotKey = HotKey(null);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      // title: Text('Rewind and remember'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text('The `HotKeyRecorder` widget will record your hotkey.'),
            Container(
              width: 100,
              height: 60,
              margin: EdgeInsets.only(top: 20),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).primaryColor,
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  HotKeyRecorder(
                    onHotKeyRecorded: (hotKey) {
                      _hotKey = hotKey;
                      setState(() {});
                    },
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Checkbox(
                  value: _hotKey.scope == HotKeyScope.inapp,
                  onChanged: (newValue) {
                    _hotKey.scope =
                        newValue! ? HotKeyScope.inapp : HotKeyScope.system;
                    setState(() {});
                  },
                ),
                Text('Set as inapp-wide hotkey. (default is system-wide)'),
              ],
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text('OK'),
          onPressed: !_hotKey.isSetted
              ? null
              : () {
                  widget.onHotKeyRecorded(_hotKey);
                  Navigator.of(context).pop();
                },
        ),
      ],
    );
  }
}


