import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import 'basemodel.dart';

Directory docsDir;

Future selectDate(
    BuildContext inContext, BaseModel inModel,
    String inDateString
    ) async {

  DateTime initialDate = DateTime.now();

  if(inDateString != null) {
    List dateParts = inDateString.split(',');
    initialDate = DateTime(int.parse(dateParts[0]),
                           int.parse(dateParts[1]),
                           int.parse(dateParts[2])
    );
  }

  DateTime picked = await showDatePicker(
      context: inContext,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100)
  );

  if(picked != null) {
    inModel.chosenDate = DateFormat.yMMMMd('en_US').format(picked.toLocal());
    return "${picked.year},${picked.month},${picked.day}";
  }


}