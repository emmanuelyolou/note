import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:note/model/note.dart';

class AddNote extends StatefulWidget {
  @override
  _AddNoteState createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  TextEditingController _titleController;
  TextEditingController _contentController;
  FocusNode _notesFocusNode;
  Map data = {};

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _contentController = TextEditingController();
    _notesFocusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _contentController.dispose();
    _notesFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {

    data = ModalRoute.of(context).settings.arguments;
    if (data != null){
      _titleController.text = data['title'];
      _contentController.text = data['content'];
    }

    return Scaffold(

      backgroundColor: Colors.grey[200],

      appBar: AppBar(
        backgroundColor: Colors.blue[700],
        title: Text('Note'),
          centerTitle: true,
          actions: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
              child: FlatButton(
                child: Text('Save',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white
                  ),
                ),

                onPressed: () {
                  if (_titleController.text.trim() != '' || _contentController.text.trim() != '')
                  {
                    Navigator.pop(context, Note(
                        title: _titleController.text,
                        content: _contentController.text)
                    );
                  }
                  else
                  {
                    Navigator.pop(context);
                  }

                }
              ),
            ),
          ],
      ),


      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
        child: Column(
          children: <Widget>[
            TextField(
              style: TextStyle(fontSize: 30),
              controller: _titleController,
              decoration: InputDecoration(
              hintText: 'Title',
              border: InputBorder.none,
              hintStyle: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
            ),

            SizedBox(height: 10),

            TextField(
              style: TextStyle(fontSize: 25),
              controller: _contentController,
              focusNode: _notesFocusNode,
              maxLines: null,
              keyboardType: TextInputType.multiline,

              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Notes',
                hintStyle: TextStyle(fontSize: 25)
              ),
            )
          ],
        ),
      ),
    );
  }
}
