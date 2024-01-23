import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:discord_front/config/server.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../auth/auth_provider.dart';
import '../config/palette.dart';
import 'create_server_page.dart';

class ServerPage extends StatefulWidget {
  final String useremail;

  ServerPage({Key? key, required this.useremail}) : super(key: key);

  @override
  _ServerPageState createState() => _ServerPageState();
}

class _ServerPageState extends State<ServerPage> {
  List<Server> serverList = [];

  @override
  void initState() {
    super.initState();
    _fetchServerList();
  }

  void _showDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Palette.blackColor1, // 다이얼로그 배경색 설정
          title: Text(
            'Login Error',
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

  Future<void> _fetchServerList() async {
    final accessToken = Provider.of<AuthProvider>(context, listen: false).accessToken;
    final uri = Uri.parse('http://ec2-43-202-89-80.ap-northeast-2.compute.amazonaws.com:8080/list/server');
    final response = await http.post(
      uri,
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        serverList = (data['serverList'] as List)
            .map((server) => Server.fromJson(server))
            .toList();
      });
    } else {
      _showDialog('Error: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Server List'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _fetchServerList,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: serverList.length,
        itemBuilder: (context, index) {
          final server = serverList[index];
          ImageProvider backgroundImage;
          if (server.profileImage.isNotEmpty) {
            backgroundImage = MemoryImage(base64Decode(server.profileImage) as Uint8List);
          } else {
            backgroundImage = AssetImage('assets/default_server_image.png');
          }

          return ListTile(
            leading: CircleAvatar(
              backgroundImage: backgroundImage,
            ),
            title: Text(server.name),
            subtitle: Text(server.description),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => CreateServerPage(useremail: widget.useremail),
            ),
          );
        },
      ),
    );
  }
}

class Server {
  final int id;
  final String name;
  final String description;
  final String profileImage;

  Server({
    required this.id,
    required this.name,
    required this.description,
    required this.profileImage,
  });

  factory Server.fromJson(Map<String, dynamic> json) {
    return Server(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      profileImage: json['profileImage'] as String,
    );
  }
}
