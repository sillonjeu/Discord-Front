import 'package:flutter/material.dart';
import 'package:discord_front/config/server.dart';
import 'dart:io';
import 'create_server_page.dart';
import 'package:provider/provider.dart';
import '../config/server_list.dart';

class ServerPage extends StatefulWidget {
  final String serverName;
  final List<String> invitedFriends;
  final File? serverImage;
  final List<Server> serverList;
  final String useremail;

  ServerPage({
    required this.serverName,
    required this.invitedFriends,
    this.serverImage,
    required this.serverList,
    required this.useremail,
  });

  @override
  _ServerPageState createState() => _ServerPageState();
}

class _ServerPageState extends State<ServerPage> {
  @override
  Widget build(BuildContext context) {
    ImageProvider backgroundImage;
    if (widget.serverImage != null) {
      backgroundImage = FileImage(widget.serverImage!);
    } else {
      backgroundImage = AssetImage('lib/assets/default_server_image.png');
    }


    return Scaffold(
      appBar: AppBar(
        title: Text(widget.serverName),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openDrawer(),
            );
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => CreateServerPage(useremail: widget.useremail),
                ),
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView.builder(
          itemCount: widget.serverList.length,
          itemBuilder: (context, index) {
            Server server = widget.serverList[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: FileImage(server.image),
              ),
              title: Text(server.name),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ServerPage(
                      serverName: server.name,
                      invitedFriends: server.invitedFriends,
                      serverImage: server.image,
                      serverList: widget.serverList,
                      useremail: widget.useremail,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      body: Center( // 이 부분을 추가하여 Column을 중앙에 배치
        child: Column(
          mainAxisSize: MainAxisSize.min, // 내용에 맞는 크기로 설정
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                radius: 40.0,
                backgroundImage: backgroundImage,
                backgroundColor: Colors.grey,
              ),
            ),
            if (widget.invitedFriends.isNotEmpty)
              Container(
                color: Colors.grey[100],
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Invited Friends: ${widget.invitedFriends.join(', ')}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            // 추가적인 위젯들
          ],
        ),
      ),
    );
  }
}
