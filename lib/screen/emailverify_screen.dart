import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:discord_front/config/palette.dart';

class EmailVerificationScreen extends StatelessWidget {
  final String useremail;

  const EmailVerificationScreen({Key? key, required this.useremail})
      : super(key: key);

  Future<void> _verify(BuildContext context) async {
    final String email = this.useremail;
    // TODO: 백엔드에 대한 HTTP 요청을 보내서 이메일 확인 여부를 확인

    // 가상의 응답 생성
    // 백엔드 구현이 완료되면 실제 HTTP 요청으로 대체
    // final response = await http.post(
    //   Uri.parse('http://your-backend-url.com/login'), // 백엔드 URL 수정 필요
    //   headers: <String, String>{
    //     'Content-Type': 'application/json',
    //   },
    //   body: jsonEncode(<String, String>{
    //     'email': email,
    //   }),
    // );

    // 가상의 응답 생성
    // 백엔드 구현이 완료되면 실제 HTTP 요청으로 대체
    final response = http.Response(
      jsonEncode({'result': false}), // true 또는 false로 변경하여 테스트
      200, // HTTP 상태 코드
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final responseJson = jsonDecode(response.body);
      if (responseJson['result']) {
        _showDialog(context, 'Your email has been verified.', 'Email Verified');
        Navigator.popUntil(context, (route) => route.isFirst);
      } else {
        // 이메일이 확인되지 않았을 때
        _showDialog(context, 'Your email could not be verified.',
            'Email Verification Failed');
      }
    } else {
      // 서버 에러 또는 기타 오류
      _showDialog(
          context, 'Error: ${response.statusCode}', 'Email Verification Error');
    }
  }

  void _showDialog(BuildContext context, String message, String title) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _resendEmail(BuildContext context) async {
    final String email = this.useremail;
    // TODO: 백엔드에 대한 HTTP 요청을 보내서 이메일 확인 여부를 확인

    // 가상의 응답 생성
    // 백엔드 구현이 완료되면 실제 HTTP 요청으로 대체
    // final response = await http.post(
    //   Uri.parse('http://your-backend-url.com/login'), // 백엔드 URL 수정 필요
    //   headers: <String, String>{
    //     'Content-Type': 'application/json',
    //   },
    //   body: jsonEncode(<String, String>{
    //     'email': email,
    //   }),
    // );

    // 가상의 응답 생성
    // 백엔드 구현이 완료되면 실제 HTTP 요청으로 대체
    final response = http.Response(
      jsonEncode({'result': false}), // 이거 굳이 필요없긴함. //TODO: result 지우기
      200, // HTTP 상태 코드
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      // 제대로 보냄
      _showDialog(context, 'An email has been resent to your email address.',
          'Resend Email');
    } else {
      // 서버 에러 또는 기타 오류
      _showDialog(
          context, 'Error: ${response.statusCode}', 'Email Sending Error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Palette.blackColor1, // 앱바 배경색 설정
        iconTheme: IconThemeData(color: Colors.white), // 뒤로가기 버튼 색상 설정
      ),
      body: Container(
        color: Palette.blackColor1, // 배경색 설정
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'asset/img/castle_emailverify_image.png', // 이미지 경로 설정
                width: 150, // 이미지 너비 조절
                height: 150, // 이미지 높이 조절
              ),
              SizedBox(height: 24.0),
              Text(
                'An email has been sent to your email address. '
                'Please check your email and follow the instructions to verify your account.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white), // 텍스트 색상 변경
              ),
              SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: () {
                  // 사용자가 이메일을 확인한 후 _verify 함수 호출
                  _verify(context);
                },
                child: Text('Verified', style: TextStyle(color: Colors.white)),
                // 텍스트 색상 변경
                style: ElevatedButton.styleFrom(
                  backgroundColor: Palette.btnColor, // 버튼 배경색 설정
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0), // 모서리 둥글기 설정
                  ),
                ),
              ),
              SizedBox(height: 12.0),
              ElevatedButton(
                onPressed: () {
                  _resendEmail(context);
                },
                child:
                    Text('Resend Email', style: TextStyle(color: Colors.white)),
                // 텍스트 색상 변경
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Palette.blackColor1, // 텍스트 색상 설정
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.white), // 경계선 색상 설정
                    borderRadius: BorderRadius.circular(5.0), // 모서리 둥글기 설정
                  ),
                ),
              ),
              SizedBox(height: 12.0),
              ElevatedButton(
                onPressed: () {
                  // 'Change Email' 버튼을 눌렀을 때의 동작
                  Navigator.pop(context);
                },
                child:
                    Text('Change Email', style: TextStyle(color: Colors.white)),
                // 텍스트 색상 변경
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Palette.blackColor1, // 텍스트 색상 설정
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.white), // 경계선 색상 설정
                    borderRadius: BorderRadius.circular(5.0), // 모서리 둥글기 설정
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}