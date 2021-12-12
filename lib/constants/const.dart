import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String editDate =
    '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}';
MaterialColor primarySwatchColor = Colors.purple;
Color scaffoldBgColor = const Color(0xFFf9d7fa);
Color editPenBgColor = Colors.purpleAccent;

bool viewNote = false;
bool editNote = false;
bool addNote = false;

const notesAPI =
    "https://notes-app-c72e2-default-rtdb.asia-southeast1.firebasedatabase.app";

String formatDateTime(DateTime dateTime) {
  return DateFormat('dd/MM/yyyy').format(dateTime);
}
