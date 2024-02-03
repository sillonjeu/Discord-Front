import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../auth/token_provider.dart';
import '../config/baseurl.dart';
import 'package:http/http.dart' as http;
class AddFriendScreen extends StatefulWidget {
  @override
  _AddFriendScreenState createState() => _AddFriendScreenState();
}

class _AddFriendScreenState extends State<AddFriendScreen> {
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode()); // 키보드 숨김
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('친구 추가하기'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '이메일로 추가',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _emailController, // 텍스트 입력 컨트롤러 연결
                decoration: InputDecoration(
                  labelText: '이메일 입력하기',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addFriend, // 친구 추가 버튼 이벤트 핸들러
                child: Text('추가'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _addFriend() async {
    String email = _emailController.text; // 사용자가 입력한 이메일 주소 가져오기
    final accessToken = Provider.of<AuthProvider>(context, listen: false).accessToken;
    try {
      final response = await http.post(
        Uri.parse(Baseurl.baseurl + '/friend/request'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(<String, String>{
          'email': email,
        }),
      );
      if (response.statusCode == 200) {
        final responseJson = jsonDecode(response.body);
        if(responseJson == "PENDING") {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('친구가 신청되었습니다.'),
              duration: Duration(seconds: 3), // 스낵바가 보여지는 시간
            ),
          );
        } else if(responseJson == "ACCEPTED"){
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('상대도 친구요청을 보냈어서 친구가 되었습니다.'),
              duration: Duration(seconds: 3), // 스낵바가 보여지는 시간
            ),
          );
        } else{
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('상대가 당신을 차단했습니다.'),
              duration: Duration(seconds: 3), // 스낵바가 보여지는 시간
            ),
          );
        }

        print(responseJson);
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      print('friend add Error: $e');
    }
  }

  // 메모리 누수 방지를 위해 컨트롤러 해제
  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}

