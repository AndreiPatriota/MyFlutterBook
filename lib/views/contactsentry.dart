import 'dart:io';

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../db/dbworker.dart';
import '../utils.dart';
import '../models/contactsmodel.dart' show ContactsModel, theContactsModel;
import 'package:flutter_book/db/dbworker.dart' show DBWorker;
import 'package:flutter_book/utils.dart' as utils;
import 'package:path/path.dart';
import 'package:image_picker/image_picker.dart';

class ContactsEntry extends StatelessWidget{

  final TextEditingController _nameEditingController = TextEditingController();
  final TextEditingController _phoneEditingController = TextEditingController();
  final TextEditingController _emailEditingController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  ContactsEntry(){
    _nameEditingController.addListener(() {
      theContactsModel.entityBeingEdited.name = _nameEditingController.text;
    }
    );
    _phoneEditingController.addListener(() {
      theContactsModel.entityBeingEdited.phone = _phoneEditingController.text;
    }
    );
    _emailEditingController.addListener(() {
      theContactsModel.entityBeingEdited.email = _emailEditingController.text;
    }
    );
  }

  void _selectAvatar(BuildContext inContext)=>
      showDialog(
        context: inContext,
        builder: (BuildContext someContext)=>
            AlertDialog(
              content: SingleChildScrollView(
                child: ListBody(
                  children: [
                    GestureDetector(
                      child: Text('Take a picture'),
                      onTap: ()async{
                        var camImage = await ImagePicker.pickImage(
                            source: ImageSource.camera
                        );

                        if(camImage != null){
                          camImage.copySync(
                            join(utils.docsDir.path, 'avatar')
                          );
                          theContactsModel.triggerRebuild();
                        }

                        Navigator.of(inContext).pop();
                      },
                    ),
                    GestureDetector(
                      child: Text('Select from gallery'),
                      onTap: ()async{
                        var galleryImage = await ImagePicker.pickImage(
                            source: ImageSource.gallery);

                        if(galleryImage != null){
                          galleryImage.copySync(join(utils.docsDir.path,
                                                     'avatar'));
                          theContactsModel.triggerRebuild();
                        }

                        Navigator.of(inContext).pop();
                      },
                    )
                  ],
                ),
              ),
            )
      );

  void _save(BuildContext inContext, ContactsModel inModel)async{

    if(!_formKey.currentState.validate()){return;}

    if(inModel.entityBeingEdited.id == null){
      await DBWorker.db.contacts.create(inModel.entityBeingEdited);
    }else{
      await DBWorker.db.contacts.update(inModel.entityBeingEdited);
    }

    File avatarFile = File(join(utils.docsDir.path, 'avatar'));

    if(avatarFile.existsSync()){
      avatarFile.renameSync(join(utils.docsDir.path,
                                 theContactsModel.entityBeingEdited.id.toString()));
    }

    inModel.loadData('contacts',DBWorker.db.contacts);
    inModel.stackIndex = 0;

    Scaffold.of(inContext).showSnackBar(
        SnackBar(
          content: Text('Contact saved'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.green,
        )
    );

  }

  @override
  Widget build(BuildContext context){

    _nameEditingController.text = theContactsModel.entityBeingEdited.name;
    _phoneEditingController.text = theContactsModel.entityBeingEdited.phone;
    _emailEditingController.text = theContactsModel.entityBeingEdited.email;

    return ScopedModel<ContactsModel>(
      model: theContactsModel,
      child: ScopedModelDescendant<ContactsModel>(
        builder: (BuildContext someContext, Widget someWidget,
            ContactsModel someModel){

          File avatarFile = File(join(utils.docsDir.path, 'avatar'));

          if(avatarFile.existsSync() == false){
            if(someModel.entityBeingEdited != null &&
              someModel.entityBeingEdited.id != null){
              avatarFile = File(join(utils.docsDir.path,
                  someModel.entityBeingEdited.id.toString()));
            }
          }


          return Scaffold(
            bottomNavigationBar: Padding(
              padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 10),
              child: Row(
                children: [
                  FlatButton(
                      onPressed: (){
                        //Tries to retrieve a avatar pic. If there is one, delete it.
                        File avatarFile = File(join(utils.docsDir.path, 'avatar'));
                        if(avatarFile.existsSync()){
                          avatarFile.deleteSync();
                        }

                        //Hide virtual keyboard
                        FocusScope.of(someContext).requestFocus(FocusNode());
                        someModel.stackIndex = 0;//Go back to Contacts list
                      },
                      child: Text('Cancel')
                  ),
                  Spacer(),
                  FlatButton(
                      onPressed: (){
                        _save(someContext, theContactsModel);
                      },
                      child: Text('Save')
                  )
                ],
              ),
            ),
            body: Form(
              key: _formKey,
              child: ListView(
                children: [
                  ListTile(
                    title: avatarFile.existsSync()?
                        Image.file(avatarFile):
                        Text('No avatar image for this contact.'),
                    trailing: IconButton(
                      icon: Icon(Icons.edit),
                      color: Colors.blue,
                      onPressed: () => _selectAvatar(someContext),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.contact_page_rounded),
                    title: TextFormField(
                        decoration: InputDecoration(hintText: 'Name'),
                        controller: _nameEditingController,
                        validator: (String someStr)
                        => someStr.length == 0?'Please, enter a Name':null
                    ),
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.phone),
                    title: TextFormField(
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(hintText: 'Phone'),
                        controller: _phoneEditingController,
                    ),
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.email),
                    title: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(hintText: 'Email'),
                      controller: _emailEditingController,
                    ),
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.date_range_outlined),
                    trailing: IconButton(
                      icon: Icon(Icons.edit),
                      color: Colors.blue,
                      onPressed: ()async{
                        var chosenDate = await selectDate(someContext,
                            someModel, someModel.entityBeingEdited.birthday);
                        if(chosenDate != null){
                          someModel.entityBeingEdited.birthday = chosenDate;
                        }
                      },
                    ),
                    title: Text('Date'),
                    subtitle: Text(someModel.chosenDate == null?
                    '':someModel.chosenDate),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

}