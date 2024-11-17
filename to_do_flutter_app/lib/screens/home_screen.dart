import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:to_do_flutter_app/models/task.dart';
import 'package:to_do_flutter_app/screens/toDoList_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _taskNameController = TextEditingController();
  final Box<Task> _taskBox = Hive.box<Task>('tasks');

  // List<List<dynamic>> todoList = [
  //   ["task 1", false],
  //   ["task 2", false],
  // ];
  List<Task> todoList = [];

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  void loadTasks() {
    setState(() {
      todoList = _taskBox.values.toList();
    });
  }

  void checkBox(bool? value, int index) {
    setState(() {
      todoList[index].isCompleted = !todoList[index].isCompleted;
      _taskBox.putAt(index, todoList[index]); // Update in Hive
    });
  }

  void saveTask() {
    if (_taskNameController.text.isNotEmpty) {
      final newTask = Task(name: _taskNameController.text);
      setState(() {
        todoList.add(newTask);
        _taskBox.add(newTask); // Add to Hive
      });
      _taskNameController.clear(); // Clear the input field
      Navigator.of(context).pop(); // Close the dialog
    }
  }

  void cancelTask() {
    _taskNameController.clear(); // Clear the input field
    Navigator.of(context).pop(); // Close the dialog
  }

  void addNewTask() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.purple[200],
          content: SizedBox(
            height: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextField(
                  controller: _taskNameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Add a new task",
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 70.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: saveTask,
                        child: const Text("Save"),
                      ),
                      ElevatedButton(
                        onPressed: cancelTask,
                        child: const Text("Cancel"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void deleteTask(int index) {
    setState(() {
      todoList.removeAt(index);
      _taskBox.deleteAt(index); // Remove from Hive
    });
  }

  @override
  void dispose() {
    _taskNameController.dispose(); // Dispose of the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[200],
      appBar: AppBar(
        title: const Center(
          child: Text('T O D O'),
        ),
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addNewTask,
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: todoList.length,
        itemBuilder: (context, index) {
          return TodolistScreen(
            taskName: todoList[index].name,
            isCompleted: todoList[index].isCompleted,
            onChanged: (value) => checkBox(value, index),
            onDelete: (context) => deleteTask(index),
          );
        },
      ),
    );
  }
}
