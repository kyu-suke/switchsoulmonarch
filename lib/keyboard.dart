import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class KeyboardPage extends StatefulWidget {
  const KeyboardPage({Key? key}) : super(key: key);

  @override
  State<KeyboardPage> createState() => _KeyboardPageState();
}

class IncrementIntent extends Intent {
  const IncrementIntent();
}

class DecrementIntent extends Intent {
  const DecrementIntent();
}

class Hoge extends Intent {
  const Hoge();
}

class _KeyboardPageState extends State<KeyboardPage> {

  Widget buildArrowKey(String keyName) {
    return GestureDetector(
        onTap: () {
          print("Container clicked at ${keyName}");
        },
        child: Container(
          width: 70,
          height: 30,
          margin: EdgeInsets.only(left: 5, right: 5, top: 2, bottom: 2),
          // color: Colors.red,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.red),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            keyName,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Theme.of(context).primaryColor,
              decoration: TextDecoration.none,
            ),
          ),
        ));
  }

  Widget buildEnterKey(String keyName, String position) {
    double width = 0;
    double height = 85;
    BorderRadius radius;
    BoxBorder border;
    EdgeInsetsGeometry? margin;
    BoxDecoration decoration;
    if (position == "top") {
      width = 100;
      radius = BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
          bottomLeft: Radius.circular(10));
      margin = EdgeInsets.only(top: 5, left: 5);

      decoration = const BoxDecoration(
        // border: Border(top: BorderSide(color: Colors.red), left: BorderSide(color: Colors.red),right: BorderSide(color: Colors.red),bottom: BorderSide(color: Colors.transparent)),
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
            bottomLeft: Radius.circular(10)),
        color: Colors.white,
      );
    } else {
      width = 80;
      // height = 85;
      radius = BorderRadius.only(
          bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10));
      margin = EdgeInsets.only(bottom: 5, left: 5);

      decoration = const BoxDecoration(
        // border: Border(top: BorderSide(color: Colors.transparent), left: BorderSide(color: Colors.red),right: BorderSide(color: Colors.red),bottom: BorderSide(color: Colors.red)),
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
        color: Colors.white,
      );
    }
    return GestureDetector(
        onTap: () {
          print("Container clicked at ${keyName}");
        },
        child: Container(
          width: width,
          height: height,
          margin: margin,
          // color: Colors.red,
          decoration: decoration,
          child: Text(
            keyName,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Theme.of(context).primaryColor,
              decoration: TextDecoration.none,
            ),
          ),
        ));
  }

  Widget buildKey(String keyName, {double width = 70, double height = 65}) {
    return GestureDetector(
        onTap: () {
          print("Container clicked at ${keyName}");
        },
        child: Container(
          width: width,
          height: height,
          margin: EdgeInsets.all(5),
          // color: Colors.red,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.red),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            keyName,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Theme.of(context).primaryColor,
              decoration: TextDecoration.none,
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: <ShortcutActivator, Intent>{
        LogicalKeySet(LogicalKeyboardKey.arrowUp): const IncrementIntent(),
        LogicalKeySet(LogicalKeyboardKey.arrowDown): const DecrementIntent(),
        LogicalKeySet(LogicalKeyboardKey.keyA): const Hoge(),
      },
      child: Actions(
        actions: <Type, Action<Intent>>{
          IncrementIntent: CallbackAction<IncrementIntent>(
            onInvoke: (IncrementIntent intent) => setState(() {
              print("AAA");
            }),
          ),
          DecrementIntent: CallbackAction<DecrementIntent>(
            onInvoke: (DecrementIntent intent) => setState(() {
              print("BBB");
            }),
          ),
          Hoge: CallbackAction<Hoge>(
            onInvoke: (Hoge intent) => setState(() {
              print("this is A");
            }),
          ),
        },
        child: Focus(
          autofocus: true,
          child: Container(
            child: Column(
              children: [
                Row(
                  children: [
                    buildKey("ESC", width: 100),
                    buildKey("F1"),
                    buildKey("F2"),
                    buildKey("F3"),
                    buildKey("F4"),
                    buildKey("F5"),
                    buildKey("F6"),
                    buildKey("F7"),
                    buildKey("F8"),
                    buildKey("F9"),
                    buildKey("F10"),
                    buildKey("F11"),
                    buildKey("F12"),
                    buildKey("鍵"),
                  ],
                ),
                Row(
                  children: [
                    buildKey("1", width: 85),
                    buildKey("2"),
                    buildKey("3"),
                    buildKey("4"),
                    buildKey("5"),
                    buildKey("6"),
                    buildKey("7"),
                    buildKey("8"),
                    buildKey("9"),
                    buildKey("0"),
                    buildKey("-"),
                    buildKey("^"),
                    buildKey("\\"),
                    buildKey("⌫", width: 85),
                  ],
                ),
                Container(
                  height: 75,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildKey("→"),
                      buildKey("q"),
                      buildKey("w"),
                      buildKey("e"),
                      buildKey("r"),
                      buildKey("t"),
                      buildKey("y"),
                      buildKey("u"),
                      buildKey("i"),
                      buildKey("o"),
                      buildKey("p"),
                      buildKey("@"),
                      buildKey("["),
                      buildEnterKey("↩", "top"),
                    ],
                  ),
                ),
                Container(
                  height: 75,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      buildKey("⌃", width: 90),
                      buildKey("a"),
                      buildKey("s"),
                      buildKey("d"),
                      buildKey("f"),
                      buildKey("g"),
                      buildKey("h"),
                      buildKey("j"),
                      buildKey("k"),
                      buildKey("l"),
                      buildKey(";"),
                      buildKey(":"),
                      buildKey("]"),
                      buildEnterKey("↩", "bottom"),
                    ],
                  ),
                ),
                Row(
                  children: [
                    buildKey("⇧", width: 125),
                    buildKey("z"),
                    buildKey("x"),
                    buildKey("c"),
                    buildKey("v"),
                    buildKey("b"),
                    buildKey("n"),
                    buildKey("m"),
                    buildKey(","),
                    buildKey("."),
                    buildKey("/"),
                    buildKey("_"),
                    buildKey("⇧", width: 125),
                  ],
                ),
                Row(
                  children: [
                    buildKey("⬆"),
                    buildKey("⌥"),
                    buildKey("⌘", width: 85),
                    buildKey("英数", width: 85),
                    buildKey("　", width: 280),
                    buildKey("かな", width: 85),
                    buildKey("⌘", width: 85),
                    buildKey("fn"),
                    buildKey("←"),
                    Column(
                      children: [
                        buildArrowKey("↑"),
                        buildArrowKey("↓"),
                      ],
                    ),
                    buildKey("→"),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
