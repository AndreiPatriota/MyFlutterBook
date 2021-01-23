import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../utils.dart' as utils;
import '../models/contactsmodel.dart';

class ContactsTable{

  Database _db;

  ContactsTable(Database db){
    _db = db;
  }

  Future<Database> get _database async{

    if(_db == null){
      _db = await _init();
    }

    return _db;
  }

  Future<Database> _init() async{

    var path = join(utils.docsDir.path, 'myFucking4.db');
    Database db = await openDatabase(
        path,
        version: 1,
        onOpen: (db){},
        onCreate: (Database someDB, int someVersion)async{

          print('Database created!!!!!!!!!!!');

          await someDB.execute(
              "CREATE TABLE IF NOT EXISTS notes("
                  "id INTEGER UNIQUE PRIMARY KEY,"
                  "title TEXT,"
                  "content TEXT,"
                  "color TEXT"
                  ")"
          );

          await someDB.execute(
              "CREATE TABLE IF NOT EXISTS tasks("
                  "id INTEGER UNIQUE PRIMARY KEY,"
                  "description TEXT,"
                  "completed TEXT,"
                  "dueDate TEXT"
                  ")"
          );

          await someDB.execute(
              "CREATE TABLE IF NOT EXISTS appointments("
                  "id INTEGER PRIMARY KEY,"
                  "title TEXT,"
                  "description TEXT,"
                  "apptDate TEXT,"
                  "apptTime TEXT"
                  ")"
          );

          await someDB.execute(
              "CREATE TABLE IF NOT EXISTS contacts("
                  "id INTEGER PRIMARY KEY,"
                  "name TEXT,"
                  "email TEXT,"
                  "phone TEXT,"
                  "birthday TEXT"
                  ")"
          );

        }
    );

    return db;
  }

  Contact _map2Contact(Map someMap){

    Contact contact = Contact();
    contact.id = someMap['id'];
    contact.birthday = someMap['birthday'];
    contact.phone = someMap['phone'];
    contact.email = someMap['email'];
    contact.name = someMap['name'];

    return contact;
  }

  Map<String, dynamic> _contact2Map(Contact someContact){

    Map<String, dynamic> map = Map<String, dynamic>();

    map['id'] = someContact.id;
    map['name'] = someContact.name;
    map['email'] = someContact.email;
    map['birthday'] = someContact.birthday;
    map['phone'] = someContact.phone;


    return map;
  }

  Future<void> create(Contact someContact)async{

    Database db = await _database;
    var val = await db.rawQuery(
        "SELECT MAX(id) + 1 AS id FROM contacts"
    );

    int id = val.first['id'] == null ? 1 : val.first['id'];

    return await db.rawInsert(
        "INSERT INTO contacts (id, name, email, birthday, phone)"
            "VALUES (?,?,?,?,?)",
        [id,
          someContact.name,
          someContact.email,
          someContact.birthday,
          someContact.phone]
    );
  }

  Future<Contact> get(int someId)async{

    Database db = await _database;
    var resSet = await db.query(
        'contacts',
        where: 'id=?',
        whereArgs: [someId]
    );

    return _map2Contact(resSet.first);
  }

  Future<List> getAll() async {

    Database db = await _database;
    var resSet = await db.query(
        'contacts'
    );

    return resSet.isNotEmpty?
    resSet.map((inputElem)=>_map2Contact(inputElem)).toList():[];
  }

  Future<void> update(Contact someContact) async {

    Database db = await _database;
    return await db.update(
        'contacts',
        _contact2Map(someContact),
        where: 'id=?',
        whereArgs: [someContact.id]
    );
  }

  Future<void> delete(int someId) async {

    Database db = await _database;
    return await db.delete(
        'contacts',
        where: 'id=?',
        whereArgs: [someId]
    );
  }

}