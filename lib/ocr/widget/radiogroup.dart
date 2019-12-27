import 'package:flutter/material.dart';

typedef OnIndex = void Function(int index);

class RadioGroup extends StatefulWidget {
  OnIndex index;

  RadioGroup({this.index});

  @override
  _RadioGroupState createState() => _RadioGroupState();
}

class _RadioGroupState extends State<RadioGroup> {
  List<GroupModel> _group = [
    GroupModel(text: "识别文字", index: 1, checked: true),
    GroupModel(text: "翻译文字", index: 2, checked: false),
  ];

  List<Widget> buildWidgets() {
    List<Widget> list = List<Widget>();
    for (int i = 0; i < _group.length; i++) {
      list.add(Container(
        margin: EdgeInsets.only(left: 5.0, top: 15.0, bottom: 15.0, right: 5.0),
        decoration: BoxDecoration(
            color: _group[i].checked ? Color(0xFF1C68FF) : Colors.white,
            borderRadius: BorderRadius.circular(5.0)),
        child: FlatButton(
            onPressed: () {
              this.widget.index(i);
              setState(() {
                for (int i = 0; i < _group.length; i++) {
                  _group[i].checked = false;
                }
                _group[i].checked = !_group[i].checked;
              });
            },
            child: Text(
              _group[i].text,
              style: TextStyle(
                  color: _group[i].checked ? Colors.white : Colors.black),
            )),
      ));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: BoxConstraints.expand(height: 60.0),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: buildWidgets()));
  }
}

class GroupModel {
  String text;
  int index;
  bool checked = false;

  GroupModel({this.text, this.index, this.checked});
}
