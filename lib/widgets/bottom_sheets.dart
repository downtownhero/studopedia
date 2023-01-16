import 'package:flutter/material.dart';
import 'package:studopedia/models/color_style.dart';
import 'package:studopedia/screens/bottom_nav_screen.dart';
import 'package:studopedia/screens/pdf_screen.dart';
import 'package:studopedia/services/database.dart';
import 'dart:io';
import 'package:open_file/open_file.dart';
import 'loading_dialog.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class BottomSheets {
  GestureDetector buildBoxes(
      {Size size,
      String text,
      IconData iconData,
      double width,
      Function onPress}) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
          margin: EdgeInsets.symmetric(horizontal: 5.0),
          padding: EdgeInsets.only(left: 8.0, right: 2.0),
          height: (7.7 / 100) * size.height,
          width: width,
          decoration: BoxDecoration(
            color: kSecondaryColor,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black,
                offset: Offset(0.0, 6.0),
                blurRadius: 4.0,
              ),
            ],
          ),
          child: Row(
            children: <Widget>[
              Icon(
                iconData,
                color: Colors.white,
                size: 22.0,
              ),
              SizedBox(width: 7.0),
              Text(
                text,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          )),
    );
  }

  void modalBottomSheet({
    BuildContext context,
    String uid,
    String title,
    String des,
    String fileUrl,
    String format,
    Color color,
    Function onPressNew,
    GlobalKey<ScaffoldState> scaffoldKey,
  }) {
    Size size = MediaQuery.of(context).size;
    showModalBottomSheet(
        context: context,
        backgroundColor: kSecondaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        builder: (BuildContext context) {
          return sheetContainer(
            size: size,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  titleContainer(size, title),
                  SizedBox(height: (1.56 / 100) * size.height),
                  desContainer(size, des),
                  SizedBox(height: (3.90 / 100) * size.height),
                  openButton(context, fileUrl, title, format, size, color),
                  SizedBox(height: (3.90 / 100) * size.height),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      buildBoxes(
                        size: size,
                        text: 'Save',
                        iconData: Icons.bookmark_border,
                        width: size.width * 0.26,
                        onPress: () async {
                          {
                            var val = [];
                            var map = {
                              'title': title,
                              'des': des,
                              'fileUrl': fileUrl
                            };
                            val.add(map);
                            String returnString = await Database().saveForLater(
                              val,
                              uid,
                            );
                            if (returnString == 'Success') {
                              LoadingDialog().infoDialogBox(
                                context: scaffoldKey.currentState.context,
                                loadingText: 'Successful',
                                color: Colors.green,
                                icon: Icons.check,
                                onPressed: () => Navigator.pop(
                                    scaffoldKey.currentState.context),
                              );
                            } else {
                              LoadingDialog().infoDialogBox(
                                context: scaffoldKey.currentState.context,
                                loadingText: 'Error',
                                contentText: 'Try again later',
                                color: Colors.red,
                                icon: Icons.close,
                                onPressed: () => Navigator.pop(
                                    scaffoldKey.currentState.context),
                              );
                            }
                          }
                        },
                      ),
                      buildBoxes(
                        size: size,
                        text: 'Noteslist',
                        iconData: Icons.playlist_add,
                        width: size.width * 0.33,
                        onPress: () {
                          LoadingDialog().chooseListDialogBox(
                            context: context,
                            onPressEx: () async {
                              Navigator.pop(context);
                              List titleList =
                                  await Database().notesListTitles(uid);
                              showDialog(
                                  context: scaffoldKey.currentState.context,
                                  builder: (BuildContext context) {
                                    return titleList.length == 0 ||
                                            titleList.length == null
                                        ? AlertDialog(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        20.0)),
                                            title: Text(
                                              'Select Noteslist',
                                              style: TextStyle(
                                                  color:
                                                      Colors.deepOrange[800]),
                                            ),
                                            content: Container(
                                              height:
                                                  (39.06 / 100) * size.height,
                                              width: (25.47 / 100) * size.width,
                                              child: Center(
                                                child: Text(
                                                  'No noteslist found',
                                                  style: TextStyle(
                                                    color: kSecondaryColor,
                                                    fontSize: 20.0,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        : AlertDialog(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        20.0)),
                                            title: Text(
                                              'Select Noteslist',
                                              style: TextStyle(
                                                  color:
                                                      Colors.deepOrange[800]),
                                            ),
                                            content: Container(
                                              height: 250.0,
                                              width: (25.47 / 100) *
                                                  MediaQuery.of(context)
                                                      .size
                                                      .width,
                                              child: ListView.builder(
                                                  itemCount: titleList.length,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    return GestureDetector(
                                                      onTap: () async {
                                                        LoadingDialog().dialogBox(
                                                            context: scaffoldKey
                                                                .currentState
                                                                .context,
                                                            loadingText:
                                                                'Loading...');
                                                        String returnString =
                                                            await Database()
                                                                .createNewList(
                                                          uid: uid,
                                                          listTitle:
                                                              titleList[index],
                                                          title: title,
                                                          des: des,
                                                          fileUrl: fileUrl,
                                                        );
                                                        if (returnString ==
                                                            'Success') {
                                                          Navigator.pop(
                                                              context);
                                                          Navigator.pop(
                                                              context);
                                                          LoadingDialog()
                                                              .infoDialogBox(
                                                            context: scaffoldKey
                                                                .currentState
                                                                .context,
                                                            loadingText:
                                                                'Successful',
                                                            color: Colors.green,
                                                            icon: Icons.check,
                                                            onPressed: () =>
                                                                Navigator.pop(
                                                                    scaffoldKey
                                                                        .currentState
                                                                        .context),
                                                          );
                                                        } else {
                                                          Navigator.pop(
                                                              context);
                                                          Navigator.pop(
                                                              context);
                                                          LoadingDialog()
                                                              .infoDialogBox(
                                                            context: scaffoldKey
                                                                .currentState
                                                                .context,
                                                            loadingText:
                                                                'Error',
                                                            onPressed: () =>
                                                                Navigator.pop(
                                                                    scaffoldKey
                                                                        .currentState
                                                                        .context),
                                                            contentText:
                                                                'Try again later',
                                                            color: Colors.red,
                                                            icon: Icons.close,
                                                          );
                                                        }
                                                      },
                                                      child: Container(
                                                        margin: EdgeInsets
                                                            .symmetric(
                                                                vertical: 5.0),
                                                        height: 40.0,
                                                        decoration:
                                                            BoxDecoration(
                                                                border:
                                                                    Border.all(
                                                                  color:
                                                                      kSecondaryColor,
                                                                  width: 1.0,
                                                                ),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10.0),
                                                                color: Colors
                                                                    .white,
                                                                boxShadow: [
                                                              BoxShadow(
                                                                offset: Offset(
                                                                    0.0, 1.5),
                                                                color: Colors
                                                                    .black45,
                                                              ),
                                                            ]),
                                                        child: Center(
                                                          child: Text(
                                                            titleList[index],
                                                            style: TextStyle(
                                                              color:
                                                                  kSecondaryColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              fontSize: 18.0,
                                                            ),
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  }),
                                            ),
                                          );
                                  });
                            },
                            onPressNew: onPressNew,
                          );
                        },
                      ),
                      buildBoxes(
                        size: size,
                        text: 'Delete',
                        iconData: Icons.delete_outline,
                        width: size.width * 0.28,
                        onPress: () async {
                          LoadingDialog().dialogBox(
                              context: scaffoldKey.currentState.context,
                              loadingText: 'Deleting...');
                          await Database()
                              .deleteMyFile(
                            uid: uid,
                            title: title,
                            des: des,
                            fileUrl: fileUrl,
                          )
                              .whenComplete(() {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BottomNavScreen(),
                              ),
                              (route) => false,
                            );
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  void friendBottomSheet({
    BuildContext context,
    String uid,
    String title,
    String des,
    String fileUrl,
    String format,
    Color color,
    Function onPressNew,
    GlobalKey<ScaffoldState> scaffoldKey,
  }) {
    Size size = MediaQuery.of(context).size;
    showModalBottomSheet(
        context: context,
        backgroundColor: kSecondaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        builder: (BuildContext context) {
          return sheetContainer(
              size: size,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    titleContainer(size, title),
                    SizedBox(height: (1.56 / 100) * size.height),
                    desContainer(size, des),
                    SizedBox(height: (3.90 / 100) * size.height),
                    openButton(context, fileUrl, title, format, size, color),
                    SizedBox(height: (3.90 / 100) * size.height),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        buildBoxes(
                          size: size,
                          text: 'Save',
                          iconData: Icons.bookmark_border,
                          width: size.width * 0.3,
                          onPress: () async {
                            {
                              var val = [];
                              var map = {
                                'title': title,
                                'des': des,
                                'fileUrl': fileUrl
                              };
                              val.add(map);
                              String returnString =
                                  await Database().saveForLater(
                                val,
                                uid,
                              );
                              if (returnString == 'Success') {
                                LoadingDialog().infoDialogBox(
                                  context: scaffoldKey.currentState.context,
                                  loadingText: 'Successful',
                                  color: Colors.green,
                                  icon: Icons.check,
                                  onPressed: () => Navigator.pop(
                                      scaffoldKey.currentState.context),
                                );
                              } else {
                                LoadingDialog().infoDialogBox(
                                  context: scaffoldKey.currentState.context,
                                  loadingText: 'Error',
                                  contentText: 'Try again later',
                                  color: Colors.red,
                                  icon: Icons.close,
                                  onPressed: () => Navigator.pop(
                                      scaffoldKey.currentState.context),
                                );
                              }
                            }
                          },
                        ),
                        SizedBox(width: 5.0),
                        buildBoxes(
                          size: size,
                          text: 'Noteslist',
                          iconData: Icons.playlist_add,
                          width: size.width * 0.33,
                          onPress: () {
                            LoadingDialog().chooseListDialogBox(
                              context: context,
                              onPressEx: () async {
                                Navigator.pop(context);
                                List titleList =
                                    await Database().notesListTitles(uid);
                                showDialog(
                                    context: scaffoldKey.currentState.context,
                                    builder: (BuildContext context) {
                                      return titleList.length == 0 ||
                                              titleList.length == null
                                          ? AlertDialog(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0)),
                                              title: Text(
                                                'Select Noteslist',
                                                style: TextStyle(
                                                    color:
                                                        Colors.deepOrange[800]),
                                              ),
                                              content: Container(
                                                height:
                                                    (39.06 / 100) * size.height,
                                                width:
                                                    (25.47 / 100) * size.width,
                                                child: Center(
                                                  child: Text(
                                                    'No noteslist found',
                                                    style: TextStyle(
                                                      color: kSecondaryColor,
                                                      fontSize: 20.0,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                          : AlertDialog(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0)),
                                              title: Text(
                                                'Select Noteslist',
                                                style: TextStyle(
                                                    color:
                                                        Colors.deepOrange[800]),
                                              ),
                                              content: Container(
                                                height: 250.0,
                                                width: (25.47 / 100) *
                                                    MediaQuery.of(context)
                                                        .size
                                                        .width,
                                                child: ListView.builder(
                                                    itemCount: titleList.length,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      return GestureDetector(
                                                        onTap: () async {
                                                          LoadingDialog().dialogBox(
                                                              context: scaffoldKey
                                                                  .currentState
                                                                  .context,
                                                              loadingText:
                                                                  'Loading...');
                                                          String returnString =
                                                              await Database()
                                                                  .createNewList(
                                                            uid: uid,
                                                            listTitle:
                                                                titleList[
                                                                    index],
                                                            title: title,
                                                            des: des,
                                                            fileUrl: fileUrl,
                                                          );
                                                          if (returnString ==
                                                              'Success') {
                                                            Navigator.pop(
                                                                context);
                                                            Navigator.pop(
                                                                context);
                                                            LoadingDialog()
                                                                .infoDialogBox(
                                                              context: scaffoldKey
                                                                  .currentState
                                                                  .context,
                                                              loadingText:
                                                                  'Successful',
                                                              color:
                                                                  Colors.green,
                                                              icon: Icons.check,
                                                              onPressed: () =>
                                                                  Navigator.pop(
                                                                      scaffoldKey
                                                                          .currentState
                                                                          .context),
                                                            );
                                                          } else {
                                                            Navigator.pop(
                                                                context);
                                                            Navigator.pop(
                                                                context);
                                                            LoadingDialog()
                                                                .infoDialogBox(
                                                              context: scaffoldKey
                                                                  .currentState
                                                                  .context,
                                                              loadingText:
                                                                  'Error',
                                                              onPressed: () =>
                                                                  Navigator.pop(
                                                                      scaffoldKey
                                                                          .currentState
                                                                          .context),
                                                              contentText:
                                                                  'Try again later',
                                                              color: Colors.red,
                                                              icon: Icons.close,
                                                            );
                                                          }
                                                        },
                                                        child: Container(
                                                          margin: EdgeInsets
                                                              .symmetric(
                                                                  vertical:
                                                                      5.0),
                                                          height: 40.0,
                                                          decoration:
                                                              BoxDecoration(
                                                                  border: Border
                                                                      .all(
                                                                    color:
                                                                        kSecondaryColor,
                                                                    width: 1.0,
                                                                  ),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10.0),
                                                                  color: Colors
                                                                      .white,
                                                                  boxShadow: [
                                                                BoxShadow(
                                                                  offset:
                                                                      Offset(
                                                                          0.0,
                                                                          1.5),
                                                                  color: Colors
                                                                      .black45,
                                                                ),
                                                              ]),
                                                          child: Center(
                                                            child: Text(
                                                              titleList[index],
                                                              style: TextStyle(
                                                                color:
                                                                    kSecondaryColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontSize: 18.0,
                                                              ),
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    }),
                                              ),
                                            );
                                    });
                              },
                              onPressNew: onPressNew,
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ));
        });
  }

  void noteslistBottomSheet({
    BuildContext context,
    String uid,
    String title,
    String des,
    String fileUrl,
    String format,
    Color color,
    Function onPressNew,
    String listTitle,
    GlobalKey<ScaffoldState> scaffoldKey,
  }) {
    Size size = MediaQuery.of(context).size;
    showModalBottomSheet(
        context: context,
        backgroundColor: kSecondaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        builder: (BuildContext context) {
          return sheetContainer(
            size: size,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  titleContainer(size, title),
                  SizedBox(height: (1.56 / 100) * size.height),
                  desContainer(size, des),
                  SizedBox(height: (3.90 / 100) * size.height),
                  openButton(context, fileUrl, title, format, size, color),
                  SizedBox(height: (3.90 / 100) * size.height),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      buildBoxes(
                        size: size,
                        text: 'Save',
                        iconData: Icons.bookmark_border,
                        width: size.width * 0.26,
                        onPress: () async {
                          {
                            var val = [];
                            var map = {
                              'title': title,
                              'des': des,
                              'fileUrl': fileUrl
                            };
                            val.add(map);
                            String returnString = await Database().saveForLater(
                              val,
                              uid,
                            );
                            if (returnString == 'Success') {
                              LoadingDialog().infoDialogBox(
                                context: scaffoldKey.currentState.context,
                                loadingText: 'Successful',
                                color: Colors.green,
                                icon: Icons.check,
                                onPressed: () => Navigator.pop(
                                    scaffoldKey.currentState.context),
                              );
                            } else {
                              LoadingDialog().infoDialogBox(
                                context: scaffoldKey.currentState.context,
                                loadingText: 'Error',
                                contentText: 'Try again later',
                                color: Colors.red,
                                icon: Icons.close,
                                onPressed: () => Navigator.pop(
                                    scaffoldKey.currentState.context),
                              );
                            }
                          }
                        },
                      ),
                      buildBoxes(
                        size: size,
                        text: 'Noteslist',
                        iconData: Icons.playlist_add,
                        width: size.width * 0.33,
                        onPress: () {
                          LoadingDialog().chooseListDialogBox(
                            context: context,
                            onPressEx: () async {
                              Navigator.pop(context);
                              List titleList =
                                  await Database().notesListTitles(uid);
                              showDialog(
                                  context: scaffoldKey.currentState.context,
                                  builder: (BuildContext context) {
                                    return titleList.length == 0 ||
                                            titleList.length == null
                                        ? AlertDialog(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        20.0)),
                                            title: Text(
                                              'Select Noteslist',
                                              style: TextStyle(
                                                  color:
                                                      Colors.deepOrange[800]),
                                            ),
                                            content: Container(
                                              height:
                                                  (39.06 / 100) * size.height,
                                              width: (25.47 / 100) * size.width,
                                              child: Center(
                                                child: Text(
                                                  'No noteslist found',
                                                  style: TextStyle(
                                                    color: kSecondaryColor,
                                                    fontSize: 20.0,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        : AlertDialog(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        20.0)),
                                            title: Text(
                                              'Select Noteslist',
                                              style: TextStyle(
                                                  color:
                                                      Colors.deepOrange[800]),
                                            ),
                                            content: Container(
                                              height: 250.0,
                                              width: (25.47 / 100) *
                                                  MediaQuery.of(context)
                                                      .size
                                                      .width,
                                              child: ListView.builder(
                                                  itemCount: titleList.length,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    return GestureDetector(
                                                      onTap: () async {
                                                        LoadingDialog().dialogBox(
                                                            context: scaffoldKey
                                                                .currentState
                                                                .context,
                                                            loadingText:
                                                                'Loading...');
                                                        String returnString =
                                                            await Database()
                                                                .createNewList(
                                                          uid: uid,
                                                          listTitle:
                                                              titleList[index],
                                                          title: title,
                                                          des: des,
                                                          fileUrl: fileUrl,
                                                        );
                                                        if (returnString ==
                                                            'Success') {
                                                          Navigator.pop(
                                                              context);
                                                          Navigator.pop(
                                                              context);
                                                          LoadingDialog()
                                                              .infoDialogBox(
                                                            context: scaffoldKey
                                                                .currentState
                                                                .context,
                                                            loadingText:
                                                                'Successful',
                                                            color: Colors.green,
                                                            icon: Icons.check,
                                                            onPressed: () =>
                                                                Navigator.pop(
                                                                    scaffoldKey
                                                                        .currentState
                                                                        .context),
                                                          );
                                                        } else {
                                                          Navigator.pop(
                                                              context);
                                                          Navigator.pop(
                                                              context);
                                                          LoadingDialog()
                                                              .infoDialogBox(
                                                            context: scaffoldKey
                                                                .currentState
                                                                .context,
                                                            loadingText:
                                                                'Error',
                                                            onPressed: () =>
                                                                Navigator.pop(
                                                                    scaffoldKey
                                                                        .currentState
                                                                        .context),
                                                            contentText:
                                                                'Try again later',
                                                            color: Colors.red,
                                                            icon: Icons.close,
                                                          );
                                                        }
                                                      },
                                                      child: Container(
                                                        margin: EdgeInsets
                                                            .symmetric(
                                                                vertical: 5.0),
                                                        height: 40.0,
                                                        decoration:
                                                            BoxDecoration(
                                                                border:
                                                                    Border.all(
                                                                  color:
                                                                      kSecondaryColor,
                                                                  width: 1.0,
                                                                ),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10.0),
                                                                color: Colors
                                                                    .white,
                                                                boxShadow: [
                                                              BoxShadow(
                                                                offset: Offset(
                                                                    0.0, 1.5),
                                                                color: Colors
                                                                    .black45,
                                                              ),
                                                            ]),
                                                        child: Center(
                                                          child: Text(
                                                            titleList[index],
                                                            style: TextStyle(
                                                              color:
                                                                  kSecondaryColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              fontSize: 18.0,
                                                            ),
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  }),
                                            ),
                                          );
                                  });
                            },
                            onPressNew: onPressNew,
                          );
                        },
                      ),
                      buildBoxes(
                        size: size,
                        text: 'Remove',
                        iconData: Icons.delete_outline,
                        width: size.width * 0.31,
                        onPress: () async {
                          LoadingDialog().dialogBox(
                              context: scaffoldKey.currentState.context,
                              loadingText: 'Removing...');
                          await Database()
                              .deleteFile(
                            location: listTitle,
                            collName: 'userNoteslist',
                            uid: uid,
                            title: title,
                            des: des,
                            fileUrl: fileUrl,
                          )
                              .whenComplete(() {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BottomNavScreen(),
                              ),
                              (route) => false,
                            );
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  void savedFileBottomSheet({
    BuildContext context,
    String uid,
    String title,
    String des,
    String fileUrl,
    String format,
    Color color,
    Function onPressNew,
    String listTitle,
    GlobalKey<ScaffoldState> scaffoldKey,
  }) {
    Size size = MediaQuery.of(context).size;
    showModalBottomSheet(
        context: context,
        backgroundColor: kSecondaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        builder: (BuildContext context) {
          return sheetContainer(
            size: size,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  titleContainer(size, title),
                  SizedBox(height: (1.56 / 100) * size.height),
                  desContainer(size, des),
                  SizedBox(height: (3.90 / 100) * size.height),
                  openButton(context, fileUrl, title, format, size, color),
                  SizedBox(height: (3.90 / 100) * size.height),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      buildBoxes(
                        size: size,
                        text: 'Noteslist',
                        iconData: Icons.playlist_add,
                        width: size.width * 0.33,
                        onPress: () {
                          LoadingDialog().chooseListDialogBox(
                            context: context,
                            onPressEx: () async {
                              Navigator.pop(context);
                              List titleList =
                                  await Database().notesListTitles(uid);
                              showDialog(
                                  context: scaffoldKey.currentState.context,
                                  builder: (BuildContext context) {
                                    return titleList.length == 0 ||
                                            titleList.length == null
                                        ? AlertDialog(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        20.0)),
                                            title: Text(
                                              'Select Noteslist',
                                              style: TextStyle(
                                                  color:
                                                      Colors.deepOrange[800]),
                                            ),
                                            content: Container(
                                              height:
                                                  (39.06 / 100) * size.height,
                                              width: (25.47 / 100) * size.width,
                                              child: Center(
                                                child: Text(
                                                  'No noteslist found',
                                                  style: TextStyle(
                                                    color: kSecondaryColor,
                                                    fontSize: 20.0,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        : AlertDialog(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        20.0)),
                                            title: Text(
                                              'Select Noteslist',
                                              style: TextStyle(
                                                color: Colors.deepOrange[800],
                                              ),
                                            ),
                                            content: Container(
                                              height:
                                                  (39.06 / 100) * size.height,
                                              width: (25.47 / 100) * size.width,
                                              child: ListView.builder(
                                                  itemCount: titleList.length,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    return GestureDetector(
                                                      onTap: () async {
                                                        LoadingDialog().dialogBox(
                                                            context: scaffoldKey
                                                                .currentState
                                                                .context,
                                                            loadingText:
                                                                'Loading...');
                                                        String returnString =
                                                            await Database()
                                                                .createNewList(
                                                          uid: uid,
                                                          listTitle:
                                                              titleList[index],
                                                          title: title,
                                                          des: des,
                                                          fileUrl: fileUrl,
                                                        );
                                                        if (returnString ==
                                                            'Success') {
                                                          Navigator.pop(
                                                              context);
                                                          Navigator.pop(
                                                              context);
                                                          LoadingDialog()
                                                              .infoDialogBox(
                                                            context: scaffoldKey
                                                                .currentState
                                                                .context,
                                                            loadingText:
                                                                'Successful',
                                                            color: Colors.green,
                                                            icon: Icons.check,
                                                            onPressed: () =>
                                                                Navigator.pop(
                                                                    scaffoldKey
                                                                        .currentState
                                                                        .context),
                                                          );
                                                        } else {
                                                          Navigator.pop(
                                                              context);
                                                          Navigator.pop(
                                                              context);
                                                          LoadingDialog()
                                                              .infoDialogBox(
                                                            context: scaffoldKey
                                                                .currentState
                                                                .context,
                                                            loadingText:
                                                                'Error',
                                                            onPressed: () =>
                                                                Navigator.pop(
                                                                    scaffoldKey
                                                                        .currentState
                                                                        .context),
                                                            contentText:
                                                                'Try again later',
                                                            color: Colors.red,
                                                            icon: Icons.close,
                                                          );
                                                        }
                                                      },
                                                      child: Container(
                                                        margin: EdgeInsets
                                                            .symmetric(
                                                                vertical: 5.0),
                                                        height: 40.0,
                                                        decoration:
                                                            BoxDecoration(
                                                                border:
                                                                    Border.all(
                                                                  color:
                                                                      kSecondaryColor,
                                                                  width: 1.0,
                                                                ),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10.0),
                                                                color: Colors
                                                                    .white,
                                                                boxShadow: [
                                                              BoxShadow(
                                                                offset: Offset(
                                                                    0.0, 1.5),
                                                                color: Colors
                                                                    .black45,
                                                              ),
                                                            ]),
                                                        child: Center(
                                                          child: Text(
                                                            titleList[index],
                                                            style: TextStyle(
                                                              color:
                                                                  kSecondaryColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              fontSize: 18.0,
                                                            ),
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  }),
                                            ),
                                          );
                                  });
                            },
                            onPressNew: onPressNew,
                          );
                        },
                      ),
                      buildBoxes(
                        size: size,
                        text: 'Remove from saved',
                        iconData: Icons.bookmark,
                        width: size.width * 0.58,
                        onPress: () async {
                          LoadingDialog().dialogBox(
                              context: scaffoldKey.currentState.context,
                              loadingText: 'Removing...');
                          await Database()
                              .deleteFile(
                            location: 'saveForLater',
                            collName: 'userFile',
                            uid: uid,
                            title: title,
                            des: des,
                            fileUrl: fileUrl,
                          )
                              .whenComplete(() {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BottomNavScreen(),
                              ),
                              (route) => false,
                            );
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  Container sheetContainer({Size size, Widget child}) {
    return Container(
      padding: EdgeInsets.only(top: 12.0, bottom: 6.0),
      height: (45.0 / 100) * size.height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF12174a),
            Color(0xFF0d1036),
            Color(0xFF080a21),
          ],
          stops: [0.15, 0.45, 0.7],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      child: child,
    );
  }

  Widget openButton(BuildContext context, String fileUrl, String title,
      String format, Size size, Color color) {
    return GestureDetector(
      onTap: () async {
        LoadingDialog()
            .dialogBox(context: context, loadingText: 'Loading file...');
        try {
          File file = await DefaultCacheManager().getSingleFile(fileUrl);
          String filePath = file.path;
          print(filePath);
          Navigator.pop(context);
          if ((filePath != null || filePath.isNotEmpty) &&
              fileUrl.contains('.pdf')) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PdfScreen(
                  path: filePath,
                  title: title,
                ),
              ),
            );
          } else if (filePath != null || filePath.isNotEmpty) {
            final result = await OpenFile.open(filePath);
            if (result.message.compareTo('done') != 0) {
              LoadingDialog().infoDialogBox(
                context: context,
                loadingText: 'Error',
                contentText: 'No app found on device to open file.',
                color: Colors.red,
                onPressed: () => Navigator.pop(context),
                icon: Icons.close,
              );
            }
          } else {
            print('Error');
            Navigator.pop(context);
            LoadingDialog().infoDialogBox(
              context: context,
              loadingText: 'Error',
              contentText:
                  'Creator might have deleted the file or try again later.',
              color: Colors.red,
              onPressed: () => Navigator.pop(context),
              icon: Icons.close,
            );
          }
        } catch (e) {
          print('Error is $e');
          Navigator.pop(context);
          LoadingDialog().infoDialogBox(
            context: context,
            loadingText: 'Error',
            contentText:
                'Either file is deleted by the user or try again later.',
            color: Colors.red,
            onPressed: () => Navigator.pop(context),
            icon: Icons.close,
          );
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.0),
        height: (7.0 / 100) * size.height,
        width: 105.0,
        decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(15.0),
            boxShadow: [
              BoxShadow(
                color: Colors.white30,
                offset: Offset(0.0, 2.75),
                blurRadius: 2.5,
              )
            ]),
        child: Row(
          children: <Widget>[
            Icon(
              Icons.launch,
              color: Colors.white,
              size: 22.0,
            ),
            SizedBox(width: 8.0),
            Text(
              'Open',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container desContainer(Size size, String des) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.0),
      height: (9.37 / 100) * size.height,
      width: size.width * 0.85,
      child: SingleChildScrollView(
        child: Text(
          des == null ? 'No description found.' : des,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 14.0,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Container titleContainer(Size size, String title) {
    return Container(
      width: size.width * 0.8,
      child: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontSize: 23.0,
          fontWeight: FontWeight.w600,
          fontStyle: FontStyle.italic,
        ),
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
      ),
    );
  }
}
