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

    if (data.isEmpty){
      data = ModalRoute.of(context).settings.arguments;
      notes = data["notes"];
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
        centerTitle: true,
        backgroundColor: Colors.brown[300],
      ),
      backgroundColor: Colors.grey[200],

      body: ListView.separated(
        itemCount: notes.length,
        separatorBuilder: (context,i) =>Divider(height: 0.5,),

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

                //handles navigation to the add_note screen and
                //update in the db and the notes list
                onTap: () => modifyNote(i),

                child: ListTile(
                  title: Text(
                    notes[i].title,
                    style: TextStyle(
                        fontSize: 17,
                        color: Colors.grey[800],
                        fontWeight: FontWeight.bold),
                    maxLines: 1,
                  ),

                  subtitle: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                    child: Text(
                      notes[i].content,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
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
                    //instead of simply using showDialog, for the beauty
                    Navigator.of(context).push(PageRouteBuilder(
                      opaque: false,
                        barrierColor: Colors.black.withOpacity(0.1),
                        pageBuilder: (context, _, ___) =>
                            DeleteConfirmationDialog(
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
        backgroundColor: Colors.brown[300],
        child: Icon(Icons.add, size: 30,),
      ),
    );
  }


  void modifyNote(index) async {
    changeStatusBarColor();

    dynamic response = await Navigator.pushNamed(
        context, '/add_note', arguments: {
      "title": notes[index].title,
      'content': notes[index].content
    });

    if (response != null) {
      //will search in the db for a note with the given id
      //and then update it with the response attributes
      int id = notes[index].id;
      response.id = id;
      await dbProvider.updateNote(response);

      setState(() {
        //We assign each value instead of replacing the note
        //so we don't loose the id
        notes[index] = response;
      });
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
      statusBarColor: Colors.brown[400],
    ));
  }

}
