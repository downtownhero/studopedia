import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:studopedia/models/color_style.dart';

class StartScreen extends StatefulWidget {
  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  Alignment alignment;
  @override
  void initState() {
    super.initState();

    alignment = Alignment.topCenter;
  }

  void onPress() {
    setState(() {
      alignment = Alignment.bottomCenter;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: size.height,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TweenAnimationBuilder(
              tween: AlignmentTween(
                  begin: Alignment.topCenter, end: Alignment.bottomCenter),
              duration: Duration(seconds: 1),
              builder: (_, Alignment alignment, __) {
                return Container(
                  height: size.height / 2,
                  width: double.infinity,
                  alignment: alignment,
                  child: Material(
                    elevation: 3.0,
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(32.0),
                    child: Image(
                      image: AssetImage('assets/images/studopedia_icon.png'),
                      height: 148.0,
                      width: 145.0,
                      fit: BoxFit.contain,
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 10.0),
            Row(
              children: <Widget>[
                TweenAnimationBuilder(
                  tween: AlignmentTween(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  duration: Duration(seconds: 1),
                  builder: (_, Alignment alignment, __) {
                    return Container(
                      width: size.width / 2,
                      alignment: alignment,
                      child: Text(
                        'Studo',
                        style: TextStyle(
                          color: kSecondaryColor,
                          fontSize: 32.5,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'MeriendaOne',
                        ),
                      ),
                    );
                  },
                ),
                TweenAnimationBuilder(
                  tween: AlignmentTween(
                    begin: Alignment.centerRight,
                    end: Alignment.centerLeft,
                  ),
                  duration: Duration(seconds: 1),
                  builder: (_, Alignment alignment, __) {
                    return Container(
                      width: size.width / 2,
                      alignment: alignment,
                      child: Text(
                        'pedia',
                        style: TextStyle(
                          color: kButtonColor,
                          fontSize: 32.5,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'MeriendaOne',
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: 50.0),
            Center(
              child: TweenAnimationBuilder(
                tween: ColorTween(
                  begin: Colors.white,
                  end: Colors.blue,
                ),
                duration: Duration(seconds: 3),
                builder: (_, Color color, __) {
                  return SpinKitCircle(
                    color: color,
                    size: 50.0,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
