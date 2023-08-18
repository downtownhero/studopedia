import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final Function onPress;
  final Color color, textColor;
  const RoundedButton({
    Key key,
    this.text,
    this.onPress,
    this.color,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.0),
          color: color,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6.0,
              offset: Offset(0.0, 4.0),
            ),
          ]),
      margin: EdgeInsets.symmetric(vertical: 10.0),
      width: size.width * 0.8,
      child: FlatButton(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
        onPressed: onPress,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16.0,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
