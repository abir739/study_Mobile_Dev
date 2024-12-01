import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes_flutter_app/models/database_helper.dart';
import 'package:notes_flutter_app/models/note_model.dart';
import 'package:notes_flutter_app/screens/add_note_screen.dart';
import 'package:notes_flutter_app/screens/note_detail_screen.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Note> _notes = [];
  String _searchQuery = '';

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return DateFormat('EEEE d, MMM, yyyy HH:mm').format(date);
  }

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    final notes = await _dbHelper.queryAllNotes();
    setState(() {
      _notes = notes.map((map) => Note.fromMap(map)).toList();
    });
  }

  Future<void> _addNote() async {
    final note = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NoteEditor()),
    );
    if (note != null) {
      await _dbHelper.insertNote(note.toMap());
      _loadNotes();
    }
  }

  Future<void> _editNote(Note note) async {
    final updatedNote = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NoteEditor(note: note),
      ),
    );

    if (updatedNote != null) {
      await _dbHelper.updateNote(updatedNote.toMap());
      _loadNotes();
    }
  }

  Future<void> _deleteNote(int id) async {
    await _dbHelper.deleteNote(id);
    _loadNotes();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  void _showNoteOptions(Note note) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      barrierColor: Colors.transparent,
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Edit'),
                onTap: () {
                  Navigator.pop(context);
                  _editNote(note);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text('Delete'),
                onTap: () {
                  Navigator.pop(context);
                  _deleteNote(note.id!);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Note deleted')),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.visibility),
                title: const Text('See Details'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NoteDetailScreen(note: note),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _toggleTaskCompletion(Note note, int index) {
    setState(() {
      note.tasks[index].isCompleted = !note.tasks[index].isCompleted;
    });
    _updateNoteInDatabase(note);
  }

  Future<void> _updateNoteInDatabase(Note note) async {
    await _dbHelper.updateNote(note.toMap());
  }

  @override
  Widget build(BuildContext context) {
    final filteredNotes = _notes
        .where((note) =>
            note.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            note.content.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Notes'),
        elevation: 0,
        backgroundColor: Colors.blueGrey,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: TextField(
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Search notes...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: filteredNotes.isEmpty
            ? const Center(child: Text('No notes found'))
            : ListView.builder(
                itemCount: filteredNotes.length,
                itemBuilder: (context, index) {
                  final note = filteredNotes[index];
                  return Card(
                    color: note.color,
                    margin: const EdgeInsets.all(8.0),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(note.title,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18)),
                              ),
                              IconButton(
                                icon: const Icon(Icons.more_vert),
                                onPressed: () => _showNoteOptions(note),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(note.content.length > 30
                              ? '${note.content.substring(0, 30)}...'
                              : note.content),
                          if (note.imagePath != null)
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Image.file(
                                File(note.imagePath!),
                                height: 200,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                          if (note.tasks.isNotEmpty)
                            ExpansionTile(
                              title: const Text('Tasks'),
                              children: note.tasks.asMap().entries.map((e) {
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
                                      onChanged: (_) =>
                                          _toggleTaskCompletion(note, index)),
                                );
                              }).toList(),
                            ),
                          if (note.reminder != null)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  const Icon(Icons.alarm,
                                      color: Colors.orange, size: 20),
                                  const SizedBox(width: 5),
                                  Text(
                                      'Reminder: ${_formatDate(note.reminder)}',
                                      style: const TextStyle(fontSize: 14)),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueGrey,
        onPressed: _addNote,
        child: const Icon(Icons.add),
      ),
    );
  }
}
