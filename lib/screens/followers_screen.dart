import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:studopedia/models/color_style.dart';
import 'package:studopedia/models/followers_list.dart';
import 'package:studopedia/screens/friend_screen.dart';
import 'package:studopedia/services/current_user.dart';
import 'package:studopedia/widgets/loading_big.dart';

class FollowersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CurrentUser _currentUser = Provider.of<CurrentUser>(context, listen: false);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: StreamBuilder(
          stream: getFollowers(_currentUser.getCurrentUserData.uid),
          builder: (context, AsyncSnapshot<FollowersList> asyncSnapshot) {
            if (asyncSnapshot.data == null && asyncSnapshot.hasError) {
              return Text('Error');
            } else if (asyncSnapshot.data == null ||
                asyncSnapshot.connectionState != ConnectionState.done) {
              return backgroundContainer(
                size: size,
                child: Column(
                  children: <Widget>[
                    buildAppbar(size, context,
                        _currentUser.getCurrentUserData.fullName),
                    Padding(
                      padding:
                          EdgeInsets.only(top: (39.06 / 100) * size.height),
                      child: SpinKitChasingDots(
                        color: Colors.white,
                        size: 50.0,
                      ),
                    ),
                  ],
                ),
              );
            } else if (asyncSnapshot.data == null &&
                asyncSnapshot.connectionState == ConnectionState.done) {
              FollowersList followersList = asyncSnapshot.data;
              return backgroundContainer(
                size: size,
                child: Column(
                  children: <Widget>[
                    buildAppbar(size, context,
                        _currentUser.getCurrentUserData.fullName),
                    Padding(
                      padding:
                          EdgeInsets.only(top: (39.06 / 100) * size.height),
                      child: Text(
                        'Follow your friends!',
                        style: TextStyle(
                          color: Colors.white54,
                          fontWeight: FontWeight.w500,
                          fontSize: 20.0,
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              );
            } else if (asyncSnapshot.hasData) {
              FollowersList followersList = asyncSnapshot.data;
              return backgroundContainer(
                  size: size,
                  child: Column(
                    children: <Widget>[
                      buildAppbar(size, context,
                          _currentUser.getCurrentUserData.fullName),
                      SizedBox(height: 20.0),
                      Container(
                        height: size.height - (14.0 / 100) * size.height,
                        width: double.infinity,
                        child: followersList.followers.length == 0
                            ? Padding(
                                padding: EdgeInsets.only(
                                    top: (39.06 / 100) * size.height),
                                child: Text(
                                  'Follow your friends!',
                                  style: TextStyle(
                                    color: Colors.white54,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 20.0,
                                    fontStyle: FontStyle.italic,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              )
                            : ListView.builder(
                                itemCount: followersList.followers.length,
                                itemBuilder: (context, int index) {
                                  return GestureDetector(
                                    onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => FriendScreen(
                                            followersList.followers[index]),
                                      ),
                                    ),
                                    child: Container(
                                      height: 80.0,
                                      margin: EdgeInsets.fromLTRB(
                                          7.5, 0.0, 7.5, 11.0),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                          boxShadow: [
                                            BoxShadow(
                                              offset: Offset(0.0, 4.0),
                                              color: Colors.black,
                                              blurRadius: 6.0,
                                            )
                                          ]),
                                      child: Row(
                                        children: <Widget>[
                                          followersList.followers[index]
                                                      .imageUrl !=
                                                  null
                                              ? Container(
                                                  margin: EdgeInsets.all(8.0),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: kSecondaryColor,
                                                        width: 1.6),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.black45,
                                                        blurRadius: 4.0,
                                                        offset:
                                                            Offset(0.0, 3.0),
                                                      ),
                                                    ],
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: CircleAvatar(
                                                    radius: 30.0,
                                                    backgroundColor:
                                                        Colors.white,
                                                    backgroundImage:
                                                        NetworkImage(
                                                      followersList
                                                          .followers[index]
                                                          .imageUrl,
                                                    ),
                                                  ),
                                                )
                                              : Container(
                                                  margin: EdgeInsets.all(8.0),
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 8.0,
                                                      vertical: 5.0),
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: kSecondaryColor,
                                                  ),
                                                  child: Icon(
                                                    Icons.person,
                                                    size: 50.0,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                          SizedBox(width: 3.0),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.7,
                                            padding: EdgeInsets.fromLTRB(
                                                0.0, 5.0, 5.0, 5.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  followersList.followers[index]
                                                      .fullName,
                                                  style: TextStyle(
                                                    color: kSecondaryColor,
                                                    fontSize: 17.0,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                SizedBox(height: 1.5),
                                                Text(
                                                  followersList
                                                      .followers[index].college,
                                                  style: TextStyle(
                                                    color: Colors.grey[700],
                                                    fontSize: 15.0,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                Text(
                                                  followersList
                                                      .followers[index].course,
                                                  style: TextStyle(
                                                    color: Colors.grey[700],
                                                    fontSize: 15.0,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  ));
            }
            return LoadingBig();
          }),
    );
  }

  Container backgroundContainer({Size size, Widget child}) {
    return Container(
      height: size.height,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF12174a),
            Color(0xFF0d1036),
            Color(0xFF080a21),
          ],
          stops: [0.15, 0.5, 0.8],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        child: child,
      ),
    );
  }

  Container buildAppbar(Size size, BuildContext context, String name) {
    return Container(
      height: (7.03 / 100) * size.height,
      width: double.infinity,
      alignment: Alignment.topLeft,
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.arrow_back),
            iconSize: 25.0,
            color: Colors.white,
            onPressed: () => Navigator.pop(context),
          ),
          SizedBox(width: 15.0),
          Text(
            name,
            style: TextStyle(
              color: Colors.white,
              fontSize: 19.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

Stream<FollowersList> getFollowers(String uid) {
  return Firestore.instance
      .collection('users')
      .document(uid)
      .get()
      .then((querySnapshot) {
    try {
      return FollowersList.fromSnapshot(querySnapshot);
    } catch (e) {
      print(e);
      return null;
    }
  }).asStream();
}
