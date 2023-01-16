import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:studopedia/models/color_style.dart';
import 'package:studopedia/screens/uploading_screen.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:studopedia/widgets/loading_dialog.dart';
import 'package:path/path.dart';

class UploadScreen extends StatefulWidget {
  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  File _selectedFile;
  bool loading = false;
  bool fileSelected = false;
  String title;
  String des;
  final _titleFormKey = GlobalKey<FormState>();
  final _descriptionFormKey = GlobalKey<FormState>();
  bool borderTitle = false;
  bool borderDes = false;
  int currentSize;
  int totalSize;
  Text subtitle;
  StorageUploadTask uploadTask;
  getFile(BuildContext context) async {
    File file =
        await FilePicker.getFile(type: FileType.custom, allowedExtensions: [
      'pdf',
      'doc',
      'docx',
      'xlsx',
      'pptx',
      'xls',
      'ppt',
    ]);
    if (file.path == null) {
      setState(() {
        fileSelected = false;
      });
      Navigator.pop(context);
    }
    setState(() {
      _selectedFile = file;
      fileSelected = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              padding:
                  EdgeInsets.symmetric(vertical: (5.4 / 100) * size.height),
              alignment: Alignment.bottomCenter,
              height: (17.63 / 100) * size.height,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Theme.of(context).primaryColor, kSecondaryColor],
                  stops: [0.3, 0.9],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.elliptical(55, 50),
                  bottomRight: Radius.elliptical(55, 50),
                ),
              ),
              child: Text(
                'Add Notes',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30.0,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: (6.78 / 100) * size.height),
            Container(
              height: (74.7 / 100) * size.height,
              child: Column(
                children: <Widget>[
                  GestureDetector(
                    onTap: () => getFile(context),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      height: 50.0,
                      width: 150.0,
                      decoration: BoxDecoration(
                        color: kSecondaryColor,
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0.0, 4.5),
                            color: Colors.black38,
                            blurRadius: 3.0,
                          ),
                        ],
                      ),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.description,
                            color: Colors.white,
                            size: 30.0,
                          ),
                          SizedBox(width: 10.0),
                          Text(
                            'Select file',
                            style:
                                TextStyle(color: Colors.white, fontSize: 18.5),
                          ),
                        ],
                      ),
                    ),
                  ),
                  fileSelected
                      ? Container(
                          padding: EdgeInsets.symmetric(horizontal: 25.0),
                          margin: EdgeInsets.symmetric(
                              vertical: (3.0 / 100) * size.height),
                          child: Text(
                            basename(_selectedFile.path),
                            style: TextStyle(
                              color: kSecondaryColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 20.0,
                            ),
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      : SizedBox(height: (6.78 / 100) * size.height),
                  Container(
                    height: (8 / 100) * size.height,
                    width: MediaQuery.of(context).size.width * 0.75,
                    padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 5.0),
                    decoration: BoxDecoration(
                      border: borderTitle
                          ? Border.all(
                              color: kSecondaryColor,
                              width: 1.5,
                            )
                          : null,
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 6.0,
                          offset: Offset(0.0, 2.0),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _titleFormKey,
                      child: TextFormField(
                        onTap: () {
                          setState(() {
                            borderTitle = true;
                          });
                        },
                        autofocus: false,
                        textCapitalization: TextCapitalization.words,
                        decoration: InputDecoration(
                          hintText: 'Title',
                          border: InputBorder.none,
                        ),
                        onChanged: (value) {
                          setState(() {
                            title = value;
                          });
                        },
                        validator: (value) =>
                            value.isEmpty ? 'Title can\'t be empty' : null,
                      ),
                    ),
                  ),
                  SizedBox(height: (5.42 / 100) * size.height),
                  Container(
                    height: (13.56 / 100) * size.height,
                    width: MediaQuery.of(context).size.width * 0.75,
                    padding:
                        EdgeInsets.symmetric(vertical: 3.0, horizontal: 15.0),
                    decoration: BoxDecoration(
                      border: borderDes
                          ? Border.all(
                              color: kSecondaryColor,
                              width: 1.5,
                            )
                          : null,
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 6.0,
                          offset: Offset(0.0, 2.0),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _descriptionFormKey,
                      child: TextFormField(
                        onTap: () {
                          setState(() {
                            borderDes = true;
                          });
                        },
                        autofocus: false,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(
                          hintText: 'Description or content',
                          border: InputBorder.none,
                        ),
                        maxLines: 3,
                        maxLength: 80,
                        onChanged: (value) {
                          setState(() {
                            des = value;
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: (6.78 / 100) * size.height),
                  FloatingActionButton.extended(
                    heroTag: 'upload_screen',
                    elevation: 7.0,
                    onPressed: () {
                      if (_titleFormKey.currentState.validate() &&
                          fileSelected &&
                          (_selectedFile.path.contains('.pdf') ||
                              _selectedFile.path.contains('.docx') ||
                              _selectedFile.path.contains('.xlsx') ||
                              _selectedFile.path.contains('.pptx') ||
                              _selectedFile.path.contains('.doc') ||
                              _selectedFile.path.contains('.xls') ||
                              _selectedFile.path.contains('.ppt'))) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UploadingScreen(
                              title: title,
                              des: des,
                              selectedFile: _selectedFile,
                            ),
                          ),
                        );
                      } else if (_titleFormKey.currentState.validate() &&
                          !fileSelected) {
                        LoadingDialog().infoDialogBox(
                          context: _scaffoldKey.currentState.context,
                          loadingText: 'Error',
                          contentText: 'File not selected',
                          color: Colors.red,
                          onPressed: () =>
                              Navigator.pop(_scaffoldKey.currentState.context),
                          icon: Icons.close,
                        );
//                        showScaffold('File not selected', context);
                      } else if (!_titleFormKey.currentState.validate() ||
                          !fileSelected) {
                        LoadingDialog().infoDialogBox(
                          context: _scaffoldKey.currentState.context,
                          loadingText: 'Error',
                          contentText: 'Please enter title for your file.',
                          color: Colors.red,
                          onPressed: () =>
                              Navigator.pop(_scaffoldKey.currentState.context),
                          icon: Icons.close,
                        );
                      } else {
                        LoadingDialog().infoDialogBox(
                          context: _scaffoldKey.currentState.context,
                          loadingText: 'Error',
                          contentText:
                              'Only PDF, DOC, Excel, & PPT files are allowed.',
                          color: Colors.red,
                          onPressed: () =>
                              Navigator.pop(_scaffoldKey.currentState.context),
                          icon: Icons.close,
                        );
                      }
                    },
                    backgroundColor: kButtonColor,
                    label: Text(
                      'Upload',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    icon: Icon(
                      Icons.cloud_upload,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: (10.0 / 100) * size.height),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(0.0),
                        height: 35.0,
                        width: 35.0,
                        margin: EdgeInsets.only(left: 20.0),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: kSecondaryColor,
                              width: 1.5,
                            ),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  offset: Offset(0.0, 2.0),
                                  color: Colors.black26)
                            ]),
                        child: Icon(
                          Icons.arrow_back,
                          color: kSecondaryColor,
                          size: 25.0,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
