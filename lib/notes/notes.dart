import 'package:flutter/material.dart';
import 'package:flutter_book/dbworker.dart';
import 'package:scoped_model/scoped_model.dart';
//import '../dbworker.dart';
import 'notesdbworker.dart';
import 'noteslist.dart';
import 'notesentry.dart';
import 'notesmodel.dart' show NotesModel, theNotesModel;

class Notes extends StatelessWidget{

  Notes(){
    print('Hello from notes contructor');
    theNotesModel.loadData(DBTable.NOTES, DBWorker.db);
  }

  @override
  Widget build(BuildContext inContext) =>
      ScopedModel<NotesModel>(
        model: theNotesModel,
        child: ScopedModelDescendant<NotesModel>(
          builder: (BuildContext someContext,
                    Widget someChild,
                    NotesModel someModel) =>
            IndexedStack(
              index: someModel.stackIndex,
              children: [NotesList(), NotesEntry()],
            ),
        )
      );
}
