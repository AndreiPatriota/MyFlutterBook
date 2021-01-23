import "dart:io";
import "package:path_provider/path_provider.dart";
import 'package:flutter/material.dart';
import 'views/appointments.dart';
import 'views/contacts.dart';
import 'views/notes.dart';
import 'views/tasks.dart';
import "utils.dart" as utils;

void main(){
  startMeUp() async{
    Directory doscDir = await getApplicationDocumentsDirectory();
    utils.docsDir = doscDir;

    runApp(MaterialApp(
      title: 'FlutterBook',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: FlutterBook(),
    )
    );
  }
  WidgetsFlutterBinding.ensureInitialized();
  startMeUp();
}

class FlutterBook extends StatelessWidget {

  final _listOfTabs = <Widget>[
    Tab(
      icon: Icon(Icons.date_range),
      text: 'Appointments',
    ),
    Tab(
      icon: Icon(Icons.contacts),
      text: 'Contacts',
    ),
    Tab(
      icon: Icon(Icons.note),
      text: 'Notes',
    ),
    Tab(
      icon: Icon(Icons.assignment_turned_in),
      text: 'Tasks',
    )
  ];

  @override
  Widget build(BuildContext context) =>
      DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            title: Text('FlutterBook'),
            bottom: TabBar(
              tabs: _listOfTabs,
            ),
          ),
          body: TabBarView(
            children: [
              Appointments(),
              Contacts(),
              Notes(),
              Tasks(),
            ],
          ),
        ),
      );
}

