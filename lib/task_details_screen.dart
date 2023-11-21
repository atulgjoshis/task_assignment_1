import 'package:flutter/material.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'edit_task_screen.dart';

class TaskDetailsScreen extends StatefulWidget {
  final ParseObject task;

  TaskDetailsScreen({required this.task});

  @override
  _TaskDetailsScreenState createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task['title']);
    _descriptionController = TextEditingController(text: widget.task['description']);
  }

  Future<void> _editTask(BuildContext context) async {
    final updatedTask = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditTaskScreen(task: widget.task),
      ),
    );

    if (updatedTask != null) {
      setState(() {
        widget.task['title'] = updatedTask['title'];
        widget.task['description'] = updatedTask['description'];
        _titleController.text = updatedTask['title'];
        _descriptionController.text = updatedTask['description'];
      });
    }
  }

  Future<void> _deleteTask(BuildContext context) async {
    bool confirmDeletion = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete this task?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmDeletion == true) {
      try {
        await widget.task.delete();
        Navigator.pop(context, true); // Navigate back to the previous screen after deletion
      } catch (e) {
        print('Error deleting task: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Details'),
        backgroundColor: Theme.of(context).primaryColor,
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
              readOnly: true,
            ),
            SizedBox(height: 8.0),
            Text(
              'Description:',
              style: TextStyle(fontSize: 16),
            ),
            TextField(
              controller: _descriptionController,
              readOnly: true,
            ),
          ],
        ),
      ),
      floatingActionButton: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Positioned(
            bottom: 16.0,
            right: 16.0,
            child: FloatingActionButton(
              onPressed: () {
                _editTask(context);
              },
              child: Icon(Icons.edit),
              //backgroundColor: Theme.of(context).accentColor,
            ),
          ),
          Positioned(
            bottom: 80.0,
            right: 16.0,
            child: FloatingActionButton(
              onPressed: () {
                _deleteTask(context);
              },
              child: Icon(Icons.delete),
              backgroundColor: Colors.red, // Customize the color for the delete button
            ),
          ),
        ],
      ),
    );
  }
}
