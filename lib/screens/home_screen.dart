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
  List<Note> _filteredNotes = [];
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

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
        _filteredNotes = _notes;
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
        _filteredNotes = _notes;
      });
      _saveNotes();
    }
  }

  void _searchNote(String query) {
    final suggestions = _notes.where((note) {
      final noteTitle = note.title.toLowerCase();
      final input = query.toLowerCase();
      return noteTitle.contains(input);
    }).toList();

    setState(() {
      _filteredNotes = suggestions;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Center(child: Text('No notes found'));
    if (_filteredNotes.isNotEmpty) {
      content = ListView.builder(
        itemCount: _filteredNotes.length,
        itemBuilder: (context, index) {
          final addedNotes = _filteredNotes[index];
          return NoteTile(note: addedNotes);
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                onChanged: _searchNote,
                decoration: InputDecoration(
                  hintText: 'Search notes...',
                  border: InputBorder.none,
                ),
              )
            : Text('Your Notes'),
        centerTitle: true,
        backgroundColor: Colors.lightBlueAccent,
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                if (_isSearching) {
                  _searchController.clear();
                  _filteredNotes = _notes;
                }
                _isSearching = !_isSearching;
              });
            },
          ),
        ],
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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
