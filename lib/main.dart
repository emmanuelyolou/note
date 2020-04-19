import 'package:flutter/material.dart';
import 'package:note/view/home.dart';
import 'package:note/view/add_note.dart';
import 'package:note/view/loading_screen.dart';

void main() => runApp(MaterialApp(debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => Loading(),
        '/home': (context) => Home(),
        '/add_note': (context) => AddNote()},
    ));
