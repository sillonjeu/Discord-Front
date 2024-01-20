import 'package:flutter/material.dart';
import 'package:discord_front/screen/login_screen.dart';
import 'package:discord_front/screen/create_server_page.dart'; // Ensure this import is correct

class HomeScreen extends StatelessWidget {
  final String useremail; // 사용자 정보를 저장할 변수

  const HomeScreen({Key? key, required this.useremail}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: <Widget>[ // Actions moved to AppBar
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              // 서버 생성 페이지로 이동
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => CreateServerPage(useremail: useremail))); // Ensure this route is defined
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Welcome, $useremail'),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              child: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
