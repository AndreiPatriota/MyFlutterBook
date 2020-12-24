import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
//import '../dbworker.dart';
import 'appointmentsdbworker.dart';
import 'appointmentslist.dart';
import 'appointmentsentry.dart';
import 'appointmentsmodel.dart' show AppointmentsModel, theAppointmentsModel;

class Appointments extends StatelessWidget{

  Appointments(){
    theAppointmentsModel.loadData('appointments', AppointmentsDBWorker.db);
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
