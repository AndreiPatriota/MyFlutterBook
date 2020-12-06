import 'package:flutter_book/dbworker.dart';
import 'package:scoped_model/scoped_model.dart';

class BaseModel extends Model{

  int _stackIndex;
  List<dynamic> _entityList = [];
  var entityBeingEdited;
  String _chosenDate;


  int get stackIndex => _stackIndex;
  List get entityList => _entityList;
  String get chosenDate => _chosenDate;

  set chosenDate(String someDate){
    _chosenDate = someDate;
    notifyListeners();
  }
  set stackIndex(int someStackIndex){
    _stackIndex = someStackIndex;
    notifyListeners();
  }


  void loadData(String entityType, dynamic db) async{
    _entityList = await db.getAll();

   /* if(table == DbTable.NOTES){
      _entityList = await db.getAll(table: DbTable.NOTES);
    }

    if(table == DbTable.TASKS){
      _entityList = await db.getAll(table: DbTable.TASKS);
    }*/

    notifyListeners();
  }

}