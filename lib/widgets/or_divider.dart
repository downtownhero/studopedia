import 'package:flutter/material.dart';
import 'package:studopedia/models/color_style.dart';

class OrDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5.0),
      width: size.width * 0.6,
      child: Row(
        children: <Widget>[
          BuildDivider(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              'or',
              style: TextStyle(
                color: kSecondaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          BuildDivider(),
          Container()
        ],
      ),
    );
  }
}

class BuildDivider extends StatelessWidget {
  const BuildDivider({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Divider(
        color: kSecondaryColor,
        height: 1,
      ),
    );
  }
}
