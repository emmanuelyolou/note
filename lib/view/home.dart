import 'package:flutter/material.dart';
import 'package:note/model/note.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:note/model/database.dart';
import 'DeleteConfirmationDialog.dart';
import 'package:flutter/services.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final SlidableController slideController = SlidableController();
  DbProvider dbProvider = DbProvider();
  Map data = {};
  List<Note> notes;


  @override

  Widget build(BuildContext context) {
    changeStatusBarColor();

    if (notes == null){
      data = ModalRoute.of(context).settings.arguments;
      notes = data["notes"];
    }

    return Scaffold(
      backgroundColor: Colors.grey[200],

      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.teal,

        title: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
          child: Text('Notes', style: TextStyle(fontSize: 28),),
        ),

      ),


      body: ListView.separated(
        itemCount: notes.length,

        separatorBuilder: (context, i) =>Divider(height: 0.5,),

        itemBuilder: (context, i) {
          return Slidable(
            controller: slideController,
            actionPane: SlidableScrollActionPane(),
            actionExtentRatio: 0.25,

            child: Container(
              padding: EdgeInsets.fromLTRB(2, 5, 35, 5),
              color: Colors.grey[100],
              height: 102,

              child: GestureDetector(

                onTap: () => modifyNote(i),

                child: ListTile(

                  title: Text(
                    notes[i].title,
                    maxLines: 1,

                    style: TextStyle(
                        fontSize: 17,
                        color: Colors.grey[800],
                        fontWeight: FontWeight.bold),
                  ),

                  subtitle: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),

                    child: Text(
                      notes[i].content,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,

                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey[600]),
                    ),
                  ),

                ),
              ),
            ),

            secondaryActions: <Widget>[
              IconSlideAction(
                  caption: 'delete',
                  color: Colors.redAccent,
                  icon: Icons.delete,

                  onTap: () {
                    Navigator.of(context).push(PageRouteBuilder(
                      opaque: false,
                      barrierColor: Colors.black.withOpacity(0.1),

                      pageBuilder: (context, _, ___) => DeleteConfirmationDialog(
                          deleteFunction: delete,
                          indexToDelete: i,
                        )

                    ));
                  }

              ),
            ],
          );
        }),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,

        child: Icon(Icons.add, size: 30,),

        onPressed: () async{
          dynamic result = await Navigator.pushNamed(context, '/add_note');

          if(result != null){
            int id = await dbProvider.insertNote(result);
            result.id = id;
            setState(() {
              notes.add(result);
            });
          }
        },
      ),
    );
  }


  void modifyNote(index) async {
    //handles navigation to the add_note screen and
    //update in the db and the notes list

    changeStatusBarColor();

    dynamic response = await Navigator.pushNamed(
        context, '/add_note', arguments: {
      "title": notes[index].title,
      'content': notes[index].content
    });

    if (response != null) {

      response.id = notes[index].id;
      await dbProvider.updateNote(response); //The update is made using the id

      setState(() => notes[index] = response);
    }
  }

  delete(index) async{
    await dbProvider.deleteNote(notes[index]);
    setState(() {
      notes.removeAt(index);
      Navigator.pop(context);
    });
  }

  void changeStatusBarColor(){
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.teal,
    ));
  }

}
