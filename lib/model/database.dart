import 'package:note/model/note.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DbProvider{
  static Database db;

  DbProvider();

  Future<int> insertNote(Note note) async{
    return db.rawInsert("""
      INSERT INTO note(title, content) VALUES (?, ?)
      """,
      [note.title, note.content]);
  }

  Future<void> updateNote(Note note) async{
    db.rawUpdate("""
      UPDATE note 
      SET title = ?, content = ? WHERE id = ?""",
      [note.title, note.content, note.id]);
  }


  Future<List<Note>> getAllNotes() async {
    List<Map> result = await db.query('note');

    return result.map((note) => Note(
      title: note['title'],
      content: note['content'],
      id: note['id']
    )).toList();
  }

  Future<void> deleteNote(Note note) async {
    db.rawDelete("""
      DELETE FROM note 
      WHERE id = ${note.id} 
    """);
  }

  initDatabase() async {
    db = await openDatabase(
      join(await getDatabasesPath(), 'note_db.db'),
      version: 1,
      onCreate: (db, version) async {
       await db.execute("""
        CREATE TABLE note (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title VARCHAR(50) DEFAULT NULL,
          content TEXT DEFAULT NULL
        )
        """);
      }
    );
  }


}