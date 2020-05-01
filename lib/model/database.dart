import 'package:note/model/note.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DbProvider{
  static Database _database;

  DbProvider();

  Future<Database> get database async {
    if (_database == null){
      _database = await initDatabase();
    }
    return _database;
  }

  Future<int> insertNote(Note note) async{
    Database db = await database;
    return db.rawInsert("""
      INSERT INTO note(title, content) VALUES (?, ?)
      """,
      [note.title, note.content]);
  }

  Future<void> updateNote(Note note) async{
    Database db = await database;
    db.rawUpdate("""
      UPDATE note 
      SET title = ?, content = ? WHERE id = ?""",
      [note.title, note.content, note.id]);
  }


  Future<List<Note>> getAllNotes() async {
    Database db = await database;
    List<Map> result = await db.rawQuery("SELECT * FROM note");

    return result.map((note) => Note(
      title: note['title'],
      content: note['content'],
      id: note['id']
    )).toList();
  }

  Future<void> deleteNote(Note note) async {
    Database db = await database;

    db.rawDelete("""
      DELETE FROM note 
      WHERE id = ${note.id} 
    """);
  }

  initDatabase() async {
    return await openDatabase(
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