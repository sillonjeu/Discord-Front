import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'create_server_page.dart';
import 'server_list.dart'; // ServerList 모델을 가져옵니다.

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ServerList(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Discord Server Creation Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: CreateServerPage(),
    );
  }
}
