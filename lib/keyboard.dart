import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:switchsoulmonarch/keycode.dart';
import 'package:switchsoulmonarch/state/apps_state.dart';

class KeyboardPage extends StatelessWidget {
  const KeyboardPage(
      {Key? key,
      required this.fn,
      required this.icons,
      this.deleteApp,
      this.mode = "preference"})
      : super(key: key);

  final Function fn;
  final ShortcutApps icons;
  final Function? deleteApp;
  final String mode;

  Widget _keyLabel(String keyName) {
    return Stack(
      children: [
        icons[keyName] == null
            ? const SizedBox(width: 0, height: 0)
            : Stack(
                children: [
                  Container(
                      padding: const EdgeInsets.only(top: 6),
                      child: Center(
                          child: Image.memory(icons[keyName]!.icon,
                              width: 50))),
                  if (mode == "preference")
                    Container(
                      padding: const EdgeInsets.only(bottom: 20, left: 30),
                      child: Center(
                        child: Transform.rotate(
                          angle: 45 * math.pi / 180,
                          child: IconButton(
                            splashRadius: 10,
                            iconSize: 30,
                            onPressed: () => {deleteApp!(keyName)},
                            icon: const Icon(Icons.add_circle_outline_outlined,
                                color: Colors.grey, size: 20),
                          ),
                        ),
                      ),
                    )
                ],
              ),
        Container(
          padding: const EdgeInsets.only(top: 2, left: 5),
          child: Text(
            keyName == "fn" ? keyName : keyName.toUpperCase(),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.grey,
              decoration: TextDecoration.none,
            ),
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
          border: Border.all(color: Colors.grey),
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
      decoration = BoxDecoration(
        border: Border.all(color: Colors.transparent),
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
            bottomLeft: Radius.circular(10)),
        color: Colors.grey.withOpacity(0.2),
      );
    } else {
      width = 90;
      keyName = "";
      margin = const EdgeInsets.only(bottom: 5, left: 5);
      decoration = BoxDecoration(
        border: Border.all(color: Colors.transparent),
        borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
        color: Colors.grey.withOpacity(0.2),
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
          border: Border.all(color: Colors.grey),
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
              buildKey("Esc", fn, width: 100),
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
              ].map((e) => buildKey(e, fn)),
            ],
          ),
          Row(
            children: [
              buildKey("1", fn, width: 85),
              ...["2", "3", "4", "5", "6", "7", "8", "9", "0", "-", "^", "\\"]
                  .map((e) => buildKey(e, fn)),
              buildKey("⌫", fn, width: 85),
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
                ].map((e) => buildKey(e, fn)),
                buildEnterKey("↩", fn, "top"),
              ],
            ),
          ),
          Container(
            height: 75,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                buildKey("⌃", fn, width: 80),
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
                ].map((e) => buildKey(e, fn)),
                buildEnterKey("↩", fn, "bottom"),
              ],
            ),
          ),
          Row(
            children: [
              buildKey("⇧", fn, width: 125),
              ...["z", "x", "c", "v", "b", "n", "m", ",", ".", "/", "_"]
                  .map((e) => buildKey(e, fn)),
              buildKey("⇧", fn, width: 125),
            ],
          ),
          Row(
            children: [
              buildKey("⬆", fn),
              buildKey("⌥", fn),
              buildKey("⌘", fn, width: 85),
              buildKey("英数", fn, width: 85),
              buildKey("　", fn, width: 280),
              buildKey("かな", fn, width: 85),
              buildKey("⌘", fn, width: 85),
              buildKey("fn", fn),
              buildKey("←", fn),
              Column(
                children: [
                  buildArrowKey("↑", fn),
                  buildArrowKey("↓", fn),
                ],
              ),
              buildKey("→", fn),
            ],
          ),
        ],
      ),
    );
  }
}
