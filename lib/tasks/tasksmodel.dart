import 'package:flutter_book/basemodel.dart';

class Task{

  int id;
  String description;
  String dueDate;
  String completed;

  Task(){
    completed = 'false';
    description = '';
  }

}

class TasksModel extends BaseModel{

  TasksModel(){
    this.stackIndex = 0;
    this.entityBeingEdited = Task();
  }

  //static final TasksModel mdl = TasksModel._();

}

TasksModel theTasksModel = TasksModel();