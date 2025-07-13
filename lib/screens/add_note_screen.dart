import 'package:flutter/material.dart';
import 'package:notes_app/data/categories.dart';
import 'package:notes_app/model/category.dart';
import 'package:notes_app/model/note.dart';

class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({super.key});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final _formKey = GlobalKey<FormState>();
  Category _selectedCategory = categories[Categories.study]!;

  String _title = '';
  String _description = '';
  bool _isFormValid = false;

  void _checkFormValid() {
    setState(() {
      _isFormValid =
          _title.trim().length >= 5 &&
          _title.trim().length <= 100 &&
          _description.trim().length >= 10;
    });
  }

  void saveItem() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final newNote = Note(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _title,
        description: _description,
        createdAt: DateTime.now(),
      );
      Navigator.of(context).pop(newNote);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Note'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: "Title",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onChanged: (value) {
                        _title = value;
                        _checkFormValid();
                      },
                      onSaved: (value) => _title = value!,
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.trim().length < 5 ||
                            value.trim().length > 100) {
                          return 'Must be between 5 and 100 characters';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<Category>(
                      value: _selectedCategory,
                      decoration: InputDecoration(
                        labelText: 'Category',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      items: categories.entries.map((entry) {
                        return DropdownMenuItem<Category>(
                          value: entry.value,
                          child: Row(
                            children: [
                              Icon(entry.value.icon, size: 20),
                              const SizedBox(width: 8),
                              Text(entry.value.title),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                maxLines: 6,
                decoration: InputDecoration(
                  labelText: "Description",
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onChanged: (value) {
                  _description = value;
                  _checkFormValid();
                },
                onSaved: (value) => _description = value!,
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length < 10) {
                    return 'Must be at least 10 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isFormValid ? saveItem : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
