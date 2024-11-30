import 'dart:io';
import 'package:flutter/material.dart';
import 'package:notes_flutter_app/models/note_model.dart';

class NoteDetailScreen extends StatelessWidget {
  final Note note;

  const NoteDetailScreen({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(note.title),
        backgroundColor: Colors.blueGrey,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              note.content,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            if (note.imagePath != null)
              Image.file(
                File(note.imagePath!),
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            const SizedBox(height: 16),
            if (note.tasks.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tasks:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ...note.tasks.map((task) => ListTile(
                        title: Text(task.description,
                            style: TextStyle(
                              decoration: task.isCompleted
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            )),
                        leading: Checkbox(
                            value: task.isCompleted,
                            onChanged: null),
                      )),
                ],
              ),
            const SizedBox(height: 16),
            if (note.reminder != null)
              Row(
                children: [
                  const Icon(Icons.alarm, color: Colors.orange, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Reminder: ${note.reminder!.toString()}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
