import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:studopedia/models/color_style.dart';

class LoadingBig extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      color: kSecondaryColor,
      child: Center(
          child: SpinKitChasingDots(
        color: Colors.white,
        size: 60.0,
      )),
    );
  }
}
