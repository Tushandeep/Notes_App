import 'package:flutter/foundation.dart';

class Notes with ChangeNotifier {
  final dynamic noteId;
  final String noteTitle;
  final String noteDescription;
  final String noteLastEditedDateTime;

  Notes({
    required this.noteId,
    required this.noteTitle,
    required this.noteDescription,
    required this.noteLastEditedDateTime,
  });
}
