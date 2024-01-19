import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:discord_front/screen/emailverify_screen.dart';
import 'package:discord_front/config/palette.dart';

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
      backgroundColor: Colors.transparent, // 배경색을 투명하게 설정
      body: GestureDetector(
        onTap: () {
          // 다른 화면을 터치했을 때 키보드 닫기
          FocusScope.of(context).unfocus();
        },
        child: Stack(
          children: <Widget>[
            // 배경 이미지
            Image.asset(
              'asset/img/discord_signup_background.png',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: InkWell(
                  onTap: () {
                    // 뒤로 가기 버튼 동작
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: EdgeInsets.all(6.0),
                    decoration: BoxDecoration(
                      color: Palette.blackColor1, // 파란색 배경
                      shape: BoxShape.circle, // 원형 모양
                    ),
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.white, // 아이콘 색상
                    ),
                  ),
                ),
              ),
            ),

            Center(
              child: Container(

                margin: EdgeInsets.symmetric(vertical: 100.0, horizontal: 40.0),
                padding: EdgeInsets.only(top: 32.0, bottom: 32.0, left: 16.0, right: 16.0),
                decoration: BoxDecoration(
                  color: Palette.blackColor1, // 투명도 조절 가능
                  borderRadius: BorderRadius.circular(20.0), // 모서리 둥글게
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'fill the form', // 환영 메시지
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 32.0),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Username', // Email 텍스트
                          style: TextStyle(
                            color: Colors.white, // 텍스트 색상
                            fontSize: 16.0, // 텍스트 크기
                          ),
                        ),
                      ),
                      SizedBox(height: 8.0), // 간격 조절
                      TextFormField(
                        controller: _usernameController,
                        style: TextStyle(color: Colors.white), // 입력된 글자 색상 설정
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0), // 텍스트 필드의 모서리 둥글기
                          ),
                          fillColor: Palette.blackColor4, // 텍스트 필드 배경색
                          filled: true,
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Email', // Password 텍스트
                          style: TextStyle(
                            color: Colors.white, // 텍스트 색상
                            fontSize: 16.0, // 텍스트 크기
                          ),
                        ),
                      ),
                      SizedBox(height: 8.0), // 간격 조절
                      TextFormField(
                        controller: _emailController,
                        style: TextStyle(color: Colors.white), // 입력된 글자 색상 설정
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0), // 텍스트 필드의 모서리 둥글기
                          ),
                          fillColor: Palette.blackColor4, // 텍스트 필드 배경색
                          filled: true,

                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      SizedBox(height: 16.0),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Password', // Password 텍스트
                          style: TextStyle(
                            color: Colors.white, // 텍스트 색상
                            fontSize: 16.0, // 텍스트 크기
                          ),
                        ),
                      ),
                      SizedBox(height: 8.0), // 간격 조절
                      TextFormField(
                        controller: _passwordController,
                        style: TextStyle(color: Colors.white), // 입력된 글자 색상 설정
                        obscureText: true,
                        decoration: InputDecoration(

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0), // 텍스트 필드의 모서리 둥글기
                          ),
                          fillColor: Palette.blackColor4, // 텍스트 필드 배경색
                          filled: true,

                        ),

                      ),
                      SizedBox(height: 20.0),
                      ElevatedButton(
                        onPressed: _registerAccount,
                        child: Text('Register', style: TextStyle(color: Colors.white)), // 버튼 텍스트 색상 설정
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Palette.btnColor, // 버튼 배경색
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6.0), // 모서리 둥글기 설정
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
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
