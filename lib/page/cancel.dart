import 'package:flutter/material.dart';

class Cancel extends StatefulWidget {
  @override
  _CancelState createState() => _CancelState();
}
class _CancelState extends State<Cancel> {
  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    return Offstage(
      offstage: true,
      child: IconButton(
        padding: EdgeInsets.only(left: 5.0),
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: Icon(
          Icons.close,
        ),
      ),
    );
  }

}