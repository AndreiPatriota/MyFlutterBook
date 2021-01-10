import 'package:flutter/material.dart';
import 'package:flutter_book/db/dbworker.dart';
import 'package:scoped_model/scoped_model.dart';
//import '../dbworker.dart';
import '../db/notestable.dart';
import 'noteslist.dart';
import 'notesentry.dart';
import 'notesmodel.dart' show NotesModel, theNotesModel;

class Notes extends StatelessWidget{

  Notes(){
    print('Hello from notes contructor');
    theNotesModel.loadData('notes', DBWorker.db.notes);
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
