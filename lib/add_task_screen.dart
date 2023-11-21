import 'package:flutter/material.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

class AddTaskScreen extends StatefulWidget {
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                if (_titleController.text.isNotEmpty) {
                  final ParseObject newTask = ParseObject('Task')
                    ..set('title', _titleController.text);

                  if (_descriptionController.text.isNotEmpty) {
                    newTask.set('description', _descriptionController.text);
                  }

                  try {
                    final ParseResponse apiResponse = await newTask.save();
                    if (apiResponse.success) {
                      Navigator.pop(context); // Close the AddTaskScreen
                    } else {
                      print(apiResponse.error?.message ?? 'Error creating task');
                    }
                  } catch (e) {
                    print('Error: $e');
                  }
                } else {
                  print('Title cannot be empty');
                }
              },
              child: Text('Save Task'),
            ),
          ],
        ),
      ),
    );
  }
}
