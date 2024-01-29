import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../auth/backend_auth.dart';
import '../auth/custom_widets.dart';
import '../auth/token_provider.dart';
import 'create_server_page.dart';

class ServerPage extends StatefulWidget {
  final String useremail;

  ServerPage({Key? key, required this.useremail}) : super(key: key);

  @override
  _ServerPageState createState() => _ServerPageState();
}

class _ServerPageState extends State<ServerPage> {
  List<Myserver> serverList = [];

  @override
  void initState() {
    super.initState();
    _fetchServerList();
  }

  // backend_auth 확인
  Future<void> _fetchServerList() async {
    try {
      final accessToken = Provider.of<AuthProvider>(context, listen: false).accessToken;
      final fetchedServerList = await AuthService.fetchServerList(accessToken!);
      setState(() {
        serverList = fetchedServerList;
      });
    } catch (error) {
      CustomWidgets.showCustomDialog(
          context,
          'Error',
          'Failed to fetch server list'
      );
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