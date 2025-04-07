import 'package:flutter/material.dart';
import 'package:my_app/app.dart';
import 'package:my_app/database/database_helper.dart';
import 'package:my_app/repositories/cattle_repository.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cattle App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Cattle Management'),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // สร้าง repository
  final cattleRepository = CattleRepository();

  runApp(
    MaterialApp(
      title: 'Cattle App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Cattle Management'),
    ),
  );
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Text('ยินดีต้อนรับสู่แอปจัดการข้อมูลโค'),
      ),
    );
  }
}