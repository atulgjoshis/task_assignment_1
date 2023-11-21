import 'package:flutter/material.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'task_details_screen.dart';
import 'add_task_screen.dart';

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  late List<ParseObject> tasks;

  @override
  void initState() {
    super.initState();
    tasks = []; // Initialize tasks as an empty list
    _fetchTasks();
  }

  Future<void> _fetchTasks() async {
    final QueryBuilder<ParseObject> queryBuilder =
        QueryBuilder<ParseObject>(ParseObject('Task'));

    try {
      final ParseResponse apiResponse = await queryBuilder.query();
      if (apiResponse.success) {
        final List<dynamic>? results = apiResponse.results;

        if (results != null) {
          setState(() {
            tasks = List<ParseObject>.from(results);
          });
        } else {
          print('Warning: Results is null in ParseResponse');
        }
      } else {
        print(apiResponse.error?.message ?? 'Error fetching tasks');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task List'),
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          return ListTile(
            title: Text(task['title'] ?? ''),
            subtitle: Text(task['description'] ?? ''),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TaskDetailsScreen(task: task),
                ),
              ).then((_) {
                _fetchTasks();
              });
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddTaskScreen(),
            ),
          ).then((_) {
            _fetchTasks();
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
