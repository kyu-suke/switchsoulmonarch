import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:switchsoulmonarch/keycode.dart';
import 'package:switchsoulmonarch/state/apps_state.dart';

class KeyboardPage extends StatefulWidget {
  const KeyboardPage(
      {Key? key, required this.fn, required this.icons, this.deleteApp})
      : super(key: key);

  final Function fn;
  final ShortcutApps icons;
  final Function? deleteApp;

  @override
  State<KeyboardPage> createState() => _KeyboardPageState();
}

class _KeyboardPageState extends State<KeyboardPage> {
  Widget _keyLabel(String keyName) {
    return Stack(
      children: [
        widget.icons[keyName] == null
            ? Text("")
            : Image.memory(widget.icons[keyName]!.icon),
        widget.icons[keyName] == null
            ? Text("")
            : Transform.rotate(
                angle: 45 * math.pi / 180,
                child: IconButton(
                  splashRadius: 10,
                  iconSize: 30,
                  onPressed: widget.deleteApp != null
                      ? () => {widget.deleteApp!(keyName)}
                      : () => {},
                  icon: const Icon(Icons.add_circle_outline_outlined,
                      color: Colors.red),
                ),
              ),
        Text(
          keyName,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Theme.of(context).primaryColor,
            decoration: TextDecoration.none,
          ),
        ),
      ],
    );
  }

  Widget _gestureDetector(String keyName, Function fn, String key, double width,
      double height, EdgeInsetsGeometry margin, BoxDecoration decoration) {
    return GestureDetector(
        onTap: () => {fn(key)},
        child: Container(
          width: width,
          height: height,
          margin: margin,
          // color: Colors.red,
          decoration: decoration,
          child: _keyLabel(keyName),
        ));
  }

  Widget buildArrowKey(String keyName, Function fn) {
    return _gestureDetector(
        keyName,
        fn,
        keyName,
        70,
        30,
        const EdgeInsets.only(left: 5, right: 5, top: 2, bottom: 2),
        BoxDecoration(
          border: Border.all(color: Colors.red),
          borderRadius: BorderRadius.circular(10),
        ));
  }

  Widget buildEnterKey(String keyName, Function fn, String position) {
    double width = 0;
    double height = 85;
    EdgeInsetsGeometry? margin;
    BoxDecoration decoration;
    if (position == "top") {
      width = 100;
      margin = const EdgeInsets.only(top: 5, left: 5);
      decoration = const BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
            bottomLeft: Radius.circular(10)),
        color: Colors.white,
      );
    } else {
      width = 80;
      margin = const EdgeInsets.only(bottom: 5, left: 5);
      decoration = const BoxDecoration(
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
        color: Colors.white,
      );
    }
    return _gestureDetector(
        keyName, fn, keyName, width, height, margin, decoration);
  }

  Widget buildKey(String keyName, Function fn,
      {double width = 70, double height = 65}) {
    return _gestureDetector(
        keyName,
        fn,
        keyName,
        width,
        height,
        const EdgeInsets.all(5),
        BoxDecoration(
          border: Border.all(color: Colors.red),
          borderRadius: BorderRadius.circular(10),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              buildKey("Esc", widget.fn, width: 100),
              ...[
                "F1",
                "F2",
                "F3",
                "F4",
                "F5",
                "F6",
                "F7",
                "F8",
                "F9",
                "F10",
                "F11",
                "F12",
                "鍵"
              ].map((e) => buildKey(e, widget.fn)),
            ],
          ),
          Row(
            children: [
              buildKey("1", widget.fn, width: 85),
              ...["2", "3", "4", "5", "6", "7", "8", "9", "0", "-", "^", "\\"]
                  .map((e) => buildKey(e, widget.fn)),
              buildKey("⌫", widget.fn, width: 85),
            ],
          ),
          Container(
            height: 75,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...[
                  "→",
                  "q",
                  "w",
                  "e",
                  "r",
                  "t",
                  "y",
                  "u",
                  "i",
                  "o",
                  "p",
                  "@",
                  "["
                ].map((e) => buildKey(e, widget.fn)),
                buildEnterKey("↩", widget.fn, "top"),
              ],
            ),
          ),
          Container(
            height: 75,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                buildKey("⌃", widget.fn, width: 90),
                ...[
                  SsmKeys.a.label!,
                  "s",
                  "d",
                  "f",
                  "g",
                  "h",
                  "j",
                  "k",
                  "l",
                  ";",
                  ":",
                  "]"
                ].map((e) => buildKey(e, widget.fn)),
                buildEnterKey("↩", widget.fn, "bottom"),
              ],
            ),
          ),
          Row(
            children: [
              buildKey("⇧", widget.fn, width: 125),
              ...["z", "x", "c", "v", "b", "n", "m", ",", ".", "/", "_"]
                  .map((e) => buildKey(e, widget.fn)),
              buildKey("⇧", widget.fn, width: 125),
            ],
          ),
          Row(
            children: [
              buildKey("⬆", widget.fn),
              buildKey("⌥", widget.fn),
              buildKey("⌘", widget.fn, width: 85),
              buildKey("英数", widget.fn, width: 85),
              buildKey("　", widget.fn, width: 280),
              buildKey("かな", widget.fn, width: 85),
              buildKey("⌘", widget.fn, width: 85),
              buildKey("fn", widget.fn),
              buildKey("←", widget.fn),
              Column(
                children: [
                  buildArrowKey("↑", widget.fn),
                  buildArrowKey("↓", widget.fn),
                ],
              ),
              buildKey("→", widget.fn),
            ],
          ),
        ],
      ),
    );
  }
}
