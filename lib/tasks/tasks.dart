import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../db/tasksdbworker.dart';
import 'taskslist.dart';
import 'tasksentry.dart';
import 'tasksmodel.dart' show TasksModel, theTasksModel;
import '../db/dbworker.dart';
/*
class Tasks extends StatelessWidget{

  Tasks(){
    print('Hello from tasks model');
    theTasksModel.loadData('tasks', DBWorker.db);
  }

  @override
  Widget build(BuildContext inContext) =>
      ScopedModel<TasksModel>(
          model: theTasksModel,
          child: ScopedModelDescendant<TasksModel>(
            builder: (BuildContext someContext,
                Widget someChild,
                TasksModel someModel) =>
                IndexedStack(
                  index: someModel.stackIndex,
                  children: [TasksList(), TasksEntry()],
                ),
          )
      );
}*/
