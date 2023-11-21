import 'package:flutter/material.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

class EditTaskScreen extends StatefulWidget {
  final ParseObject task;

  EditTaskScreen({required this.task});

  @override
  _EditTaskScreenState createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task['title']);
    _descriptionController = TextEditingController(text: widget.task['description']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Task'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              _saveChanges(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Title:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _titleController,
              onChanged: (value) {
                // Update the title as the user types
                widget.task['title'] = value;
              },
            ),
            SizedBox(height: 8.0),
            Text(
              'Description:',
              style: TextStyle(fontSize: 16),
            ),
            TextField(
              controller: _descriptionController,
              onChanged: (value) {
                // Update the description as the user types
                widget.task['description'] = value;
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveChanges(BuildContext context) async {
    // Save the updated task to Back4App
    try {
      await widget.task.save();
      // Navigate back to the task details screen and pass the updated task
      Navigator.pop(context, widget.task);
    } catch (e) {
      print('Error saving task changes: $e');
      // Show an error message or handle the error as needed
    }
  }
}
