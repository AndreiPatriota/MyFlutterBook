import 'package:flutter_book/basemodel.dart';

class Appointment{

  int id;
  String title;
  String description;
  String apptDate;
  String apptTime;

  Appointment(){
    title = '';
    description = '';
  }

}

class AppointmentsModel extends BaseModel{

  String _apptTime;

  AppointmentsModel(){
    this.stackIndex = 0;
    this.entityBeingEdited = Appointment();
  }

  set apptTime(String inTime){
    _apptTime = inTime;
    notifyListeners();
  }

  String get apptTime => _apptTime;

}

AppointmentsModel theAppointmentsModel = AppointmentsModel();