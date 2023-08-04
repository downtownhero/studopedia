import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:studopedia/models/color_style.dart';
import 'package:studopedia/models/user_data.dart';
import 'package:studopedia/screens/friend_screen.dart';
import 'package:studopedia/services/current_user.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  final _searchKey = GlobalKey<FormState>();
  String searchString;
  Future<QuerySnapshot> futureSearchResult;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  controlSearching(String value) {
    Future<QuerySnapshot> allFoundUsers = Firestore.instance
        .collection('users')
        .where('searchData', arrayContains: value)
        .getDocuments();
    setState(() {
      futureSearchResult = allFoundUsers;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        height: size.height,
        width: double.infinity,
        color: Theme.of(context).primaryColor,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: (7.03 / 100) * size.height),
                width: size.width * 0.90,
                padding: EdgeInsets.fromLTRB(0.0, 4, 6.0, 4),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30.0),
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0.0, 7.0),
                        color: Colors.black,
                        blurRadius: 4.0,
                      ),
                    ]),
                child: Form(
                  key: _searchKey,
                  child: TextFormField(
                    autofocus: false,
                    textCapitalization: TextCapitalization.words,
                    controller: searchController,
                    onChanged: (value) {
                      setState(() {
                        searchString = value;
                      });
                    },
                    onFieldSubmitted: (value) {
                      controlSearching(value.trim());
                    },
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 16.0, horizontal: 2.0),
                      border: InputBorder.none,
                      hintText: 'Search your friends',
                      prefixIcon: Icon(
                        Icons.people,
                        color: kSecondaryColor,
                      ),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          controlSearching(searchString.trim());
                        },
                        child: Container(
                          margin: EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                            color: kButtonColor,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                offset: Offset(0.0, 4.0),
                                color: Colors.black26,
                                blurRadius: 2.0,
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.search,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              futureSearchResult == null || searchString == ''
                  ? Container(
                      height: 200.0,
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      margin: EdgeInsets.only(top: (20.0 / 100) * size.height),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.people,
                            color: Colors.white38,
                            size: 26.0,
                          ),
                          SizedBox(height: 5.0),
                          Text(
                            'Find people by name or college',
                            style: TextStyle(
                              color: Colors.white38,
                              fontSize: 18.5,
                              fontWeight: FontWeight.w500,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container(
                      margin: EdgeInsets.only(top: 20.0),
                      height: size.height - ((26.0 / 100) * size.height),
                      padding: EdgeInsets.only(bottom: 10.0),
                      child: FutureBuilder(
                        future: futureSearchResult,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(
                              child: SpinKitChasingDots(
                                color: Colors.white,
                                size: 60.0,
                              ),
                            );
                          }
                          print(snapshot.data);
                          List<UserResult> searchResults = List<UserResult>();
                          snapshot.data.documents.forEach((document) {
                            UserData searchData =
                                UserData.fromDocument(document);
                            UserResult userResult = UserResult(searchData);
                            searchResults.add(userResult);
                          });
                          if (searchResults.isEmpty)
                            return Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(height: (24.0 / 100) * size.height),
                                  Text(
                                    'Oops!',
                                    style: TextStyle(
                                      color: Colors.white60,
                                      fontSize: 25.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 5.0),
                                  Text(
                                    'No user found. Try a different name.',
                                    style: TextStyle(
                                      color: Colors.white54,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FontStyle.italic,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            );
                          return ListView(
                            children: searchResults,
                          );
                        },
                      )),
            ],
          ),
        ),
      ),
    );
  }
}

class UserResult extends StatelessWidget {
  final UserData searchData;
  UserResult(this.searchData);
  @override
  Widget build(BuildContext context) {
    CurrentUser _currentUser = Provider.of<CurrentUser>(context, listen: false);
    if (_currentUser.getCurrentUserData.uid == searchData.uid) {
      return SizedBox(height: 0.0);
    }
    return GestureDetector(
      onTap: () async {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => FriendScreen(searchData)));
      },
      child: Container(
          height: 80.0,
          margin: EdgeInsets.fromLTRB(7.5, 0.0, 7.5, 11.0),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15.0),
              boxShadow: [
                BoxShadow(
                  offset: Offset(0.0, 4.0),
                  color: Colors.black,
                  blurRadius: 6.0,
                )
              ]),
          child: Row(
            children: <Widget>[
              searchData.imageUrl != null
                  ? Container(
                      margin: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: kSecondaryColor, width: 1.6),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black45,
                            blurRadius: 4.0,
                            offset: Offset(0.0, 3.0),
                          ),
                        ],
                        shape: BoxShape.circle,
                      ),
                      child: CircleAvatar(
                        radius: 30.0,
                        backgroundColor: Colors.white,
                        backgroundImage: NetworkImage(
                          searchData.imageUrl,
                        ),
                      ),
                    )
                  : Container(
                      margin: EdgeInsets.all(8.0),
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
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
                width: MediaQuery.of(context).size.width * 0.7,
                padding: EdgeInsets.fromLTRB(0.0, 5.0, 5.0, 5.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      searchData.fullName,
                      style: TextStyle(
                        color: kSecondaryColor,
                        fontSize: 17.0,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 1.5),
                    Text(
                      searchData.college,
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 15.0,
                        fontWeight: FontWeight.w400,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      searchData.course,
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 15.0,
                        fontWeight: FontWeight.w400,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
