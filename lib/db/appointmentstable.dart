import 'package:flutter_book/db/dbworker.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_book/models/appointmentsmodel.dart' show Appointment;

class AppointmentsTable{

  Database _db;

  AppointmentsTable(Database db){
    _db = db;
  }


  Future<Database> get _database async{

    if(_db == null){
      _db = await DBWorker.init();
    }

    return _db;
  }


  Appointment _map2Appointment(Map someMap){

    Appointment appointment = Appointment();
    appointment.id = someMap['id'];
    appointment.title = someMap['title'];
    appointment.description = someMap['description'];
    appointment.apptDate = someMap['apptDate'];
    appointment.apptTime = someMap['apptTime'];

    return appointment;
  }

  Map<String, dynamic> _appointment2Map(Appointment someAppointment){

    Map<String, dynamic> map = Map<String, dynamic>();

    map['id'] = someAppointment.id;
    map['title'] = someAppointment.title;
    map['description'] = someAppointment.description;
    map['apptDate'] = someAppointment.apptDate;
    map['apptTime'] = someAppointment.apptTime;


    return map;
  }

  Future<void> create(Appointment someAppointment)async{

    Database db = await _database;
    var val = await db.rawQuery(
        "SELECT MAX(id) + 1 AS id FROM appointments"
    );

    int id = val.first['id'] == null ? 1 : val.first['id'];

    return await db.rawInsert(
        "INSERT INTO appointments (id, title, description, apptDate, apptTime)"
            "VALUES (?,?,?,?,?)",
        [id, someAppointment.title, someAppointment.description,
          someAppointment.apptDate, someAppointment.apptTime]
    );
  }

  Future<Appointment> get(int someId)async{

    Database db = await _database;
    var resSet = await db.query(
        'appointments',
        where: 'id=?',
        whereArgs: [someId]
    );

    return _map2Appointment(resSet.first);
  }

  Future<List> getAll() async {

    Database db = await _database;
    var resSet = await db.query(
        'appointments'
    );

    return resSet.isNotEmpty?
    resSet.map((inputElem)=>_map2Appointment(inputElem)).toList():[];
  }

  Future<void> update(Appointment someAppointment) async {

    Database db = await _database;
    return await db.update(
        'appointments',
        _appointment2Map(someAppointment),
        where: 'id=?',
        whereArgs: [someAppointment.id]
    );
  }

  Future<void> delete(int someId) async {

    Database db = await _database;
    return await db.delete(
        'appointments',
        where: 'id=?',
        whereArgs: [someId]
    );
  }

}

