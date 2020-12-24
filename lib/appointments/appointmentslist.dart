import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'appointmentsdbworker.dart';
import 'appointmentsmodel.dart'
    show theAppointmentsModel, AppointmentsModel, Appointment;

class AppointmentsList extends StatelessWidget {

  void _editAppointment(
      BuildContext inContext, Appointment inAppointment) async {
    //return the particular Appointment object from DB and assigns it to the
    //model`s attribute entityBeingEdited
    theAppointmentsModel.entityBeingEdited =
        await AppointmentsDBWorker.db.get(inAppointment.id);

    print(theAppointmentsModel.entityBeingEdited);

    //If the model`s entityBeingEdited has an empty apptDate param, assign null to the model`s
    //chosenDate param. Else, assign this with the later after applying the proper type
    //conversion
    if (theAppointmentsModel.entityBeingEdited.apptDate == null) {
      theAppointmentsModel.chosenDate = null;
    } else {
      List dateParts =
          theAppointmentsModel.entityBeingEdited.apptDate.split(',');
      DateTime apptDate = DateTime(int.parse(dateParts[0]),
          int.parse(dateParts[1]), int.parse(dateParts[2]));

      theAppointmentsModel.chosenDate =
          DateFormat.yMMMMd('en_US').format(apptDate.toLocal());
    }

    //Same as previous conditional statement, but for the apptTime param
    if (theAppointmentsModel.entityBeingEdited.apptTime == null) {
      theAppointmentsModel.apptTime = null;
    } else {
      List timeParts =
          theAppointmentsModel.entityBeingEdited.apptTime.split(',');
      TimeOfDay at = TimeOfDay(
          hour: int.parse(timeParts[0]), minute: int.parse(timeParts[1]));

      theAppointmentsModel.apptTime = at.format(inContext);
    }

    theAppointmentsModel.stackIndex = 1; //goes to entry screen
    Navigator.pop(inContext); //closes the current context
  }

  void _deleteAppointment(BuildContext inContext, Appointment inAppointment) =>
      showDialog(
          context: inContext,
          barrierDismissible: false,
          builder: (BuildContext anotherContext) => AlertDialog(
                title: Text('Delete Appointment'),
                content: Text(
                    'Are you sure you want to delete ${inAppointment.title}'),
                actions: [
                  FlatButton(
                      onPressed: () {
                        Navigator.of(anotherContext).pop();
                      },
                      child: Text('Cancel')),
                  FlatButton(
                      onPressed: () async {
                        await AppointmentsDBWorker.db.delete(inAppointment.id);
                        Navigator.of(anotherContext).pop();

                        Scaffold.of(inContext).showSnackBar(SnackBar(
                          content: Text('The note has been deleted'),
                          backgroundColor: Colors.red,
                          duration: Duration(seconds: 2),
                        ));
                        theAppointmentsModel.loadData(
                            'notes', AppointmentsDBWorker.db);
                      },
                      child: Text('Delete'))
                ],
              ));

  void _showAppointments(DateTime inDate, BuildContext inContext) async {
    showBottomSheet(
        context: inContext,
        builder: (BuildContext someContext) => ScopedModel(
            model: theAppointmentsModel,
            child: ScopedModelDescendant<AppointmentsModel>(
                builder: (BuildContext someContext, Widget someWidget,
                        AppointmentsModel someModel) =>
                    Scaffold(
                      body: Container(
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: GestureDetector(
                            child: Column(
                              children: [
                                Text(
                                  DateFormat.yMMMMd('en_US')
                                      .format(inDate.toLocal()),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Theme.of(someContext).accentColor,
                                      fontSize: 24),
                                ),
                                Divider(),
                                Expanded(
                                    child: ListView.builder(
                                  itemCount:
                                      theAppointmentsModel.entityList.length,
                                  itemBuilder:
                                      (BuildContext someContext, int someIdx) {
                                    Appointment oneAppointment =
                                        someModel.entityList[someIdx];
                                    String apptTime = "";

                                    if (oneAppointment.apptDate !=
                                        '${inDate.year},${inDate.month},${inDate.day}') {
                                      return Container(height: 0);
                                    }

                                    if (oneAppointment.apptTime != null) {
                                      List timeParts =
                                          oneAppointment.apptTime.split(',');
                                      TimeOfDay at = TimeOfDay(
                                          hour: int.parse(timeParts[0]),
                                          minute: int.parse(timeParts[1]));

                                      apptTime = ' (${at.format(someContext)})';
                                    }

                                    return Slidable(
                                      child: Container(
                                        margin: EdgeInsets.only(bottom: 8),
                                        color: Colors.grey.shade300,
                                        child: ListTile(
                                          title: Text(
                                              '${oneAppointment.title}$apptTime'),
                                          subtitle: oneAppointment
                                                      .description ==
                                                  null
                                              ? null
                                              : Text(
                                                  '${oneAppointment.description}'),
                                          onTap: () async {
                                            _editAppointment(
                                                someContext, oneAppointment);
                                          },
                                        ),
                                      ),
                                      actionExtentRatio: .25,
                                      delegate: SlidableDrawerDelegate(),
                                      secondaryActions: [
                                        IconSlideAction(
                                          icon: Icons.delete,
                                          caption: 'Delete',
                                          color: Colors.red,
                                          onTap: () {
                                            _deleteAppointment(
                                                someContext, oneAppointment);
                                          },
                                        )
                                      ],
                                    );
                                  },
                                ))
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
            )
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    EventList<Event> _markedDateMap = EventList();
    theAppointmentsModel.entityList.forEach((appointment) {
      List<String> dateParts = appointment.apptDate.split(',');
      DateTime apptDate = DateTime(int.parse(dateParts[0]),
          int.parse(dateParts[1]), int.parse(dateParts[2]));

      _markedDateMap.add(
          apptDate,
          Event(
              date: apptDate,
              icon: Container(
                decoration: BoxDecoration(color: Colors.blue),
              )));
    });

    return ScopedModel(
        model: theAppointmentsModel,
        child: ScopedModelDescendant<AppointmentsModel>(
            builder: (someContext, someWidget, someModel) => Scaffold(
                  floatingActionButton: FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () async {
                      someModel.entityBeingEdited = Appointment();
                      DateTime now = DateTime.now();
                      someModel.entityBeingEdited.apptDate = '${now.year},'
                          '${now.month},${now.day}';

                      someModel.chosenDate =
                          DateFormat.yMMMMd('en_US').format(now.toLocal());
                      someModel.apptTime = TimeOfDay.now().format(someContext);
                      someModel.stackIndex = 1;
                    },
                  ),
                  body: Column(
                    children: [
                      Expanded(
                          child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 10.0),
                        child: CalendarCarousel<Event>(
                          thisMonthDayBorderColor: Colors.grey,
                          daysHaveCircularBorder: false,
                          markedDatesMap: _markedDateMap,
                          onDayPressed:
                              (DateTime someDate, List<Event> fewEvents) {
                            _showAppointments(someDate, someContext);
                          },
                        ),
                      ))
                    ],
                  ),
                )));
  }
}
