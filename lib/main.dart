import 'package:flutter/material.dart';
import 'package:my_notes/favourites.dart';
import 'package:my_notes/home.dart';
import 'package:my_notes/details.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
      routes: {
        '/details' : (context) => Details(),
        '/favourites' : (context) => Favourites(),
      },
    );
  }
}