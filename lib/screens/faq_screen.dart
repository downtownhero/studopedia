import 'package:flutter/material.dart';

class FaqScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'How to use app?',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 20.0,
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              buildQuestion('1. Why is my file taking a long time to open?'),
              SizedBox(height: 5.0),
              buildAnswer(
                  'Files take a long time to open when your internet connection is slow or the size of the file is large. When you open the file for the first time the file is saved as a cache in your mobile for 30 days (only if you do not clear the cache of your phone). Try not clearing the cache of Studopedia for a faster and smoother experience.'),
              SizedBox(height: 11.0),
              buildQuestion('2. How to login or sign up?'),
              SizedBox(height: 5.0),
              buildAnswer(
                  'a. When you open the Studopedia app you are taken to the login/sign up screen.\nb. If you are a new user sign up with email and password or with simply with google.\nc. A new user must enter his/her details like name, college/school name, campus location, course/class, etc.\nd. If you are an old user just login with google or your email & password.'),
              SizedBox(height: 11.0),
              buildQuestion('3. Forgot password?'),
              SizedBox(height: 5.0),
              buildAnswer(
                  'a. Open the app.\nb. In the login/sign up screen, click on "Get help signing in" after entering your email.\nc. An email with reset password link will be sent to your email.'),
              SizedBox(height: 11.0),
              buildQuestion('4. How to upload a new file?'),
              SizedBox(height: 5.0),
              buildAnswer(
                  'a. Tap on the orange menu button present on the home page.\nb. Tap on the upload icon.\nc. In the upload screen select a Pdf, Excel, Docx, or PPT file and fill in the title of the file and description (optional).\nd. Tap on upload, and your file will be uploaded.'),
              SizedBox(height: 11.0),
              buildQuestion('5. How to make a new Noteslist?'),
              SizedBox(height: 5.0),
              buildAnswer(
                  'a. Tap on the orange menu button present on the home page.\nb. Tap on the folder icon.\nc. Enter your Noteslist title and click create.'),
              SizedBox(height: 11.0),
              buildQuestion('6. How to find your friends?'),
              SizedBox(height: 5.0),
              buildAnswer(
                  'a. Tap on the search icon.\nb. Enter your friend’s name or search by the college name.\nc. Select your friend profile and save his/her notes in your noteslist or save for later.\nd. Also, you can follow your friend so that you don’t need to search him/her again and again.'),
              SizedBox(height: 11.0),
              buildQuestion('7. How to add a file to Noteslist?'),
              SizedBox(height: 5.0),
              buildAnswer(
                  'a. Tap on the file you wish to add to Noteslist.\nb. Select an option for an existing or new Noteslist.\nc. If you select the existing Noteslist option then select the Noteslist you wish to add the file in.\d. If selecting for new Noteslist enter the title for the new list and then tap on create. The file will be automatically added to the new Noteslist.'),
              SizedBox(height: 11.0),
              buildQuestion('8. How to edit my profile?'),
              SizedBox(height: 5.0),
              buildAnswer(
                  'a. Go to the user screen.\nb. Tap on the menu icon or slide from right to left.\nc. Tap on Edit Profile.\nd. To edit your image select image and click “Update Image” or “Remove” to remove the image.\ne. Tap on “Update name” to update the name.\nf. Tap on “Update college” to update college/school name.\ng. Tap on “Update school” to update the college/school location.\nh. Tap on the “Update course” to update the course/class.'),
            ],
          ),
        ),
      ),
    );
  }

  Text buildAnswer(String ans) {
    return Text(
      ans,
      style: TextStyle(
        color: Colors.grey[800],
        fontSize: 15.0,
      ),
    );
  }

  Text buildQuestion(String question) {
    return Text(
      question,
      style: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w500,
        fontSize: 17.75,
      ),
    );
  }
}
