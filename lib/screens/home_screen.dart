import 'package:flutter/material.dart';
import 'package:notes_app/model/note.dart';
import 'package:notes_app/screens/add_note_screen.dart';
import 'package:notes_app/widgets/note_tile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Note> _notes = [];

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final String? notesJson = prefs.getString('notes');
    if (notesJson != null) {
      setState(() {
        _notes = Note.decode(notesJson);
      });
    }
  }

  Future<void> _saveNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData = Note.encode(_notes);
    await prefs.setString('notes', encodedData);
  }

  void _addItem() async {
    final newItem = await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (ctx) => AddNoteScreen()));

    if (newItem != null && newItem is Note) {
      setState(() {
        _notes.add(newItem);
      });
      _saveNotes();
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Center(child: Text('No items added yet'));
    if (_notes.isNotEmpty) {
      content = ListView.builder(
        itemCount: _notes.length,
        itemBuilder: (context, index) {
          final addedNotes = _notes[index];
          return NoteTile(note: addedNotes);
        },
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Notes'),
        centerTitle: true,
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: content,
      floatingActionButton: Padding(
        padding: EdgeInsets.all(8),
        child: FloatingActionButton(
          onPressed: _addItem,
          shape: CircleBorder(),
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
