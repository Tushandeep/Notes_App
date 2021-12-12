import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../widgets/note_delete.dart';
import '../constants/const.dart';
import '../models/notes.dart';
import '../services/notes_service.dart';

class NotesModify extends StatefulWidget {
  static const String routeName = '/notes-modify';
  const NotesModify({
    Key? key,
  }) : super(key: key);

  @override
  _NotesModifyState createState() => _NotesModifyState();
}

class _NotesModifyState extends State<NotesModify> {
  Text appBarTitle() {
    if (editNote == true) {
      return const Text('Edit Note');
    } else if (viewNote == true) {
      return const Text('Note View');
    }
    return const Text('Create a note...');
  }

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  late String errorMessage;

  bool _isLoading = false;
  late Notes note;

  bool _isInit = true;

  Notes existingNote = Notes(
    noteId: null,
    noteDescription: '',
    noteTitle: '',
    noteLastEditedDateTime:
        DateFormat('dd/MM/yyyy ,  hh:mm a').format(DateTime.now()),
  );

  dynamic _noteId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      _noteId = ModalRoute.of(context)!.settings.arguments as dynamic;
      if (_noteId != null) {
        final noteID = _noteId as String;
        existingNote = Provider.of<NotesService>(context).findById(noteID);
        if (viewNote || editNote) {
          _titleController.text = existingNote.noteTitle;
          _descriptionController.text = existingNote.noteDescription;
        }
      }
    }
    _isInit = false;
  }

  Future<void> _saveNote() async {
    setState(() {
      _isLoading = true;
    });
    Notes note = Notes(
      noteId: existingNote.noteId,
      noteTitle: _titleController.text.trim(),
      noteDescription: _descriptionController.text.trim(),
      noteLastEditedDateTime: existingNote.noteLastEditedDateTime,
    );
    existingNote = note;
    if (addNote) {
      // Add Note
      try {
        await Provider.of<NotesService>(context, listen: false)
            .addNote(existingNote);
      } catch (error) {
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => AlertDialog(
            title: const Text('Error'),
            content: const Text('Error in creating note...'),
            actions: [
              ElevatedButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      }
    }
    if (editNote) {
      try {
        await Provider.of<NotesService>(context, listen: false)
            .updateNote(existingNote.noteId, existingNote);
      } catch (error) {
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => AlertDialog(
            title: const Text('Error'),
            content: const Text('Error in updating note'),
            actions: [
              ElevatedButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      }
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  OutlineInputBorder get decorateBorder {
    return OutlineInputBorder(
      borderSide: BorderSide(
        color: editPenBgColor,
        width: 1.5,
      ),
      borderRadius: BorderRadius.circular(10),
    );
  }

  @override
  Widget build(BuildContext context) {
    final notesData = Provider.of<NotesService>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: appBarTitle(),
        actions: [
          if (viewNote)
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              onPressed: () {
                setState(() {
                  viewNote = false;
                  editNote = true;
                  addNote = false;
                });
              },
            ),
          if (editNote || viewNote)
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: IconButton(
                onPressed: () async {
                  showDialog<bool>(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => const NoteDelete(),
                  ).then((val) {
                    if (val!) {
                      notesData.deleteNote(_noteId);
                      Navigator.of(context).pop();
                    } else {}
                  });
                },
                icon: const Icon(Icons.delete_outline_outlined),
              ),
            ),
        ],
      ),
      body: Builder(
        builder: (_) {
          if (_isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 10,
            ),
            child: Column(
              children: <Widget>[
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    enabled: (viewNote) ? false : true,
                    labelText: 'Note Title',
                    hintText: 'Note Title',
                    hintStyle: TextStyle(color: primarySwatchColor),
                    labelStyle: TextStyle(color: primarySwatchColor),
                    focusedBorder: decorateBorder,
                    enabledBorder: decorateBorder,
                    disabledBorder: decorateBorder,
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: TextField(
                    controller: _descriptionController,
                    expands: true,
                    textAlignVertical: TextAlignVertical.top,
                    maxLines: null,
                    minLines: null,
                    decoration: InputDecoration(
                      enabled: (viewNote) ? false : true,
                      labelText: 'Note Description',
                      hintText: 'Note Description',
                      hintStyle: TextStyle(color: primarySwatchColor),
                      labelStyle: TextStyle(color: primarySwatchColor),
                      focusedBorder: decorateBorder,
                      enabledBorder: decorateBorder,
                      disabledBorder: decorateBorder,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                SizedBox(
                  height: (viewNote) ? 0 : 35,
                  width: double.infinity,
                  child: (viewNote)
                      ? const Center()
                      : ElevatedButton(
                          child: (addNote == true)
                              ? const Text('Add Note')
                              : const Text('Update'),
                          onPressed: _saveNote,
                        ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          );
        },
      ),
    );
  }
}
