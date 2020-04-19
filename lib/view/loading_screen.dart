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

    Navigator.pushReplacementNamed(
      context, '/home',
      arguments: {
      'notes' : notes,
      });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[800],
      child: SpinKitThreeBounce(
        itemBuilder: (BuildContext context, int index) {
          return DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.grey[800],

            ),
          );
        },
      ),
    );
  }
}