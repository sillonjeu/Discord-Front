import 'package:flutter/foundation.dart';
import 'package:discord_front/auth/token_manager.dart';
import 'package:http/http.dart' as http;
import 'package:discord_front/config/baseurl.dart';
import 'dart:convert';

class AuthProvider extends ChangeNotifier {
  String? _accessToken;
  String? _refreshToken;

  AuthProvider() {
    // 생성자에서 저장된 토큰을 불러옵니다.
    _loadTokens();
  }

  // AccessToken 반환
  String? get accessToken => _accessToken;

  // RefreshToken 반환
  String? get refreshToken => _refreshToken;

  // // AccessToken의 만료 여부 확인 (원하는 로직으로 수정 필요)
  // bool get isAccessTokenExpired {
  //   if (_accessToken == null) {
  //     return true;
  //   }
  //
  //   // 여기에 AccessToken의 만료 여부를 확인하는 로직을 추가하세요.
  //   // 만료되었으면 true, 유효하면 false 반환
  //   return false; // 예시: 만료되지 않음
  // }
  // -> accessToken이 유효한지 여부는 api 호출시 알 수 있고 이때 만료된 토큰을 refresh하는 로직만 짜겠습니다.
  // TODO: 회의때 이와 관련한 내용 알려주기

  // AccessToken을 갱신하는 메서드 이미 accessToken이 만료된지는 알고있다.

  void setTokens(String accessToken, String refreshToken) {
    _accessToken = accessToken;
    _refreshToken = refreshToken;
    notifyListeners(); // 상태 변경 알림
  }

  Future<Map<String,String>?> refreshAccessToken() async {
    if (_refreshToken != null) {
      final Map<String,String> returnMap = await _refreshAccessToken(_refreshToken!);
      if (returnMap["iserror"] == "true") {
        // 갱신된 AccessToken 저장
        logout();
      }
      print("returnMap is...");
      print(returnMap);
      return returnMap;

    } else{
      Map<String,String> returnMap = {
        "iserror":"true",
        "code":"null",
        "message":"refreshToken is null",
        "statusCode":"null",
      };
      return returnMap;
    }
  }

  // 로그아웃 메서드
  void logout() {
    _accessToken = null;
    _refreshToken = null;
    TokenManager.clearTokens();
    notifyListeners(); // 상태 변경 알림
  }

  // 저장된 토큰 불러오기
  Future<void> _loadTokens() async {
    _accessToken = await TokenManager.getAccessToken();
    _refreshToken = await TokenManager.getRefreshToken();
    notifyListeners(); // 상태 변경 알림
  }

  // RefreshToken을 사용하여 AccessToken을 갱신하는 비동기 메서드 (서버 요청 및 응답 구현 필요)
  // 예외 처리와 상세 로직을 추가한 _refreshAccessToken 메서드
  Future<Map<String,String>> _refreshAccessToken(String refreshToken) async {
    Map<String,String> returnMap = {
      "iserror":"true",
      "code":"null",
      "message":"null",
      "statusCode":"null",
    };
    try {
      final response = await http.post(
        Uri.parse(Baseurl.baseurl+'/refresh'), // 백엔드 URL 수정 필요
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ' + refreshToken, // 여기에 refreshToken을 추가
        },
        // body는 보내지 않음
      );

      if (response.statusCode == 200) {
        final responseJson = jsonDecode(response.body);
        returnMap["iserror"]="false";
        returnMap["statusCode"]="200";
        // 토큰을 SharedPreferences에 저장
        // print("new accesss Token is...");
        // print(responseJson["accessToken"]); <-- 잘됨
        // 새로운 토큰을 저장합니다.
        await TokenManager.saveTokens(responseJson["accessToken"], responseJson["refreshToken"]);
        print("accessToken is refreshed!!");
        // AuthProvider의 상태도 업데이트합니다.
        setTokens(responseJson["accessToken"], responseJson["refreshToken"]);
        notifyListeners(); // 상태 변경 알림
        // 로그인 성공, 홈 화면으로 이동
      } else if (response.statusCode == 400) {
        final responseJson = jsonDecode(response.body);
        returnMap["StatusCode"]="400";
        returnMap["code"]=responseJson["code"];
        returnMap["message"]=responseJson["message"];
      } else if (response.statusCode == 401){
        final responseJson = jsonDecode(response.body);
        returnMap["StatusCode"]="401";
        returnMap["code"]=responseJson["code"];
        returnMap["message"]=responseJson["message"];
      }
      return returnMap;
    } catch (e) {
      // 오류 처리 로직
      print('Error refreshing access token: $e');
      returnMap["message"] = 'Error refreshing access token: $e';
      return returnMap;
    }
  }
}
