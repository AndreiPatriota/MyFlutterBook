import 'package:flutter/material.dart';
import 'package:flutter_book/db/dbworker.dart';
import 'package:scoped_model/scoped_model.dart';
import '../models/tasksmodel.dart' show TasksModel, theTasksModel;
import '../utils.dart' show selectDate;

class TasksEntry extends StatelessWidget{

  final TextEditingController _descriptionEditingController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  TasksEntry(){
    _descriptionEditingController.addListener(() {
      theTasksModel.entityBeingEdited.description = _descriptionEditingController.text;
    }
    );

  }

  void _save(BuildContext inContext, TasksModel inModel)async{

    if(!_formKey.currentState.validate()){return;}

    //Update DB
    if(inModel.entityBeingEdited.id == null){
      await DBWorker.db.tasks.create(inModel.entityBeingEdited);
    }else{
      await DBWorker.db.tasks.update(inModel.entityBeingEdited);
    }
    //Update Model and return to TasksList View
    inModel.loadData('tasks', DBWorker.db.tasks);
    inModel.chosenDate = null;
    inModel.stackIndex = 0;
    //Show SnackBar
    Scaffold.of(inContext).showSnackBar(
        SnackBar(
          content: Text('Note saved'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.green,
        )
    );

  }

  @override
  Widget build(BuildContext context){

    _descriptionEditingController.text = 
                                  theTasksModel.entityBeingEdited.description;

    return ScopedModel<TasksModel>(
      model: theTasksModel,
      child: ScopedModelDescendant<TasksModel>(
        builder: (BuildContext someContext, Widget someWidget,
            TasksModel someModel){
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
                    leading: Icon(Icons.note),
                    title: TextFormField(
                        decoration: InputDecoration(hintText: 'Description'),
                        controller: _descriptionEditingController,
                        validator: (String someStr)
                        => someStr.length == 0?'Please, enter a Description':null
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.content_paste),
                    trailing: IconButton(
                      icon: Icon(Icons.edit),
                      color: Colors.blue,
                      onPressed: ()async{
                        var chosenDate = await selectDate(someContext,
                                someModel, someModel.entityBeingEdited.dueDate);
                        if(chosenDate != null){
                          someModel.entityBeingEdited.dueDate = chosenDate;
                        }
                      },
                    ),
                    title: Text('Due Date'),
                    subtitle: Text(someModel.chosenDate == null?
                            '':someModel.chosenDate),

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