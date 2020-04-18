import 'package:note/model/note.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DbProvider{
  Database db;

  DbProvider(){
    initDatabase();
  }

  Future<void> insertNote(Note note) async{
    db.rawInsert("""
      INSERT INTO note(title, content)
      VALUES ("${note.title}, ${note.content}") 
    """);
  }

  Future<List<Note>>getAllNotes() async {
    List<Map> result = await db.query('note');

    return result.map((note) => Note(
      title: note['title'],
      content: note['content']
    ));
  }

  Future<void> deleteNote(int id) async {
    db.rawDelete("""
      DELETE FROM note 
      WHERE id = $id 
    """);
  }

  initDatabase() async {
    db = await openDatabase(
      join(await getDatabasesPath(), 'note_db.db'),
      version: 1,
      onCreate: (db, version) async {
       await db.execute("""
        CREATE TABLE note (
          id_note INT PRIMARY KEY AUTOINCREMENT,
          title VARCHAR(50) DEFAULT NULL,
          content TEXT DEFAULT NULL
        )
        """);
      }
    );
  }


}