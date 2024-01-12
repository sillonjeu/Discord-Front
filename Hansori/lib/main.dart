import 'package:flutter/material.dart';
import 'package:hansori/server_page.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

void main() {
  runApp(MyApp());
}

// 기본 애플리케이션 클래스
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // MaterialApp 위젯을 사용하여 앱의 기본 구조 정의
    return MaterialApp(
      title: 'Discord Server Creation Example',
      home: CreateServerPage(),
    );
  }
}

// 서버 생성 페이지를 위한 StatefulWidget
class CreateServerPage extends StatefulWidget {
  @override
  _CreateServerPageState createState() => _CreateServerPageState();
}

File? _image; // 사용자가 선택한 이미지 파일
// CreateServerPage의 상태 관리 클래스
class _CreateServerPageState extends State<CreateServerPage> {
  final _formKey = GlobalKey<FormState>(); // 폼의 키
  final _serverNameController = TextEditingController(); // 서버 이름 입력 컨트롤러

  // 이미지를 갤러리에서 선택하는 메소드
  Future<void> _pickImage() async {
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  // 서버 생성 버튼 클릭 이벤트 처리 메소드
  void _createServer() {
    if (_formKey.currentState!.validate()) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FriendsListPage(serverName: _serverNameController.text),
        ),
      );
    }
  }

  @override
  void dispose() {
    _serverNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // UI 구성 메소드
    return Scaffold(
      appBar: AppBar(
        title: Text('Create a Server'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            Center(
              child: InkWell(
                onTap: _pickImage,
                child: ClipOval(
                  child: _image != null
                      ? Image.file(_image!, width: 100, height: 100, fit: BoxFit.cover)
                      : Container(
                    width: 100,
                    height: 100,
                    color: Colors.blue,
                    child: Icon(Icons.camera_alt, color: Colors.white),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _serverNameController,
              decoration: InputDecoration(
                labelText: 'Server Name',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a server name';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _createServer,
              child: Text('Create Server'),
            ),
          ],
        ),
      ),
    );
  }
}

// 친구 목록 페이지를 위한 StatefulWidget
class FriendsListPage extends StatefulWidget {
  final String serverName;

  FriendsListPage({required this.serverName});

  @override
  _FriendsListPageState createState() => _FriendsListPageState();
}

// FriendsListPage의 상태 관리 클래스
class _FriendsListPageState extends State<FriendsListPage> {
  final List<String> friends = [
    'Friend 1',
    'Friend 2',
    'Friend 3',
    'Friend 4',
  ];

  Set<String> _invitedFriends = {}; // 초대된 친구들 저장
  List<String> _invitedFriendsDisplay = []; // 화면에 표시할 초대된 친구 목록

  void _inviteFriend(String friendName) {
    setState(() {
      if (_invitedFriends.contains(friendName)) {
        _invitedFriends.remove(friendName);
        _invitedFriendsDisplay.remove(friendName);
      } else {
        _invitedFriends.add(friendName);
        _invitedFriendsDisplay.add(friendName);
      }
    });
  }

  void _skipOrComplete() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ServerPage(
          serverName: widget.serverName,
          invitedFriends: _invitedFriendsDisplay,
          serverImage: _image, // _CreateServerPageState에서 정의된 _image 변수 사용
        ),
      ),
    );
  }

  // api 변경 필요(더미 데이터)
  String _invitedLink = "https://invite.link/to/server";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Invite Friends to ${widget.serverName}'),
      ),
      body: Column(
        children: [
          // 초대된 친구 목록 표시
          if (_invitedFriendsDisplay.isNotEmpty)
            Container(
              color: Colors.grey[100],
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Invited Friends: ${_invitedFriendsDisplay.join(', ')}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          // 링크 표시
          Container(
            padding: EdgeInsets.all(16.0),
            alignment: Alignment.center,
            child: SelectableText(
              'Server Link: $_invitedLink',
              style: TextStyle(fontSize: 16, color: Colors.blue),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: friends.length,
              itemBuilder: (context, index) {
                return ListTile(
                  contentPadding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
                  title: Text(friends[index], style: TextStyle(fontSize: 16)),
                  trailing: ElevatedButton(
                    onPressed: () => _inviteFriend(friends[index]),
                    child: Text(_invitedFriends.contains(friends[index])
                        ? 'Cancel Invite'
                        : 'Invite'),
                  ),
                );
              },
            ),
          ),
          // 완료/건너뛰기 버튼을 아래 중앙에 배치
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 50.0),
              child: ElevatedButton(
                onPressed: _skipOrComplete,
                child: Text(_invitedFriends.isNotEmpty ? 'Complete' : 'Skip'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
