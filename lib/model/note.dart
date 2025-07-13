import 'dart:convert';

class Note {
  const Note({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
  });

  final String id;
  final String title;
  final String description;
  final DateTime createdAt;

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'createdAt': createdAt.toIso8601String(),
  };

  factory Note.fromJson(Map<String, dynamic> json) => Note(
    id: json['id'],
    title: json['title'],
    description: json['description'],
    createdAt: DateTime.parse(json['createdAt']),
  );

  static String encode(List<Note> notes) => json.encode(
    notes.map<Map<String, dynamic>>((note) => note.toJson()).toList(),
  );

  static List<Note> decode(String notesJson) =>
      (json.decode(notesJson) as List<dynamic>)
          .map<Note>((item) => Note.fromJson(item))
          .toList();
}
