import 'package:flutter/material.dart';
import 'package:discord_front/screen/login_screen.dart';
import 'package:discord_front/auth/auth_provider.dart';
import 'package:discord_front/auth/token_manager.dart';
import 'package:provider/provider.dart'; // Provider 패키지 추가

class HomeScreen extends StatelessWidget {
  final String useremail;

  const HomeScreen({Key? key, required this.useremail}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // AuthProvider에서 accessToken 가져오기
    final accessToken = Provider.of<AuthProvider>(context).accessToken;

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Welcome, $useremail'),
            if (accessToken != null) Text('Your access token: $accessToken'),
            ElevatedButton(
              onPressed: () async {
                await TokenManager.clearTokens();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                      (Route<dynamic> route) => false,
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

