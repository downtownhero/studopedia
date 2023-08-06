import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class TermsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Terms & Conditions',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 20.0,
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 12.0, vertical: 18.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'When you set up a new Studopedia account, we store your basic information like -',
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                '1. Email address\n2. Name\n3. College/School name\n4. Course/Class enrolled',
                style: TextStyle(
                  fontSize: 17.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                'We store this information so that other users can find you and see your uploaded notes or files and follow you.',
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              SizedBox(height: 6.0),
              Text(
                'Any inappropriate, offensive, discriminatory, or other harmful data uploaded that harms a person, religion, or anyone else, will be deleted and strict action will be taken against the user.',
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              SizedBox(height: 10.0),
              Text(
                'For any other queries email us.',
                style: TextStyle(
                  fontSize: 17.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 3.0),
              GestureDetector(
                onTap: () {
                  final Uri _emailLaunchUri = Uri(
                      scheme: 'mailto',
                      path: 'studopediaapp@gmail.com',
                      queryParameters: {
                        'subject': 'Terms & Conditions query',
                      });
                  launch(_emailLaunchUri.toString());
                },
                child: Text(
                  'Click here to email',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.blueAccent,
                    fontSize: 17.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
