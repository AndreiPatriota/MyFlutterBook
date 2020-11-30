import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'notesdbworker.dart';
import 'notesmodel.dart' show Note, NotesModel, theNotesModel;

class NotesList extends StatelessWidget {


  void _deleteNote(BuildContext someContext, Note someNote) =>
      showDialog(
        context: someContext,
        barrierDismissible: false,
        builder: (BuildContext anotherContext) =>
            AlertDialog(
              title: Text('Delete Note'),
              content: Text('Are you sure you want to delete ${someNote.title}'),
              actions: [
                FlatButton(
                  onPressed: (){
                    Navigator.of(anotherContext).pop();
                  },
                  child: Text('Cancel')
                ),
                FlatButton(
                    onPressed: ()async{
                      await NotesDBWorker.db.delete(someNote.id);
                      Navigator.of(anotherContext).pop();

                      Scaffold.of(someContext).showSnackBar(
                        SnackBar(
                          content: Text('The note has been deleted'),
                          backgroundColor: Colors.red,
                          duration: Duration(seconds: 2),
                        )
                      );
                      theNotesModel.loadData('notes', NotesDBWorker.db);
                    },
                    child: Text('Delete')
                )
              ],
            )
      );

  @override
  Widget build(BuildContext context) => ScopedModel<NotesModel>(
        model: theNotesModel,
        child: ScopedModelDescendant<NotesModel>(
            builder: (BuildContext someContext, Widget someChild,
                    NotesModel someModel) =>
                Scaffold(
                  floatingActionButton: FloatingActionButton(
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      var newNote = Note();

                      someModel.entityBeingEdited = newNote;
                      someModel.color = null;
                      someModel.stackIndex = 1;
                    },
                  ),
                  body: ListView.builder(
                      itemCount: someModel.entityList.length,
                      itemBuilder: (BuildContext someContext, int someIndex) {
                        Note oneNote = someModel.entityList[someIndex];
                        Color oneColor = Colors.white;

                        switch (oneNote.color) {
                          case 'red':
                            oneColor = Colors.red;
                            break;
                          case 'green':
                            oneColor = Colors.green;
                            break;
                          case 'blue':
                            oneColor = Colors.blue;
                            break;
                          case 'yellow':
                            oneColor = Colors.yellow;
                            break;
                          case 'grey':
                            oneColor = Colors.grey;
                            break;
                          case 'purple':
                            oneColor = Colors.purple;
                            break;
                        }

                        return Container(
                          padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                          child: Slidable(
                            delegate: SlidableDrawerDelegate(),
                            actionExtentRatio: .25,
                            secondaryActions: [
                              IconSlideAction(
                                icon: Icons.delete,
                                color: Colors.red,
                                caption: 'Delete',
                                onTap: () => _deleteNote(someContext, oneNote),
                              )
                            ],
                            child: Card(
                              elevation: 8,
                              color: oneColor,
                              child: ListTile(
                                title: Text('${oneNote.title}; id:${oneNote.id}'),
                                subtitle: Text('${oneNote.content}'),
                                onTap: () async {
                                  print('Ponto E');
                                  someModel.entityBeingEdited =
                                  await NotesDBWorker.db.get(someIndex + 1);
                                  someModel.color =
                                      someModel.entityBeingEdited.color;
                                  someModel.stackIndex = 1;
                                },
                              ),
                            ),
                          ),
                        );
                      }
                      ),
                )
        ),
      );
}
