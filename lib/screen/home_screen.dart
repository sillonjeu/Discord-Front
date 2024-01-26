import 'package:flutter/material.dart';
import 'package:discord_front/screen/login_screen.dart';
import 'package:discord_front/screen/create_server_page.dart'; // Ensure this import is correct
import 'package:discord_front/auth/token_provider.dart';
import 'package:discord_front/auth/token_manager.dart';
import 'package:provider/provider.dart'; // Provider 패키지 추가

class HomeScreen extends StatefulWidget {
  final String useremail;
  const HomeScreen({Key? key, required this.useremail}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    // AuthProvider에서 accessToken 가져오기
    final accessToken = Provider.of<AuthProvider>(context).accessToken;
    // await Provider.of<AuthProvider>(context, listen: false).refreshAccessToken();
    // 새로운 accessToken으로 API 요청 재시도

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: <Widget>[ // Actions moved to AppBar
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              // 서버 생성 페이지로 이동
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => CreateServerPage(useremail: widget.useremail))); // Ensure this route is defined
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Welcome, ${widget.useremail}'),
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
            ElevatedButton(
              onPressed: () async {
                // 여기서 refreshAccessToken을 호출합니다.
                await Provider.of<AuthProvider>(context, listen: false)
                    .refreshAccessToken();
              },
              child: Text('Refresh Access Token'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  print("refreshed stored accessToken is ..."); // 버튼 클릭 시 카운터 증가
                  print(Provider.of<AuthProvider>(context, listen: false).accessToken);
                });
              }, // 버튼 클릭 시 refreshPage 호출
              child: Text('Refresh Page'),
            ),
          ],
        ),
      ),
    );
  }
}
