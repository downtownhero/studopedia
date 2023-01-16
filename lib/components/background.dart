import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:studopedia/models/color_style.dart';

class Background extends StatelessWidget {
  const Background({
    Key key,
    @required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Container(
        height: size.height,
        color: Theme.of(context).primaryColor,
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Positioned(
                    top: 45.0,
                    left: 20.0,
                    child: Text(
                      'Home',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 40.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Positioned(
                    top: -40,
                    right: -15,
                    child: Container(
                      width: size.width * 0.665,
                      height: size.height * 0.28,
                      decoration: BoxDecoration(
                        gradient: kLinearGradient,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(180.0),
                          bottomRight: Radius.circular(80.0),
                        ),
                      ),
                    ),
                  ),
                  child,
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
