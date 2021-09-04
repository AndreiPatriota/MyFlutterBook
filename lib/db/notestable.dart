import 'package:flutter_book/db/dbworker.dart';
import 'package:sqflite/sqflite.dart';
import '../models/notesmodel.dart';

class NotesTable{
  /*Properties*/
  Database _db;

  /*Private methods*/
  NotesTable(Database db){
    _db = db;
  }

  Future<Database> get _database async{
    /*Verifies if the DB connection has been
    * initialized*/
    if(_db == null){
      _db = await DBWorker.init();
    }
    /*Returns the connection*/
    return _db;
  }

  Note _map2Note(Map someMap){
    /*Converts a map object containing the
    * properties of a note into a Note object*/
    Note note = Note();
    note.id = someMap['id'];
    note.title = someMap['title'];
    note.color = someMap['color'];
    note.content = someMap['content'];

    return note;
  }

  Map<String, dynamic> _note2Map(Note someNote){
    /*Converts a note object into a map containing its
    * properties*/
    Map<String, dynamic> map = Map<String, dynamic>();

    map['id'] = someNote.id;
    map['title'] = someNote.title;
    map['color'] = someNote.color;
    map['content'] = someNote.content;


    return map;
  }

  /*Interface methods*/
  Future<void> create(Note someNote)async{
    /*Gets a db connection and gets the
    *next id, which will be assigned to this record*/
    Database db = await _database;
    var val = await db.rawQuery(
      "SELECT MAX(id) + 1 AS id FROM notes"
    );
    int id = val.first['id'] == null ? 1 : val.first['id'];

    /*Inserts the record in the table*/
    return await db.rawInsert(
      "INSERT INTO notes (id, title, content, color)"
      "VALUES (?,?,?,?)",
      [id, someNote.title, someNote.content, someNote.color]
    );
  }

  Future<Note> get(int someId)async{
    /*Opens a db connection, and queries for input id,
    * to obtain the properties of the
    * the note.*/
    Database db = await _database;
    var resSet = await db.query(
      'notes',
      where: 'id=?',
      whereArgs: [someId]
    );

    /*Converts the object containing the properties of the note
    * to a Note object that will be returned*/
    return _map2Note(resSet.first);
  }

  Future<List> getAll() async {
    /*Gets a DB connection, and queries for all the
    * records in the notes table*/
    Database db = await _database;
    var resSet = await db.query(
      'notes'
    );

    /*Converts all the records returned in Note objects, and
    * puts them into a list, which will be returned.*/
    return resSet.isNotEmpty?
        resSet.map((inputElem)=>_map2Note(inputElem)).toList():[];
  }

  Future<void> update(Note someNote) async {
    /*Gets a DB connection, converts the input Note object into a
    * map object containing its properties, which will be used in
    * an update query*/
    Database db = await _database;
    return await db.update(
      'notes',
      _note2Map(someNote),
      where: 'id=?',
      whereArgs: [someNote.id]
    );
  }

  Future<void> delete(int someId) async {

    Database db = await _database;
    return await db.delete(
      'notes',
      where: 'id=?',
      whereArgs: [someId]
    );
  }

}