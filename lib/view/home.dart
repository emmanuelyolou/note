import 'package:flutter/material.dart';
import 'package:note/note.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Note> notes = [
    Note(title: 'Courses', content: 'Farine, oeufs, dentifrice, savon'),
    Note(title: 'TAF', content: 'Recherches algo num, electronique des compo, St 21h'),

  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
        centerTitle: true,

      ),
      backgroundColor: Colors.grey[100],

      body: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        itemCount: notes.length,
        separatorBuilder: (context,i) =>SizedBox(height: 10),

        itemBuilder: (context, i) {
          return Slidable(
            actionPane: SlidableScrollActionPane(),
            actionExtentRatio: 0.25,

            child: Container(
              color: Colors.white,
              height: 130,
              child: GestureDetector(
                onTap: () async{
                  dynamic response = await Navigator.pushNamed(context, '/add_note', arguments: {
                    "title": notes[i].title,
                    'content': notes[i].content
                  });

                  if (response != null){
                    notes[i] = response;
                  }
                },

                child: ListTile(
                  title: Text(
                    notes[i].title,
                    style: TextStyle(
                        fontSize: 25,
                        color: Colors.grey[800]),
                        maxLines: 1,
                  ),

                  subtitle: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Text(
                      notes[i].content,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.grey[700]),
                    ),
                  ),
                ),
              ),
            ),

            //delete option beware the Slidable
            secondaryActions: <Widget>[
              IconSlideAction(
                caption: 'delete',
                color: Colors.redAccent,
                icon: Icons.delete,

                onTap: (){
                  setState(() {
                    notes.removeAt(i);
                  });
                },
              )
            ],
          );
      }
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async{
          dynamic result = await Navigator.pushNamed(context, '/add_note');

          if(result != null){
            setState(() {
              notes.add(result);
            });
          }
        },
        child: Icon(Icons.add, size: 30,),
      ),
    );
  }
}
