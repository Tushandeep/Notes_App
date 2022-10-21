import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './services/notes_service.dart';
import './constants/const.dart';
import './screens/notes_list.dart';
import './screens/notes_modify.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => NotesService(),
        ),
      ],
      child: MaterialApp(
        routes: {
          NotesModify.routeName: (_) => const NotesModify(),
          NoteList.routeName: (_) => const NoteList(),
        },
        home: const NoteList(),
        theme: ThemeData(
          primarySwatch: primarySwatchColor,
        ),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
