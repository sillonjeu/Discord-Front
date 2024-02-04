import 'dart:convert';
import 'package:http_parser/http_parser.dart';
import '../config/baseurl.dart';
import 'package:http/http.dart' as http;
import '../config/server.dart';

// 내 서버 목록 조회할때 사용하는 클래스
class Myserver {
  final int id;
  final String name;
  final String description;
  final String profileImage;

  Myserver({
    required this.id,
    required this.name,
    required this.description,
    required this.profileImage,
  });

  factory Myserver.fromJson(Map<String, dynamic> json) {
    return Myserver(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      profileImage: json['profileImage'] as String,
    );
  }
}

class AuthService {
  // 로그인 요청
  static Future<Map<String, dynamic>> login(String email, String password) async {
    Uri loginUri = Uri.parse(Baseurl.baseurl + '/login');
    final response = await http.post(
      loginUri,
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return {
        'accessToken': data['accessToken'],
        'refreshToken': data['refreshToken'],
        'statusCode': response.statusCode
      };
    } else {
      return {
        'error': response.body,
        'statusCode': response.statusCode
      };
    }
  }

  // 회원가입 요청
  static Future<Map<String, dynamic>> register({
    required String username,
    required String password,
    required String email,
    required String birthDate,
  }) async {
    Uri signUpUri = Uri.parse(Baseurl.baseurl + '/signUp');
    final response = await http.post(
      signUpUri,
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
        'nickname': username,
        'birth': birthDate,
      }),
    );

    if (response.statusCode == 200) {
      return {
        'message': 'User registered successfully',
        'statusCode': response.statusCode
      };
    } else {
      return {
        'error': response.body,
        'statusCode': response.statusCode
      };
    }
  }

  // 서버 만들기 요청
  static Future<void> sendServerData(Server server, Set<String> invitedFriends, String accessToken) async {
    var uri = Uri.parse(Baseurl.baseurl + '/server');

    var request = http.MultipartRequest('POST', uri);

    if (accessToken.isNotEmpty) {
      request.headers.addAll({
        'Accept': 'application/json',
        'Authorization': 'Bearer $accessToken',
      });
    }

    if (server.image != null) {
      request.files.add(
        http.MultipartFile(
          'serverImage',
          server.image.readAsBytes().asStream(),
          server.image.lengthSync(),
          filename: server.image.path.split("/").last,
        ),
      );
    }

    request.files.add(http.MultipartFile.fromString(
      'serverInfo',
      json.encode({
        'name': server.name,
        'description': server.description,
      }),
      contentType: MediaType('application', 'json'),
    ));

    request.files.add(http.MultipartFile.fromString(
      'friendList',
      json.encode(invitedFriends.toList()),
      contentType: MediaType('application', 'json'),
    ));

    var response = await request.send();

    if (response.statusCode != 200) {
      print('Error: ${response.statusCode}');
    }
  }

  // 내 서버 목록 조회하기
  static Future<List<Myserver>> fetchServerList(String accessToken) async {
    final uri = Uri.parse(Baseurl.baseurl + '/list/server');
    final response = await http.post(
      uri,
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['serverList'] as List)
          .map((server) => Myserver.fromJson(server))
          .toList();
    } else {
      throw Exception('Failed to load server list');
    }
  }

  // 친구 목록 조회 요청
  static Future<List<Friend>> fetchFriendsData(String accessToken) async {
    final uri = Uri.parse(Baseurl.baseurl + '/list/friend?page=0&size=10');
    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<Friend> friends = (data['content'] as List)
          .map((friend) => Friend.fromJson(friend))
          .toList();
      return friends;
    } else {
      throw Exception('Failed to load friends list');
    }
  }
}

// 친구 데이터를 저장할 모델 클래스
class Friend {
  final String email;
  final String nickname;
  final String? profileImageId;
  final String? profileMsg;
  final String? profileImage;

  Friend({
    required this.email,
    required this.nickname,
    this.profileImageId,
    this.profileMsg,
    this.profileImage,
  });

  factory Friend.fromJson(Map<String, dynamic> json) {
    return Friend(
      email: json['email'],
      nickname: json['nickname'],
      profileImageId: json['profileImageId'],
      profileMsg: json['profileMsg'],
      profileImage: json['profileImage'],
    );
  }
}
