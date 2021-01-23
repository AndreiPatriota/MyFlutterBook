import 'package:flutter_book/views/notes.dart';
import 'basemodel.dart' show BaseModel;
import '../db/dbworker.dart';

class Note{

  int id;
  String title;
  String content;
  String color;


  String toString() => "id=${this.id}, title=${this.title}"
  "content=${this.content}, color=${this.color}";

  static Note map2Note(Map someMap){

    Note note = Note();
    note.id = someMap['id'];
    note.title = someMap['title'];
    note.color = someMap['color'];
    note.content = someMap['content'];

    return note;
  }

  static Map<String, dynamic> note2Map(Note someNote){

    Map<String, dynamic> map = Map<String, dynamic>();

    map['id'] = someNote.id;
    map['title'] = someNote.title;
    map['color'] = someNote.color;
    map['content'] = someNote.content;


    return map;
  }

}

class NotesModel extends BaseModel{

  String _color;


  NotesModel(){
    this.stackIndex = 0;
    this.entityBeingEdited = Note();
  }

  String get color => _color;

  set color(String someColor){
    _color = someColor;
    notifyListeners();
  }

}

NotesModel theNotesModel = NotesModel();