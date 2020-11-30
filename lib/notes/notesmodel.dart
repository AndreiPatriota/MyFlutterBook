import 'package:flutter_book/notes/notes.dart';
import '../basemodel.dart' show BaseModel;

class Note{

  int id;
  String title;
  String content;
  String color;


  String toString() => "id=${this.id}, title=${this.title}"
  "content=${this.content}, color=${this.color}";
}

class NotesModel extends BaseModel{

  String _color;


  NotesModel(){
    this.stackIndex = 0;
  }

  String get color => _color;

  set color(String someColor){
    _color = someColor;
    notifyListeners();
  }

}

NotesModel theNotesModel = NotesModel();