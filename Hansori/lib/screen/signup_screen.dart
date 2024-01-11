import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:hansori/screen/emailverify_screen.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  Future<void> _registerAccount() async {
    final String username = _usernameController.text;
    final String password = _passwordController.text;
    final String email = _emailController.text;

    // final response = await http.post(
    //   Uri.parse('http://your-backend-url.com/signup'), // 백엔드 URL 수정 필요
    //   headers: <String, String>{
    //     'Content-Type': 'application/json',
    //   },
    //   body: jsonEncode(<String, String>{
    //     'username': username,
    //     'password': password,
    //     'email': email,
    //   }),
    // );

    //백 형님들 api 구현전 테스트용 코드
    final response = http.Response(
      jsonEncode({'result':true}),
      200,
      headers:{
        'Content-Type':'application/json',
      },
    );


    if (response.statusCode == 200) {
      final responseJson = jsonDecode(response.body);
      if (responseJson['result']) {
        // 회원가입 성공, 이메일 인증 화면으로 이동
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => EmailVerificationScreen(useremail: email)),
        );
      } else {
        // 이미 등록된 사용자
        _showDialog('User already exists');
      }
    } else {
      // 서버 에러 또는 기타 오류
      _showDialog('Error: ${response.statusCode}');
    }
  }

  void _showDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Signup Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Signup'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(// TODO: 이메일 형태체크하는 코드
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _registerAccount,
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}
