import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screen/login_screen.dart';
import 'config/server_list.dart';
import 'auth/token_provider.dart';

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
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: double.infinity, // 컨테이너의 너비를 화면 너비와 맞춥니다.
          height: MediaQuery
              .of(context)
              .size
              .height, // 컨테이너의 높이를 화면 높이와 맞춥니다.
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('asset/img/splash_screen.png'), // 스플래시 이미지 경로
              fit: BoxFit.cover, // 이미지를 컨테이너에 꽉 차게 조정합니다.
            ),
          ),
        ),
      ),
    );
  }
}