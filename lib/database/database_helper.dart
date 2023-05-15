import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../note.dart';

class DatabaseHelper{
  static DatabaseHelper _databaseHelper;
  static Database _database;

  String noteTable = 'note_table';
  String id = 'id';
  String title = 'title';
  String description = 'description';
  String isFav = 'isFav';

  DatabaseHelper._createInstance();
  factory DatabaseHelper()
  {
    if(_databaseHelper == null)
      _databaseHelper = DatabaseHelper._createInstance();
    return _databaseHelper;
  }

  Future<Database> initializeDatabase() async
  {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'notes.db';
    Database noteDatabase = await openDatabase(path, version: 1, onCreate: _createDatabase);
    return noteDatabase;
  }

  void _createDatabase(Database db, int version) async
  {
    await db.execute('CREATE TABLE $noteTable($id TEXT, $title Text, $description Text, $isFav INTEGER)');
  }

  Future<Database> get database async
  {
    if(_database == null)
      _database = await initializeDatabase();
    return _database;
  }

  Future<List<Map<String, dynamic>>> getNoteMapList() async {
    Database db = await this.database;

    var result = await db.query(noteTable);
    return result;
  }

  Future<List<Map<String, dynamic>>> getFavNoteMapList() async {
    Database db = await this.database;

    var result = await db.query(noteTable, where: '$isFav = ?', whereArgs: ['true']);
    return result;
  }

  Future<int> insertNote(Note note) async {
    Database db = await this.database;
    var result = await db.insert(noteTable, note.toMap());
    return result;
  }

  Future<int> deleteNote(String noteId) async {
    var db = await this.database;
    int result = await db.delete(noteTable, where: '$id = ?', whereArgs: [noteId]);
    return result;
  }

  Future<int> updateNote(Note note) async {
    var db = await this.database;
    var result = await db.update(
        noteTable, note.toMap(), where: '$id = ?', whereArgs: [note.id]);
    return result;
  }


    Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) from $noteTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  Future<List<Note>> getNoteList() async {

    var noteMapList = await getNoteMapList(); // Get 'Map List' from database
    int count = noteMapList.length;         // Count the number of map entries in db table

    List<Note> noteList = List<Note>();
    // For loop to create a 'Note List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      noteList.add(Note.fromMapObject(noteMapList[i]));
    }

    return noteList;
  }

  Future<List<Note>> getFavNoteList() async {

    var noteMapList = await getFavNoteMapList(); // Get 'Map List' from database
    int count = noteMapList.length;         // Count the number of map entries in db table

    List<Note> favNoteList = List<Note>();
    // For loop to create a 'Note List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      favNoteList.add(Note.fromMapObject(noteMapList[i]));
    }
    return favNoteList;
  }
}