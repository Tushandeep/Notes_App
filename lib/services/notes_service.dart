import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../constants/const.dart';
import '../models/notes.dart';

class NotesService with ChangeNotifier {
  List<Notes> _notes = [];

  List<Notes> get notes {
    return [..._notes];
  }

  Notes findById(String noteId) {
    return _notes.firstWhere((note) => note.noteId == noteId);
  }

  Future<void> getNotes() async {
    try {
      final response = await http.get(Uri.parse(notesAPI + '/notes.json'));
      List<Notes> _tempNotes = [];
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        if (data == null) {
          return;
        }
        final _notesData = data as Map<String, dynamic>;
        _notesData.forEach(
          (notesId, notesData) {
            _tempNotes.insert(
              0,
              Notes(
                noteId: notesId,
                noteTitle: notesData['noteTitle'],
                noteDescription: notesData['noteDescription'],
                noteLastEditedDateTime: notesData['noteLastEditedDateTime'],
              ),
            );
          },
        );
        _notes = _tempNotes;
        notifyListeners();
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> addNote(Notes note) async {
    try {
      final response = await http.post(
        Uri.parse(notesAPI + '/notes.json'),
        body: json.encode(
          {
            'noteTitle': note.noteTitle,
            'noteDescription': note.noteDescription,
            'noteLastEditedDateTime': note.noteLastEditedDateTime,
          },
        ),
      );
      _notes.insert(
        0,
        Notes(
          noteId: json.decode(response.body)['name'],
          noteTitle: note.noteTitle,
          noteDescription: note.noteDescription,
          noteLastEditedDateTime: note.noteLastEditedDateTime,
        ),
      );
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateNote(String noteId, Notes newNote) async {
    final noteIndex = _notes.indexWhere((note) => note.noteId == noteId);
    if (noteIndex >= 0) {
      try {
        await http.patch(
          Uri.parse(notesAPI + '/notes/$noteId.json'),
          body: json.encode(
            {
              'noteTitle': newNote.noteTitle,
              'noteDescription': newNote.noteDescription,
              'noteLastEditedDateTime': newNote.noteLastEditedDateTime,
            },
          ),
        );
        _notes[noteIndex] = newNote;
        notifyListeners();
      } catch (error) {
        rethrow;
      }
    } else {}
  }

  Future<void> deleteNote(String noteId) async {
    final _noteIndex = _notes.indexWhere((note) => note.noteId == noteId);
    dynamic existingNote = _notes[_noteIndex];
    _notes.removeAt(_noteIndex);
    notifyListeners();

    final response =
        await http.delete(Uri.parse(notesAPI + '/notes/$noteId.json'));
    if (response.statusCode >= 400) {
      _notes.insert(_noteIndex, existingNote);
      notifyListeners();
    }
    existingNote = null;
  }
}
