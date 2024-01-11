import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Discord Server Creation Example',
      home: CreateServerPage(),
    );
  }
}

class CreateServerPage extends StatefulWidget {
  @override
  _CreateServerPageState createState() => _CreateServerPageState();
}

class _CreateServerPageState extends State<CreateServerPage> {
  final _formKey = GlobalKey<FormState>();
  final _serverNameController = TextEditingController();
  File? _image;

  Future<void> _pickImage() async {
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

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
                if (value == null || value!.isEmpty) {
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

class FriendsListPage extends StatefulWidget {
  final String serverName;

  FriendsListPage({required this.serverName});

  @override
  _FriendsListPageState createState() => _FriendsListPageState();
}

class _FriendsListPageState extends State<FriendsListPage> {
  final List<String> friends = [
    'Friend 1',
    'Friend 2',
    'Friend 3',
    'Friend 4',
    // api로 변경 필요
  ];

  Set<String> _invitedFriends = {};

  void _inviteFriend(String friendName) {
    setState(() {
      _invitedFriends.add(friendName);
    });
  }

  void _skipOrComplete() {
    if (_invitedFriends.isNotEmpty) {
      // 초대 완료 로직
    } else {
      // 건너뛰기 로직
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Invite Friends to ${widget.serverName}'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: friends.length,
              itemBuilder: (context, index) {
                return ListTile(
                  contentPadding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
                  title: Text(
                    friends[index],
                    style: TextStyle(fontSize: 16),
                  ),
                  trailing: ElevatedButton(
                    onPressed: () => _inviteFriend(friends[index]),
                    child: Text('Invite'),
                  ),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: _skipOrComplete,
                child: Text(_invitedFriends.isNotEmpty ? '완료' : '건너뛰기'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
