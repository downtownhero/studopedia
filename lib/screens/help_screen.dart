import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:studopedia/models/color_style.dart';
import 'package:studopedia/screens/faq_screen.dart';

class HelpScreen extends StatelessWidget {
  void openMail(String subject) {
    final Uri _emailLaunchUri = Uri(
        scheme: 'mailto',
        path: 'studopediaapp@gmail.com',
        queryParameters: {
          'subject': subject,
        });
    launch(_emailLaunchUri.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Help & Feedback',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 21.0,
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          SizedBox(height: 10.0),
          Container(
            height: 150.0,
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 12.0),
            decoration: BoxDecoration(
                color: Colors.white70,
                borderRadius: BorderRadius.circular(15.0),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0.0, 4.0),
                    color: Colors.black26,
                    blurRadius: 4.0,
                  )
                ]),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Need help?',
                  style: TextStyle(
                    color: kSecondaryColor,
                    fontSize: 22.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 32.5),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FaqScreen(),
                      ),
                    );
                  },
                  child: Container(
                    height: 30.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Icon(
                          Icons.help_outline,
                          color: kSecondaryColor,
                        ),
                        SizedBox(width: 10.0),
                        Text(
                          'FAQs',
                          style: TextStyle(
                            color: Colors.grey[800],
                            fontSize: 17.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 2.0),
                GestureDetector(
                  onTap: () {
                    openMail('Issue');
                  },
                  child: Container(
                    height: 30.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Icon(
                          Icons.edit,
                          color: kSecondaryColor,
                        ),
                        SizedBox(width: 10.0),
                        Text(
                          'Write to us for any other issues.',
                          style: TextStyle(
                            color: Colors.grey[800],
                            fontSize: 17.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 150.0,
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 12.0),
            decoration: BoxDecoration(
                color: Colors.white70,
                borderRadius: BorderRadius.circular(15.0),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0.0, 4.0),
                    color: Colors.black26,
                    blurRadius: 4.0,
                  )
                ]),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Feedback',
                  style: TextStyle(
                    color: kSecondaryColor,
                    fontSize: 22.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 32.5),
                GestureDetector(
                  onTap: () {
                    openMail('Feedback');
                  },
                  child: Container(
                    height: 30.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Icon(
                          Icons.feedback,
                          color: kSecondaryColor,
                        ),
                        SizedBox(width: 10.0),
                        Text(
                          'Write your feedback.',
                          style: TextStyle(
                            color: Colors.grey[800],
                            fontSize: 17.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 2.0),
                GestureDetector(
                  onTap: () {
                    openMail('Suggestions');
                  },
                  child: Container(
                    height: 30.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Icon(
                          Icons.chat_bubble_outline,
                          color: kSecondaryColor,
                        ),
                        SizedBox(width: 10.0),
                        Text(
                          'Any suggestions? Write to us.',
                          style: TextStyle(
                            color: Colors.grey[800],
                            fontSize: 17.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
