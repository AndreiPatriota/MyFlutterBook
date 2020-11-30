import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'notesdbworker.dart';
import 'notesmodel.dart' show NotesModel, theNotesModel;

class NotesEntry extends StatelessWidget{

  final TextEditingController _titleEditingController = TextEditingController();
  final TextEditingController _contentEditingController =
                                                TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  NotesEntry(){
    _titleEditingController.addListener(() {
      theNotesModel.entityBeingEdited.title = _titleEditingController.text;
    }
    );
    _contentEditingController.addListener(() {
      theNotesModel.entityBeingEdited.content = _contentEditingController.text;
    }
    );
  }

  void _save(BuildContext inContext, NotesModel inModel)async{

    print('ponto A');
    if(!_formKey.currentState.validate()){return;}
    print('Ponto B');

    if(inModel.entityBeingEdited.id == null){
      await NotesDBWorker.db.create(inModel.entityBeingEdited);
    }else{
      await NotesDBWorker.db.update(inModel.entityBeingEdited);
    }

    print('Ponto C');
    inModel.loadData('notes', NotesDBWorker.db);
    print('Ponto D');
    inModel.stackIndex = 0;

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

    _titleEditingController.text = theNotesModel.entityBeingEdited.title;
    _contentEditingController.text = theNotesModel.entityBeingEdited.content;

    return ScopedModel<NotesModel>(
      model: theNotesModel,
      child: ScopedModelDescendant<NotesModel>(
        builder: (BuildContext someContext, Widget someWidget,
            NotesModel someModel){
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
                        _save(someContext, theNotesModel);
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
                        => someStr.length == 0?'Please, enter a title':null
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.content_paste),
                    title: TextFormField(
                      maxLines: 8,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(hintText: 'Content'),
                      controller: _contentEditingController,
                      validator: (String someStr)
                        => someStr.length == 0?'Please, enter a content':null
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.color_lens),
                    title: Row(
                      children: [
                        GestureDetector(
                          onTap: (){
                            theNotesModel.entityBeingEdited.color = 'red';
                            theNotesModel.color = 'red';
                          },
                          child: Container(
                            decoration: ShapeDecoration(
                              shape: Border.all(width: 18, color: Colors.red) +
                                Border.all(width: 6,
                                    color: theNotesModel.color == 'red'?
                                    Colors.red:Theme.of(someContext).canvasColor),
                            ),
                          ),
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: (){
                            theNotesModel.entityBeingEdited.color = 'blue';
                            theNotesModel.color = 'blue';
                          },
                          child: Container(
                            decoration: ShapeDecoration(
                              shape: Border.all(width: 18, color: Colors.blue) +
                                  Border.all(width: 6,
                                      color: theNotesModel.color == 'blue'?
                                      Colors.blue:Theme.of(someContext).canvasColor),
                            ),
                          ),
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: (){
                            theNotesModel.entityBeingEdited.color = 'green';
                            theNotesModel.color = 'green';
                          },
                          child: Container(
                            decoration: ShapeDecoration(
                              shape: Border.all(width: 18, color: Colors.green) +
                                  Border.all(width: 6,
                                      color: theNotesModel.color == 'green'?
                                      Colors.green:Theme.of(someContext).canvasColor),
                            ),
                          ),
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: (){
                            theNotesModel.entityBeingEdited.color = 'yellow';
                            theNotesModel.color = 'yellow';
                          },
                          child: Container(
                            decoration: ShapeDecoration(
                              shape: Border.all(width: 18, color: Colors.yellow) +
                                  Border.all(width: 6,
                                      color: theNotesModel.color == 'yellow'?
                                      Colors.yellow:Theme.of(someContext).canvasColor),
                            ),
                          ),
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: (){
                            theNotesModel.entityBeingEdited.color = 'grey';
                            theNotesModel.color = 'grey';
                          },
                          child: Container(
                            decoration: ShapeDecoration(
                              shape: Border.all(width: 18, color: Colors.grey) +
                                  Border.all(width: 6,
                                      color: theNotesModel.color == 'grey'?
                                      Colors.grey:Theme.of(someContext).canvasColor),
                            ),
                          ),
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: (){
                            theNotesModel.entityBeingEdited.color = 'purple';
                            theNotesModel.color = 'purple';
                          },
                          child: Container(
                            decoration: ShapeDecoration(
                              shape: Border.all(width: 18, color: Colors.purple) +
                                  Border.all(width: 6,
                                      color: theNotesModel.color == 'purple'?
                                      Colors.purple:Theme.of(someContext).canvasColor),
                            ),
                          ),
                        )
                      ],
                    ),
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