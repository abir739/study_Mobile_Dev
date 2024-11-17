import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:notes_flutter_app/models/category_model.dart';
import 'package:notes_flutter_app/models/task_model.dart';

class Note {
  final int? id;
  final String title;
  final String content;
  final Category category;
  final String? imagePath;
  final Color color;
  final List<Task> tasks;
  final DateTime? reminder;

  Note({
    this.id,
    required this.title,
    required this.content,
    required this.category,
    this.imagePath,
    this.color = Colors.white,
    this.tasks = const [],
    this.reminder,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'category_id': category.id,
      'imagePath': imagePath,
      'color': color.value,
      'tasks': jsonEncode(tasks.map((task) => task.toMap()).toList()),
      'reminder': reminder?.millisecondsSinceEpoch,
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    try {
      return Note(
        id: map['id'],
        title: map['title'] ?? '',
        content: map['content'] ?? '',
        category: Category.fromMap(
            {'id': map['category_id'], 'name': map['category_name']}),
        imagePath: map['imagePath'],
        color: Color(map['color'] ?? Colors.white.value),
        tasks: (jsonDecode(map['tasks'] ?? '[]') as List?)
                ?.map((taskMap) => Task.fromMap(taskMap))
                .toList() ??
            [],
        reminder: map['reminder'] != null
            ? DateTime.fromMillisecondsSinceEpoch(map['reminder'])
            : null,
      );
    } catch (e) {
      print('Error decoding JSON: $e');
      return Note(
        id: map['id'],
        title: map['title'] ?? '',
        content: map['content'] ?? '',
        category: Category.fromMap(
            {'id': map['category_id'], 'name': map['category_name']}),
        imagePath: map['imagePath'],
        color: Color(map['color'] ?? Colors.white.value),
        tasks: [],
        reminder: map['reminder'] != null
            ? DateTime.fromMillisecondsSinceEpoch(map['reminder'])
            : null,
      );
    }
  }
}
