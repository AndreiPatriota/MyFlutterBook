import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_book/tasks/tasksmodel.dart' show TasksModel, theTasksModel, Task;
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import '../db/dbworker.dart';

class TasksList extends StatelessWidget{

  void _deleteTask(BuildContext someContext, Task someTask) =>
      showDialog(
          context: someContext,
          barrierDismissible: false,
          builder: (BuildContext anotherContext) =>
              AlertDialog(
                title: Text('Delete Task'),
                content: Text('Are you sure you want to delete ${someTask.description} task?'),
                actions: [
                  FlatButton(
                      onPressed: (){
                        Navigator.of(anotherContext).pop();
                      },
                      child: Text('Cancel')
                  ),
                  FlatButton(
                      onPressed: ()async{
                        await DBWorker.db.tasks.delete(someTask.id); // Updates the DB
                        Navigator.of(anotherContext).pop();//Closes pop-up
                        //Shows the SnackBar
                        Scaffold.of(someContext).showSnackBar(
                            SnackBar(
                              content: Text('The task has been deleted'),
                              backgroundColor: Colors.red,
                              duration: Duration(seconds: 2),
                            )
                        );
                        theTasksModel.loadData('tasks', DBWorker.db.tasks);//Updates the model according to the DB
                      },
                      child: Text('Delete')
                  )
                ],
              )
      );

  @override
  Widget build(BuildContext context) =>
      ScopedModel(
        model: theTasksModel,
        child: ScopedModelDescendant<TasksModel>(
          builder: (BuildContext someContext,
                    Widget someWidget,
                    TasksModel someModel)=>
              Scaffold(
                floatingActionButton: FloatingActionButton(
                  child: Icon(Icons.add, color: Colors.white),
                  onPressed: (){
                    someModel.entityBeingEdited = Task();
                    someModel.stackIndex = 1;
                  },
                ),
                body: ListView.builder(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  itemCount: someModel.entityList.length,
                  itemBuilder: (BuildContext anotherContext,
                                int someIndex){
                    Task oneTask = someModel.entityList[someIndex];
                    String strDueDate;
                    DateTime dueDate;

                    if(oneTask.dueDate != null){
                      List dateParts = oneTask.dueDate.split(',');
                      dueDate = DateTime(int.parse(dateParts[0]),
                                         int.parse(dateParts[1]),
                                         int.parse(dateParts[2]));
                      strDueDate = DateFormat.yMMMMd('en_US').format(dueDate.toLocal());
                    }

                    return Slidable(
                      actionExtentRatio: 0.25,
                      child: ListTile(
                        leading: Checkbox(
                          value: oneTask.completed == 'true'?true:false,
                          onChanged: (bool checkBoxVal)async{
                            oneTask.completed = checkBoxVal.toString();
                            await DBWorker.db.tasks.update(oneTask);
                            someModel.loadData('tasks', DBWorker.db.tasks);
                          },
                        ),
                        title: Text(
                          '${oneTask.description}',
                          style: oneTask.completed == 'true'?
                              TextStyle(
                                color: Theme.of(someContext).disabledColor,
                                decoration: TextDecoration.lineThrough
                              ):
                              TextStyle(
                                color: Theme.of(someContext).textTheme.title.color 
                              ),
                        ),
                        subtitle: oneTask.dueDate == null?null:
                          Text(
                            strDueDate,
                            style: oneTask.completed == 'true'?
                                TextStyle(
                                  color: Theme.of(someContext).disabledColor,
                                  decoration: TextDecoration.lineThrough
                                ):
                                TextStyle(
                                  color: Theme.of(someContext).textTheme.title.color
                                )
                          ),
                        onTap: ()async{
                          
                          if(oneTask.completed == 'true'){return;}
                          
                          someModel.entityBeingEdited =
                          await DBWorker.db.tasks.get(oneTask.id);
                          if(someModel.entityBeingEdited.dueDate == null){
                            someModel.chosenDate = null;  
                          }else{
                            someModel.chosenDate = strDueDate;
                          }
                          
                          someModel.stackIndex = 1;
                          
                        },
                      ),
                      delegate: SlidableDrawerDelegate(),
                      secondaryActions: [
                        IconSlideAction(
                          caption: 'Delete',
                          color: Colors.red,
                          icon: Icons.delete,
                          onTap: ()=>_deleteTask(someContext, oneTask),
                        )
                      ],
                    );
                  }
                ),
              )
          ,
        )
      );

}
