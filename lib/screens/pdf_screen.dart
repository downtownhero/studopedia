import 'package:flutter/services.dart';
import 'package:flutter_full_pdf_viewer/flutter_full_pdf_viewer.dart';
import 'package:flutter_full_pdf_viewer/full_pdf_viewer_scaffold.dart';
import 'package:flutter/material.dart';

class PdfScreen extends StatefulWidget {
  final String path;
  final String title;
  PdfScreen({this.path, this.title});

  @override
  _PdfScreenState createState() => _PdfScreenState();
}

class _PdfScreenState extends State<PdfScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
    ]);
  }
//
//  @override
//  void dispose() {
//    SystemChrome.setPreferredOrientations([
//      DeviceOrientation.landscapeRight,
//      DeviceOrientation.landscapeLeft,
//      DeviceOrientation.portraitUp,
//    ]);
//    super.dispose();
//  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return SystemChrome.setPreferredOrientations(
                [DeviceOrientation.portraitUp])
            .whenComplete(() => Navigator.pop(context));
      },
      child: PDFViewerScaffold(
        key: _scaffoldKey,
        path: widget.path,
        appBar: AppBar(
          title: Text(
            widget.title,
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Colors.white,
            onPressed: () {
              SystemChrome.setPreferredOrientations(
                      [DeviceOrientation.portraitUp])
                  .whenComplete(() => Navigator.pop(context));
            },
          ),
        ),
      ),
    );
  }
}
