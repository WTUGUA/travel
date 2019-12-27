import 'package:flutter/material.dart';

typedef OnTap = void Function();

class MyCheckBox extends StatefulWidget {
  bool isChecked;
  covariant OnTap controller;

  MyCheckBox(this.isChecked, this.controller);

  @override
  _MyCheckBoxState createState() => _MyCheckBoxState();
}

class _MyCheckBoxState extends State<MyCheckBox> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: this.widget.controller,
      child: Container(
          margin: const EdgeInsets.all(5.0),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: this.widget.isChecked ? Color(0xFF1C68FF) : Colors.white,
            ),
            margin: const EdgeInsets.all(5.0),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: this.widget.isChecked
                  ? Icon(
                      Icons.check,
                      size: 15.0,
                      color: Colors.white,
                    )
                  : Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border:
                            Border.all(width: 2.0, color: Color(0xFFBABBBC)),
                        borderRadius:
                            new BorderRadius.all(new Radius.circular(7.0)),
                      ),
                      width: 15.0,
                      height: 15.0,
                    ),
            ),
          )),
    );
  }
}
