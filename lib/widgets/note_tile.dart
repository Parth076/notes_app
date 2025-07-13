import 'package:flutter/material.dart';
import 'package:notes_app/model/note.dart';
import 'package:intl/intl.dart'; // <-- Add this import

class NoteTile extends StatelessWidget {
  final Note note;
  const NoteTile({super.key, required this.note});

  String _formatDate(DateTime date) {
    return DateFormat.yMMMd().format(date); // e.g., Jul 13, 2025
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: ListTile(
        leading: const Icon(Icons.note),
        title: Text(
          note.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              note.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
            Text('Created At: ${_formatDate(note.createdAt)}'),
          ],
        ),
      ),
    );
  }
}
