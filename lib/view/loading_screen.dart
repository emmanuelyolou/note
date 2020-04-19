import 'package:flutter/material.dart';
import 'package:note/model/note.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:note/model/database.dart';

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async{
    DbProvider dbProvider = DbProvider();
    await dbProvider.initDatabase();
    List<Note> notes = await dbProvider.getAllNotes();

    //Delays the navigation so that the screen loads at least
    //1 sec
    Future.delayed(Duration(milliseconds: 500,), (){
      Navigator.pushReplacementNamed(
        context, '/home',
        arguments: {
        'notes' : notes,
      });
    });}

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[800],
      child: SpinKitThreeBounce(
        color: Colors.blue[800],
        size: 40,
      ),
    );
  }
}