import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:studopedia/components/login_page.dart';
import 'package:studopedia/components/signup_tab.dart';
import 'package:studopedia/widgets/clipper_design.dart';
import 'package:studopedia/models/color_style.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    _tabController = TabController(length: 2, vsync: this);
  }

  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        color: Colors.white,
        height: size.height,
        child: Stack(
          children: <Widget>[
            ClipPath(
              clipper: ClipperDesign(),
              child: Container(
                width: double.infinity,
                height: size.height * 0.9,
                decoration: BoxDecoration(
                  gradient: kLinearGradient,
                ),
              ),
            ),
            Positioned.fill(
              top: (7.81 / 100) * size.height,
              left: 10.0,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      currentIndex == 0 ? 'Welcome back!' : 'Hello!',
                      style: TextStyle(
                        fontSize: 30.0,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 1.0),
                    Text(
                      currentIndex == 0
                          ? 'Login to access your account'
                          : 'Create a new account',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: (21.09 / 100) * size.height,
              left: 15.0,
              right: 15.0,
              child: Container(
                height: 470.0,
                width: size.width * 0.9,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 25.0,
                      offset: Offset(0.0, 3.0),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      TabBar(
                        onTap: (value) {
                          setState(() {
                            _tabController.index = value;
                            currentIndex = value;
                          });
                        },
                        indicatorColor: Colors.blue[900],
                        unselectedLabelColor: Colors.grey,
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 19.0,
                        ),
                        unselectedLabelStyle: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 16.5,
                        ),
                        labelColor: Theme.of(context).primaryColor,
                        tabs: [
                          Tab(
                            text: 'Login',
                          ),
                          Tab(
                            text: 'Sign Up',
                          )
                        ],
                        controller: _tabController,
                      ),
                      SizedBox(height: 10.0),
                      _tabController.index == 0 ? LoginPage() : SignupTab(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
