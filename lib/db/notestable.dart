import 'package:flutter_book/db/dbworker.dart';
import 'package:sqflite/sqflite.dart';
import '../models/notesmodel.dart';

class NotesTable{

  Database _db;

  NotesTable(Database db){
    _db = db;
  }

  Future<Database> get _database async{

    if(_db == null){
      _db = await DBWorker.init();
    }
    
    return _db;
  }


  Note _map2Note(Map someMap){

    Note note = Note();
    note.id = someMap['id'];
    note.title = someMap['title'];
    note.color = someMap['color'];
    note.content = someMap['content'];

    return note;
  }

  Map<String, dynamic> _note2Map(Note someNote){

    Map<String, dynamic> map = Map<String, dynamic>();

    map['id'] = someNote.id;
    map['title'] = someNote.title;
    map['color'] = someNote.color;
    map['content'] = someNote.content;


    return map;
  }

  Future<void> create(Note someNote)async{

    Database db = await _database;
    var val = await db.rawQuery(
      "SELECT MAX(id) + 1 AS id FROM notes"
    );

    int id = val.first['id'] == null ? 1 : val.first['id'];

    return await db.rawInsert(
      "INSERT INTO notes (id, title, content, color)"
      "VALUES (?,?,?,?)",
      [id, someNote.title, someNote.content, someNote.color]
    );
  }

  Future<Note> get(int someId)async{

    Database db = await _database;
    var resSet = await db.query(
      'notes',
      where: 'id=?',
      whereArgs: [someId]
    );

    return _map2Note(resSet.first);
  }

  Future<List> getAll() async {

    Database db = await _database;
    var resSet = await db.query(
      'notes'
    );

    return resSet.isNotEmpty?
        resSet.map((inputElem)=>_map2Note(inputElem)).toList():[];
  }

  Future<void> update(Note someNote) async {

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