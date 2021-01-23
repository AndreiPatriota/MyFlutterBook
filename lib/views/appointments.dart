import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_book/db/dbworker.dart' show DBWorker;
import 'appointmentslist.dart';
import 'appointmentsentry.dart';
import '../models/appointmentsmodel.dart' show AppointmentsModel, theAppointmentsModel;

class Appointments extends StatelessWidget{

  Appointments(){
    theAppointmentsModel.loadData('appointments', DBWorker.db.appointments);
  }

  @override
  Widget build(BuildContext inContext) =>
      ScopedModel<AppointmentsModel>(
          model: theAppointmentsModel,
          child: ScopedModelDescendant<AppointmentsModel>(
            builder: (BuildContext someContext,
                Widget someChild,
                AppointmentsModel someModel) =>
                IndexedStack(
                  index: someModel.stackIndex,
                  children: [AppointmentsList(), AppointmentsEntry()],
                ),
          )
      );
}
