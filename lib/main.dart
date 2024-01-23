import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:discord_front/screen/login_screen.dart';
import 'package:provider/provider.dart';
import 'config/server_list.dart';
//import 'package:discord_front/screen/home_screen.dart';
import 'package:discord_front/auth/auth_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ServerList()),
        ChangeNotifierProvider(create: (context) => AuthProvider()),
      ],
      child: MyApp(),
    ),
  );
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Discord_Front',
      home: LoginScreen(),
    );
  }
}
