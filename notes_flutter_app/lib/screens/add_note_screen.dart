import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notes_flutter_app/models/category_model.dart';
import 'package:notes_flutter_app/models/database_helper.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:notes_flutter_app/models/note_model.dart';
import 'package:notes_flutter_app/models/task_model.dart';

class NoteEditor extends StatefulWidget {
  final Note? note;

  const NoteEditor({super.key, this.note});

  @override
  State<NoteEditor> createState() => _NoteEditorState();
}

class _NoteEditorState extends State<NoteEditor> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _categoryController = TextEditingController();
  final _taskController = TextEditingController();
  String? _imagePath;
  List<Category> _categories = [];
  Category? _selectedCategory;
  Color _selectedColor = Colors.white;
  List<Task> _tasks = [];
  DateTime? _reminder;

  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _loadCategories();
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
      _imagePath = widget.note!.imagePath;
      _selectedColor = widget.note!.color;
      _tasks = widget.note!.tasks;
      _reminder = widget.note!.reminder;
    }
  }

  Future<void> _loadCategories() async {
    final categories = await _dbHelper.queryAllCategories();
    setState(() {
      _categories = categories.map((map) => Category.fromMap(map)).toList();
      if (widget.note != null) {
        _selectedCategory = _categories.firstWhere(
          (category) => category.id == widget.note!.category.id,
          orElse: () => Category(name: ''),
        );
      }
    });
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
      });
    }
  }

  Future<void> _addCategory() async {
    final name = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Category'),
        content: TextField(
          controller: _categoryController,
          decoration: const InputDecoration(labelText: 'Category Name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, _categoryController.text),
            child: const Text('Add'),
          ),
        ],
      ),
    );
    if (name != null && name.isNotEmpty) {
      await _dbHelper.insertCategory({'name': name});
      _loadCategories();
    }
  }

  void _pickColor() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pick a color'),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: _selectedColor,
            onColorChanged: (color) {
              setState(() {
                _selectedColor = color;
              });
            },
            pickerAreaHeightPercent: 0.8,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  void _addTask() {
    if (_taskController.text.isNotEmpty) {
      setState(() {
        _tasks.add(Task(description: _taskController.text));
        _taskController.clear();
      });
    }
  }

  void _toggleTaskCompletion(int index) {
    setState(() {
      _tasks[index].isCompleted = !_tasks[index].isCompleted;
    });
  }

  void _removeTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
  }

  void _pickReminder() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _reminder ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_reminder ?? DateTime.now()),
      );

      if (pickedTime != null) {
        setState(() {
          _reminder = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blueGrey,
        title:
            Center(child: Text(widget.note == null ? 'Add Note' : 'Edit Note')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Title Field
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: _buildTextField(
                          _titleController, 'Title', 'Please enter a title'),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: _buildTextField(_contentController, 'Content',
                          'Please enter some content'),
                    ),
                    // Task Input & List
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: _buildTaskInput(),
                    ),
                    // Category Tags
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: _buildCategorySelection(),
                    ),

                    // Add Image, Pick Color, and Set Reminder in a Row
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: _buildActionButtonsRow(),
                    ),
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: _buildSaveButton(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, String errorText) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
        ),
        validator: (value) => value == null || value.isEmpty ? errorText : null,
      ),
    );
  }

  Widget _buildCategorySelection() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Display selected category
          if (_selectedCategory != null && _selectedCategory!.name.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Chip(
                label: Text('#${_selectedCategory!.name}'),
                backgroundColor: Colors.blue.shade100,
              ),
            ),

          // Category selection: display list of categories and create new category
          Wrap(
            direction: Axis.horizontal,
            spacing: 8.0,
            runSpacing: 4.0,
            children: _categories.map((category) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedCategory = category;
                  });
                },
                child: Chip(
                  label: Text('#${category.name}'),
                  backgroundColor: _selectedCategory == category
                      ? Colors.blue
                      : Colors.grey.shade300,
                ),
              );
            }).toList()
              ..add(
                GestureDetector(
                  onTap: _addCategory,
                  child: const Icon(
                    Icons.add_circle_outline,
                    size: 30,
                    color: Colors.blue,
                  ),
                ),
              ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtonsRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.image),
            onPressed: _pickImage,
            tooltip: 'Add Image',
            color: Colors.blue,
          ),
          IconButton(
            icon: const Icon(Icons.color_lens),
            onPressed: _pickColor,
            tooltip: 'Pick Color',
            color: Colors.blue,
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: _pickReminder,
            tooltip: 'Set Reminder',
            color: Colors.blue,
          ),
        ],
      ),
    );
  }

  Widget _buildTaskInput() {
    return Column(
      children: [
        TextFormField(
          controller: _taskController,
          decoration: const InputDecoration(
            labelText: 'Add Task',
            border: OutlineInputBorder(),
          ),
          onFieldSubmitted: (_) => _addTask(),
        ),
        ListView.builder(
          shrinkWrap: true,
          itemCount: _tasks.length,
          itemBuilder: (context, index) {
            final task = _tasks[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 4.0),
              child: ListTile(
                title: Text(
                  task.description,
                  style: TextStyle(
                    decoration: task.isCompleted
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
                leading: Checkbox(
                  value: task.isCompleted,
                  onChanged: (_) => _toggleTaskCompletion(index),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _removeTask(index),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            final note = Note(
              id: widget.note?.id,
              title: _titleController.text,
              content: _contentController.text,
              category: _selectedCategory!,
              imagePath: _imagePath,
              color: _selectedColor,
              tasks: _tasks,
              reminder: _reminder,
            );
            Navigator.pop(context, note);
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueGrey,
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        ),
        child: const Text(
          'Save',
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
    );
  }
}
