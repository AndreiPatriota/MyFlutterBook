import 'package:flutter/material.dart';
import 'package:flutter_book/db/dbworker.dart' show DBWorker;
import 'package:scoped_model/scoped_model.dart';
import 'appointmentsmodel.dart' show AppointmentsModel, theAppointmentsModel;
import '../utils.dart' show selectDate;

class AppointmentsEntry extends StatelessWidget{

  final TextEditingController _titleEditingController = TextEditingController();
  final TextEditingController _descriptionEditingController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  AppointmentsEntry(){
    _titleEditingController.addListener(() {
      theAppointmentsModel.entityBeingEdited.title = _titleEditingController.text;
    }
    );

    _descriptionEditingController.addListener(() {
      theAppointmentsModel.entityBeingEdited.description = _descriptionEditingController.text;
    }
    );

  }

  Future<void> _selectTime(BuildContext inContext)async{
    //Initialize the time as now
    TimeOfDay initialTime = TimeOfDay.now();

    //if no time has been assigned to the current Appointment being edited,
    // keep it as now
    if(theAppointmentsModel.entityBeingEdited.apptTime != null) {
      List<String> timeParts =
      theAppointmentsModel.entityBeingEdited.apptTime.split(',');
      initialTime = TimeOfDay(
          hour: int.parse(timeParts[0]),
          minute: int.parse(timeParts[1]));
    }

    //Built-in Time Picked UI
    TimeOfDay picked = await showTimePicker(
        context: inContext,
        initialTime: initialTime);

    //If a time was picked, update the Appointment time in both the current
    //appointment and in the model itself
    if(picked != null) {
      theAppointmentsModel.entityBeingEdited.apptTime =
      '${picked.hour},${picked.minute}';
      theAppointmentsModel.apptTime = picked.format(inContext);
    }
  }

  void _save(BuildContext inContext, AppointmentsModel inModel)async{

    print('Ponto a');
    if(!_formKey.currentState.validate()){return;}
    print('ponto b');

    //Update DB
    if(inModel.entityBeingEdited.id == null){
      await DBWorker.db.appointments.create(inModel.entityBeingEdited);
    }else{
      await DBWorker.db.appointments.update(inModel.entityBeingEdited);
    }
    //Update Model and return to AppointmentsList View
    inModel.loadData('appointments', DBWorker.db.appointments);
    inModel.chosenDate = null;
    inModel.stackIndex = 0;
    //Show SnackBar
    Scaffold.of(inContext).showSnackBar(
        SnackBar(
          content: Text('Appointment saved'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.green,
        )
    );

  }

  @override
  Widget build(BuildContext context){

    _titleEditingController.text =
        theAppointmentsModel.entityBeingEdited.title;

    _descriptionEditingController.text =
        theAppointmentsModel.entityBeingEdited.description;


    return ScopedModel<AppointmentsModel>(
      model: theAppointmentsModel,
      child: ScopedModelDescendant<AppointmentsModel>(
        builder: (BuildContext someContext, Widget someWidget,
            AppointmentsModel someModel){
          return Scaffold(
            bottomNavigationBar: Padding(
              padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 10),
              child: Row(
                children: [
                  FlatButton(
                      onPressed: (){
                        FocusScope.of(someContext).requestFocus(FocusNode());
                        someModel.stackIndex = 0;
                      },
                      child: Text('Cancel')
                  ),
                  Spacer(),
                  FlatButton(
                      onPressed: (){
                        _save(someContext, someModel);
                      },
                      child: Text('Save')
                  )
                ],
              ),
            ),
            body: Form(
              key: _formKey,
              child: ListView(
                children: [
                  ListTile(
                    leading: Icon(Icons.title),
                    title: TextFormField(
                        decoration: InputDecoration(hintText: 'Title'),
                        controller: _titleEditingController,
                        validator: (String someStr)
                        => someStr.length == 0?'Please, enter a Title':null
                    ),
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.subtitles),
                    title: TextFormField(
                      maxLines: 8,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(hintText: 'Description'),
                      controller: _descriptionEditingController,
                    ),
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.date_range_outlined),
                    trailing: IconButton(
                      icon: Icon(Icons.edit),
                      color: Colors.blue,
                      onPressed: ()async{
                        var chosenDate = await selectDate(someContext,
                            someModel, someModel.entityBeingEdited.apptDate);
                        if(chosenDate != null){
                          someModel.entityBeingEdited.apptDate = chosenDate;
                        }
                      },
                    ),
                    title: Text('Date'),
                    subtitle: Text(someModel.chosenDate == null?
                    '':someModel.chosenDate),
                  ),
                  ListTile(
                    leading: Icon(Icons.alarm),
                    trailing: IconButton(
                        icon: Icon(Icons.edit),
                        color: Colors.blue,
                        onPressed: ()async{
                          await _selectTime(someContext);
                        }
                    ),
                    title: Text('Time'),
                    subtitle: Text(someModel.apptTime == null?
                    '':someModel.apptTime),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

}
