import 'package:scoped_model/scoped_model.dart';

class BaseModel extends Model{

  int _stackIndex;
  List _entityList = [];
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

  void loadData(String someEntityType, dynamic someDatabase) async{
    _entityList = await someDatabase.getAll();
    notifyListeners();
  }

}