import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/notes_service.dart';
import '../constants/const.dart';
import '../models/notes.dart';
import '../screens/notes_modify.dart';
import '../widgets/note_delete.dart';

class NoteItem extends StatefulWidget {
  final Notes note;
  const NoteItem({Key? key, required this.note}) : super(key: key);

  @override
  State<NoteItem> createState() => _NoteItemState();
}

class _NoteItemState extends State<NoteItem> {
  @override
  Widget build(BuildContext context) {
    final noteData = Provider.of<NotesService>(context, listen: false);
    return Dismissible(
      key: ValueKey(widget.note.noteId),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        noteData.deleteNote(widget.note.noteId);
      },
      confirmDismiss: (direction) async {
        final res = await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const NoteDelete(),
        );
        return res;
      },
      background: Container(
        color: Colors.red,
        padding: const EdgeInsets.only(left: 16),
        child: const Align(
          child: Icon(Icons.delete_outline_outlined),
          alignment: Alignment.centerLeft,
        ),
      ),
      child: ListTile(
        onTap: () {
          setState(() {
            viewNote = true;
            editNote = false;
            addNote = false;
          });
          Navigator.of(context).pushNamed(
            NotesModify.routeName,
            arguments: widget.note.noteId,
          );
        },
        title: Text(
          (widget.note.noteTitle.length > 20)
              ? widget.note.noteTitle.substring(0, 20) + '. . .'
              : widget.note.noteTitle,
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: (widget.note.noteDescription.length > 30)
            ? Text(widget.note.noteDescription.substring(0, 30) + '. . .')
            : Text(widget.note.noteDescription),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text(
              widget.note.noteLastEditedDateTime,
              style: TextStyle(
                color: editPenBgColor,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 3,
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  editNote = true;
                  viewNote = false;
                  addNote = false;
                });
                Navigator.of(context).pushNamed(
                  NotesModify.routeName,
                  arguments: widget.note.noteId,
                );
              },
              child: Container(
                height: 41,
                width: 41,
                decoration: BoxDecoration(
                  color: editPenBgColor.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.edit_rounded,
                  size: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
