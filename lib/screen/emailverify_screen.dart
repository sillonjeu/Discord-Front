import 'package:flutter/material.dart';
import 'package:discord_front/config/palette.dart';
import 'package:discord_front/auth/backend_auth.dart';
import 'package:discord_front/auth/custom_widets.dart';

class EmailVerificationScreen extends StatelessWidget {
  final String email;
  final String password;
  final String username;
  final String date;

  const EmailVerificationScreen({
    Key? key,
    required this.email,
    required this.username,
    required this.password,
    required this.date
  }) : super(key: key);

  // 이메일 재전송 하는거 기존에 만들어둔 회원가입 로직이랑 똑같음
  Future<void> _resendEmail(BuildContext context) async {
    final result = await AuthService.register(
      email: email,
      password: password,
      username: username,
      birthDate: date,
    );
    if (result['statusCode'] == 200) {
      CustomWidgets.showCustomDialog(context, 'Resend Email', 'An email has been resent to your email address.');
    } else {
      CustomWidgets.showCustomDialog(context, 'Email Sending Error', 'Error: ${result['error']}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Palette.blackColor1,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        color: Palette.blackColor1,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'asset/img/castle_emailverify_image.png',
                width: 150,
                height: 150,
              ),
              SizedBox(height: 24.0),
              Text(
                'An email has been sent to your email address. '
                     'Please check your email and follow the instructions to verify your account.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 24.0),
              CustomElevatedButton(
                label: 'Verified',
                onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
              ),
              SizedBox(height: 12.0),
              CustomElevatedButton(
                label: 'Resend Email',
                onPressed: () => _resendEmail(context),
                backgroundColor: Palette.blackColor4,
                textColor: Colors.white,
              ),
              SizedBox(height: 12.0),
              CustomElevatedButton(
                label: 'Change Email',
                onPressed: () => Navigator.pop(context),
                backgroundColor: Palette.blackColor4,
                textColor: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}