import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_book/contacts/contactsmodel.dart';
import 'package:flutter_book/db/dbworker.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import '../utils.dart' as utils;
import 'package:path/path.dart';
import 'contactsmodel.dart' show Contact, ContactsModel, theContactsModel;

class ContactsList extends StatelessWidget{

  ContactsList(int cu){
    print('Aparece porrraaaa!!');
  }

  Future<void> _deleteContact(BuildContext inContext, Contact inContact)async{
    showDialog(
        context: inContext,
        barrierDismissible: false,
        builder: (BuildContext anotherContext) =>
            AlertDialog(
              title: Text('Delete Contact'),
              content: Text('Are you sure you want to delete ${inContact.name}'),
              actions: [
                FlatButton(
                    onPressed: (){
                      Navigator.of(anotherContext).pop();
                    },
                    child: Text('Cancel')
                ),
                FlatButton(
                    onPressed: ()async{
                      //Tries to retrieve the the contact`s avatar file.
                      File avatarFile = File(join(utils.docsDir.path,
                          inContact.id.toString())
                      );

                      //In case the avatar`s file exists, it must be deleted.
                      if(avatarFile.existsSync()){
                        avatarFile.deleteSync();
                      }

                      await DBWorker.db.contacts.delete(inContact.id); // Delete from db
                      Navigator.of(anotherContext).pop(); // Close pop-up

                      Scaffold.of(anotherContext).showSnackBar(
                          SnackBar(
                            content: Text('The contact has been deleted'),
                            backgroundColor: Colors.red,
                            duration: Duration(seconds: 2),
                          )
                      );
                      //Updates the model
                      theContactsModel.loadData('contact', DBWorker.db.contacts);
                    },
                    child: Text('Delete')
                )
              ],
            )
    );
  }

  @override
  Widget build(BuildContext context) =>
      ScopedModel(
          model: theContactsModel,
          child: ScopedModelDescendant<ContactsModel>(
            builder: (BuildContext someContext, Widget someWidget,
                ContactsModel someModel) =>
                Scaffold(
                  floatingActionButton: FloatingActionButton(
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    onPressed: (){
                      File avatarFile = File(join(utils.docsDir.path, "avatar"));

                      if(avatarFile.existsSync()){
                        avatarFile.deleteSync();
                      }

                      someModel.entityBeingEdited = Contact();
                      someModel.chosenDate = null;
                      someModel.stackIndex = 1;
                    },
                  ),
                  body: ListView.builder(
                      itemCount: someModel.entityList.length,
                      itemBuilder: (BuildContext someContext, int someIndex){
                        Contact oneContact = someModel.entityList[someIndex];

                        File avatarFile =
                                File(join(utils.docsDir.path,
                                          oneContact.id.toString()));

                        bool avatarFileExists = avatarFile.existsSync();

                        return Column(children: [
                          Slidable(
                            delegate: SlidableDrawerDelegate(),
                            actionExtentRatio: 0.25,
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.indigoAccent,
                                foregroundColor: Colors.white,
                                backgroundImage: avatarFileExists?
                                    FileImage(avatarFile):
                                    null,
                              ),
                              title: Text('${oneContact.name}'),
                              subtitle: oneContact.phone!=null?
                                  Text('${oneContact.phone}'):null,
                              onTap: ()async{
                                File avatarFile = File(join(utils.docsDir.path,
                                                            'avatar'));

                                if(avatarFile.existsSync()){
                                  avatarFile.deleteSync();
                                }

                                someModel.entityBeingEdited = await
                                    DBWorker.db.contacts.get(oneContact.id);

                                if(someModel.entityBeingEdited.birthday == null){
                                  someModel.chosenDate = null;
                                }
                                else{
                                  List dateParts = someModel.entityBeingEdited
                                                            .birthday
                                                            .split(',');

                                  DateTime birthday = DateTime(int.parse(dateParts[0]),
                                                               int.parse(dateParts[1]),
                                                               int.parse(dateParts[2]));

                                  someModel.chosenDate = DateFormat.yMMMMd('en_US')
                                                                   .format(birthday);
                                }

                                someModel.stackIndex = 1;

                              },
                            ),
                            secondaryActions: [
                              IconSlideAction(
                                caption: 'Delete',
                                color: Colors.red,
                                icon: Icons.delete,
                                onTap: (){
                                  _deleteContact(someContext, oneContact);
                                },
                              )
                            ],
                          ),
                          Divider()
                        ],);
                      }
                  ),
                )
          )
      );
}