import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes_flutter_app/models/database_helper.dart';
import 'package:notes_flutter_app/models/note_model.dart';

class NoteDetailScreen extends StatefulWidget {
  final Note note;

  const NoteDetailScreen({super.key, required this.note});

  @override
  State<NoteDetailScreen> createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends State<NoteDetailScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  late Note _note;

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return DateFormat('EEEE d, MMM, yyyy HH:mm').format(date);
  }

  @override
  void initState() {
    super.initState;
    _note = widget.note;
  }

  void _toggleTaskCompletion(int index) {
    setState(
      () {
        _note.tasks[index].isCompleted = !_note.tasks[index].isCompleted;
      },
    );
    _updateNoteInDatabase();
  }

  Future<void> _updateNoteInDatabase() async {
    await _dbHelper.updateNote(_note.toMap());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(widget.note.title)),
        backgroundColor: Colors.blueGrey,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 18,
            ),
            const Text(
              'Description:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              widget.note.content,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            if (widget.note.imagePath != null)
              Image.file(
                File(widget.note.imagePath!),
                height: 300,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            const SizedBox(height: 16),
            if (widget.note.tasks.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tasks:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ...widget.note.tasks.asMap().entries.map((e) {
                    int index = e.key;
                    var task = e.value;
                    return ListTile(
                      title: Text(task.description,
                          style: TextStyle(
                            decoration: task.isCompleted
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                          )),
                      leading: Checkbox(
                        value: task.isCompleted,
                        onChanged: (_) => _toggleTaskCompletion(index),
                      ),
                    );
                  }),
                ],
              ),
            const SizedBox(height: 16),
            if (widget.note.reminder != null)
              Row(
                children: [
                  const Icon(Icons.alarm, color: Colors.orange, size: 25),
                  const SizedBox(width: 8),
                  const Text(
                    'Reminder:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    ' ${_formatDate(widget.note.reminder)}',
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
