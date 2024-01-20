import 'package:flutter/material.dart';
import 'package:discord_front/screen/login_screen.dart';
import 'package:provider/provider.dart';
import 'config/server_list.dart';
//import 'package:discord_front/screen/home_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ServerList()),
        // Other providers if any
      ],
      child: MyApp(), // Your main app widget
    ),
  );
}

class MyApp extends StatelessWidget{
  final bool isLoggedIn = false;

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Discord_Front',
      home: LoginScreen(),
    );
  }
}


//TODO: 포커스 - 텍스트 입력하고 빈화면 터치시 키패드 unfocus하는 기능