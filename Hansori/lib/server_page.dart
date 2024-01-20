import 'package:flutter/material.dart';
import 'package:hansori/server.dart';
import 'dart:io';
import 'create_server_page.dart';
import 'package:provider/provider.dart';
import 'server_list.dart';

// StatefulWidget을 사용하여 상태를 가지는 서버 페이지 클래스를 생성
class ServerPage extends StatefulWidget {
  final String serverName;
  final List<String> invitedFriends;
  final File? serverImage;
  final List<Server> serverList;

  ServerPage({
    required this.serverName,
    required this.invitedFriends,
    this.serverImage,
    required this.serverList,
  });

  @override
  _ServerPageState createState() => _ServerPageState();
}

class _ServerPageState extends State<ServerPage> {
  bool isDrawerOpen = false; // 드로어가 열렸는지의 상태를 추적하는 변수

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.serverName),
        leading: IconButton(
          // 메뉴 버튼을 눌렀을 때 드로어의 상태를 변경
          icon: Icon(isDrawerOpen ? Icons.arrow_back : Icons.menu),
          onPressed: () {
            setState(() {
              isDrawerOpen = !isDrawerOpen; // 드로어의 상태를 토글
            });
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              // 서버 생성 페이지로 이동
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => CreateServerPage()));
            },
          ),
        ],
      ),
      body: Row(
        children: [
          AnimatedContainer(
            // 드로어의 열림과 닫힘을 애니메이션으로 표현하기 위해 AnimatedContainer를 사용
            duration: Duration(milliseconds: 0),
            // 애니메이션 지속 시간을 설정
            width: isDrawerOpen ? 100 : 0,
            // 드로어가 열렸을 때는 너비를 100으로, 닫혔을 때는 0으로 설정
            child: isDrawerOpen
                ? ListView.builder(
                    itemCount:
                        widget.serverList.length, // 서버 목록의 길이만큼 아이템 개수를 설정
                    itemBuilder: (context, index) {
                      Server server =
                          widget.serverList[index]; // 서버 목록에서 서버를 가져오기
                      return InkWell(
                        onTap: () {
                          setState(() {
                            isDrawerOpen = false; // 아이템을 탭하면 드로어를 닫기
                          });
                          // 선택한 서버의 페이지로 이동
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ServerPage(
                                serverName: server.name,
                                invitedFriends: server.invitedFriends,
                                serverImage: server.image,
                                serverList: widget.serverList,
                              ),
                            ),
                          );
                        },
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 20.0,
                                backgroundImage: server.image != null
                                    ? FileImage(server.image!)
                                    : AssetImage(
                                            'assets/default_server_image.png')
                                        as ImageProvider,
                                backgroundColor: Colors.grey,
                              ),
                              Text(server.name), // 서버의 이름을 표시
                            ],
                          ),
                        ),
                      );
                    },
                  )
                : null,
          ),
          // 드로어 이외의 부분은 확장하여 나머지 공간을 채우기 -> 채팅으로 바꿔야함
          Expanded(
            child: Column(
              children: [
                // 서버 이미지를 표시하기
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),
                      CircleAvatar(
                        radius: 40.0,
                        backgroundImage: widget.serverImage != null
                            ? FileImage(widget.serverImage!)
                            : AssetImage('assets/default_server_image.png')
                                as ImageProvider,
                        backgroundColor: Colors.grey,
                      ),
                    ],
                  ),
                ),
                // 초대된 친구 목록을 표시하기
                if (widget.invitedFriends.isNotEmpty)
                  Container(
                    color: Colors.grey[100],
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Invited Friends: ${widget.invitedFriends.join(', ')}',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                // 나머지 구현할 때 이 부분에 채우면 됨
              ],
            ),
          ),
        ],
      ),
    );
  }
}
