import 'package:flutter_book/basemodel.dart';

class Contact{

  int id;
  String name;
  String phone;
  String email;
  String birthday;

  Contact(){
    name = '';
    phone = '';
    email = '';
  }

}

class ContactsModel extends BaseModel{

  ContactsModel(){
    this.stackIndex = 0;
    this.entityBeingEdited = Contact();
  }

  void triggerRebuild(){
    notifyListeners();
  }

}

ContactsModel theContactsModel = ContactsModel();