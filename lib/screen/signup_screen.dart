import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:discord_front/screen/emailverify_screen.dart';
import 'package:discord_front/config/palette.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  String _selectedYear = '2024'; // 기본값으로 2024를 선택합니다.
  String _selectedMonth = '01'; // 기본값으로 1월을 선택합니다.
  String _selectedDay = '01'; // 기본값으로 1일을 선택합니다.

  // 연도 목록을 생성합니다.
  List<String> _yearsList = List.generate(125, (int index) {
    return (1900 + index).toString();
  });

  // 월 목록을 생성합니다.
  List<String> _monthsList = List.generate(12, (int index) {
    return (index + 1).toString().padLeft(2, '0');
  });

  // 일 목록을 생성합니다.
  List<String> _daysList = List.generate(31, (int index) {
    return (index + 1).toString().padLeft(2, '0');
  });


  Future<void> _registerAccount() async {
    final String username = _usernameController.text;
    final String password = _passwordController.text;
    final String email = _emailController.text;
    final String date = '$_selectedYear-$_selectedMonth-$_selectedDay';

    //print("date is "+ date);

    if (email.isEmpty || !email.contains('@') || password.isEmpty || password.length < 6 || username.length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('유효한 폼을 작성해주세요'),
        ),
      );
      return; // 이메일이 유효하지 않으면 함수 종료
    }

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
          backgroundColor: Palette.blackColor1, // 다이얼로그 배경색 설정
          title: Text(
            'Signup Error',
            style: TextStyle(color: Colors.white), // 다이얼로그 제목 텍스트 색상 설정
          ),
          content: Text(
            message,
            style: TextStyle(color: Colors.white), // 다이얼로그 내용 텍스트 색상 설정
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Close',
                style: TextStyle(color: Colors.black), // 텍스트 색상 설정
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white, // 버튼 배경색
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3.0), // 모서리 둥글기 설정
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDropdown2(List<String> items, String selectedValue, void Function(String?)? onChanged) {
    return Expanded(
      child: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Palette.blackColor4, // 드롭다운 메뉴의 배경 색상 설정
        ),
        child: DropdownButtonFormField<String>(
          value: selectedValue,
          onChanged: onChanged,
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: TextStyle(color: Colors.white), // 항목 텍스트 색상 변경
              ),
            );
          }).toList(),
          decoration: InputDecoration(
            filled: true,
            fillColor: Palette.blackColor4,
            contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
              borderSide: BorderSide(color: Colors.transparent),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
              borderSide: BorderSide(color: Colors.transparent),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
              borderSide: BorderSide(color: Colors.transparent),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
              borderSide: BorderSide(color: Colors.transparent),
            ),
          ),
          selectedItemBuilder: (BuildContext context) {
            return items.map<Widget>((String item) {
              return Text(
                item,
                style: TextStyle(color: Colors.white), // 선택된 항목의 텍스트 색상 변경
              );
            }).toList();
          },
        ),
      ),
    );
  }







  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.transparent, // 배경색을 투명하게 설정
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
            SingleChildScrollView(
              child: Center(
                child: Container(
              
                  margin: EdgeInsets.symmetric(vertical: 30.0, horizontal: 40.0),
                  padding: EdgeInsets.only(top: 32.0, bottom: 32.0, left: 16.0, right: 16.0),
                  decoration: BoxDecoration(
                    color: Palette.blackColor1, // 투명도 조절 가능
                    borderRadius: BorderRadius.circular(20.0), // 모서리 둥글게
                  ),
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
                      SizedBox(height: 16.0),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Date', // Date
                          style: TextStyle(
                            color: Colors.white, // 텍스트 색상
                            fontSize: 16.0, // 텍스트 크기
                          ),
                        ),
                      ),
                      SizedBox(height: 8.0), // 간격 조절
                      Row(
                        children: [
                          _buildDropdown2(_yearsList, _selectedYear, (value) {
                            setState(() {
                              _selectedYear = value!;
                            });
                          }),
                          SizedBox(width: 16.0),
                          _buildDropdown2(_monthsList, _selectedMonth, (value) {
                            setState(() {
                              _selectedMonth = value!;
                            });
                          }),
                          SizedBox(width: 16.0),
                          _buildDropdown2(_daysList, _selectedDay, (value) {
                            setState(() {
                              _selectedDay = value!;
                            });
                          }),
                        ],
                      ),


                      SizedBox(height: 20.0),

                      Container(
                        width: double.infinity, // 버튼의 너비를 화면 폭 전체로 설정
                        child: ElevatedButton(
                          onPressed: _registerAccount,
                          child: Text('Register', style: TextStyle(color: Colors.white)), // 버튼 텍스트 색상 설정
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Palette.btnColor, // 버튼 배경색
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(3.0), // 모서리 둥글기 설정
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Container(
                        width: double.infinity, // 버튼의 너비를 화면 폭 전체로 설정
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context); // 뒤로가기 기능을 수행합니다.
                          },
                          child: Text('You already have account?', style: TextStyle(color: Colors.black)), // 버튼 텍스트 색상 설정
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white, // 버튼 배경색
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(3.0), // 모서리 둥글기 설정
                            ),
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
