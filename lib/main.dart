import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studopedia/screens/root.dart';
import 'package:studopedia/services/current_user.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CurrentUser(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Studopedia',
        theme: ThemeData(
          primaryColor: Color(0xFF0D113E),
        ),
        home: Root(),
      ),
    );
  }
}
