import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/const.dart';
import '../screens/notes_modify.dart';
import '../services/notes_service.dart';
import '../widgets/note_item.dart';

class NoteList extends StatefulWidget {
  static const String routeName = '/notes-list';
  const NoteList({Key? key}) : super(key: key);

  @override
  State<NoteList> createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  // NotesService get service => GetIt.I<NotesService>();

  bool isLoading = false;

  late Future _notesFuture;

  Future<void> _fetchData() async {
    return await Provider.of<NotesService>(context, listen: false).getNotes();
  }

  @override
  void initState() {
    super.initState();
    _notesFuture = _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBgColor,
      appBar: AppBar(
        title: const Text(
          'Notes',
          style: TextStyle(
            fontSize: 40,
          ),
        ),
        toolbarHeight: 100,
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'New Note',
        onPressed: () {
          setState(() {
            viewNote = editNote = false;
            addNote = true;
          });
          Navigator.of(context).pushNamed(
            NotesModify.routeName,
            arguments: null,
          );
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: FutureBuilder(
        future: _notesFuture,
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Consumer<NotesService>(
            builder: (_, notesData, __) {
              if (notesData.notes.isEmpty) {
                return Center(
                  child: GestureDetector(
                    onTap: () {
                      setState(
                        () {
                          viewNote = editNote = false;
                          addNote = true;
                        },
                      );
                      Navigator.of(context).pushNamed(
                        NotesModify.routeName,
                        arguments: null,
                      );
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const <Widget>[
                        Icon(
                          Icons.add_circle_outline_rounded,
                          size: 100,
                        ),
                        Text(
                          'Add a note',
                          style: TextStyle(
                            fontSize: 30,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return ListView.separated(
                itemBuilder: (_, index) {
                  return NoteItem(note: notesData.notes[index]);
                },
                separatorBuilder: (_, __) {
                  return Divider(height: 1, color: editPenBgColor);
                },
                itemCount: notesData.notes.length,
              );
            },
          );
        },
      ),
    );
  }
}
