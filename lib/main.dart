import 'package:flutter/material.dart';
import 'package:note/view/home.dart';
import 'package:note/view/add_note.dart';

void main() => runApp(MaterialApp(debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => Home(),
        '/add_note': (context) => AddNote()},
    ));
