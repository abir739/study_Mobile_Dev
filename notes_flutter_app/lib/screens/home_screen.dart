import 'dart:io';
import 'package:flutter/material.dart';
import 'package:notes_flutter_app/models/database_helper.dart';
import 'package:notes_flutter_app/models/note_model.dart';
import 'package:notes_flutter_app/screens/add_note_screen.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Note> _notes = [];
  String _searchQuery = '';

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
      MaterialPageRoute(builder: (context) => NoteEditor()),
    );
    if (note != null) {
      await _dbHelper.insertNote(note.toMap());
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

  @override
  Widget build(BuildContext context) {
    final filteredNotes = _notes
        .where((note) =>
            note.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            note.content.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('My Notes')),
        elevation: 0,
        backgroundColor: Colors.blueGrey,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: TextField(
              onChanged: _onSearchChanged,
              decoration: const InputDecoration(
                hintText: 'Search notes...',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
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
                  return Dismissible(
                    key: Key(note.id.toString()),
                    background: Container(color: Colors.red),
                    onDismissed: (direction) {
                      _deleteNote(note.id!);
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Note deleted')));
                    },
                    child: Card(
                      color: note.color,
                      margin: const EdgeInsets.all(8.0),
                      elevation: 4,
                      child: GestureDetector(
                        onTap: () {
                          // Navigate to note detail or edit screen
                        },
                        child: ExpansionTile(
                          title: Text(note.title,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(note.content.length > 30
                              ? '${note.content.substring(0, 30)}...'
                              : note.content),
                          children: [
                            if (note.imagePath != null)
                              Image.file(File(note.imagePath!),
                                  height: 100, fit: BoxFit.cover),
                            if (note.tasks.isNotEmpty)
                              Column(
                                children: note.tasks
                                    .map((task) => ListTile(
                                          title: Text(task.description,
                                              style: TextStyle(
                                                decoration: task.isCompleted
                                                    ? TextDecoration.lineThrough
                                                    : TextDecoration.none,
                                              )),
                                          leading: Checkbox(
                                              value: task.isCompleted,
                                              onChanged:
                                                  null), // Disable checkbox
                                        ))
                                    .toList(),
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
                                        'Reminder: ${note.reminder!.toString()}',
                                        style: const TextStyle(fontSize: 14)),
                                  ],
                                ),
                              ),
                          ],
                        ),
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
