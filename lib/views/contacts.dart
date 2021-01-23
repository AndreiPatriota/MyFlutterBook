import 'package:flutter/material.dart';
import 'package:flutter_book/db/dbworker.dart';
import 'package:scoped_model/scoped_model.dart';
import 'contactslist.dart';
import 'contactsentry.dart';
import '../models/contactsmodel.dart' show ContactsModel, theContactsModel;

class Contacts extends StatelessWidget{

  Contacts(){
    print('Hello from contacts contructor');
    theContactsModel.loadData('contacts', DBWorker.db.contacts);
  }

  @override
  Widget build(BuildContext inContext) =>
      ScopedModel<ContactsModel>(
          model: theContactsModel,
          child: ScopedModelDescendant<ContactsModel>(
            builder: (BuildContext someContext,
                Widget someChild,
                ContactsModel someModel) =>
                IndexedStack(
                  index: someModel.stackIndex,
                  children: [ContactsList(7), ContactsEntry()],
                ),
          )
      );
}
