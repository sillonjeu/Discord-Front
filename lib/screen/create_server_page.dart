import 'package:flutter/material.dart';
import 'package:discord_front/config/server.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:discord_front/config/server_list.dart';
import 'package:discord_front/screen/friends_list_page.dart';

class CreateServerPage extends StatefulWidget {
  final String useremail; // 사용자 정보를 저장할 변수

  const CreateServerPage({Key? key, required this.useremail}) : super(key: key);

  @override
  _CreateServerPageState createState() => _CreateServerPageState();
}

class _CreateServerPageState extends State<CreateServerPage> {
  final _formKey = GlobalKey<FormState>();
  final _serverNameController = TextEditingController();
  final _serverDescriptionController = TextEditingController();
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
      File imageFile = _image ?? File('lib/assets/default_server_image.png');

      Server newServer = Server(
        name: _serverNameController.text,
        description: _serverDescriptionController.text, // 서버 설명 추가
        image: imageFile,
        invitedFriends: [],
      );

      Provider.of<ServerList>(context, listen: false).addServer(newServer);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FriendsListPage(
            server: newServer,
            useremail: widget.useremail,
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _serverNameController.dispose();
    _serverDescriptionController.dispose();
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
                if (value == null || value.isEmpty) {
                  return 'Please enter a server name';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _serverDescriptionController,
              decoration: InputDecoration(
                labelText: 'Server Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a server description';
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
