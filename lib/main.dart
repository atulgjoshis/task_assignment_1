import 'package:flutter/material.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'task_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Parse().initialize(
    'qFRwAZ4KnCZ059EV42A8EMxfANSDPCFz2VXMoCZr',
    'https://parseapi.back4app.com/',
    clientKey: 'Q9E1uqXBV4L8l0nEEziIzsSTW7SukKuBnwy1S87N',
    autoSendSessionId: true,
    debug: true,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Back4App ToDo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        //accentColor: Colors.orange, // You can change the accent color
        scaffoldBackgroundColor: Colors.lightBlue[50], // Change background color
      ),
      home: TaskListScreen(),
    );
  }
}
