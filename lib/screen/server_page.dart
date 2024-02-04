import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../auth/backend_auth.dart';
import '../auth/custom_widets.dart';
import '../auth/token_provider.dart';
import 'create_server_page.dart';
import 'friends_manage_screen.dart';
import 'notice_screen.dart';

class ServerPage extends StatefulWidget {
  final String useremail;

  ServerPage({Key? key, required this.useremail}) : super(key: key);

  @override
  _ServerPageState createState() => _ServerPageState();
}

class _ServerPageState extends State<ServerPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Myserver> serverList = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _fetchServerList();
  }

  @override
  void dispose() {
    if (_tabController != null) { // _tabController 초기화 확인
      _tabController.dispose();
    }
    super.dispose();
  }

  Future<void> _fetchServerList() async {
    try {
      final accessToken = Provider.of<AuthProvider>(context, listen: false).accessToken;
      final fetchedServerList = await AuthService.fetchServerList(accessToken!);
      setState(() {
        serverList = fetchedServerList;
      });
    } catch (error) {
      CustomWidgets.showCustomDialog(context, 'Error', 'Failed to fetch server list');
    }
  }

  @override
  Widget build(BuildContext context) {
    // _tabController가 초기화되었는지 확인하고 Scaffold를 반환
    if (_tabController == null) {
      return Container(); // 또는 로딩 인디케이터를 반환할 수 있습니다.
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Main page'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _fetchServerList,
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildServerList(),
          FriendsManageScreen(),
          NoticeScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.cloud), label: 'Server'),
          BottomNavigationBarItem(icon: Icon(Icons.security), label: 'Friends'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'My Page'),
        ],
        currentIndex: _tabController.index,
        onTap: (index) {
          _tabController.animateTo(index);
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

  Widget _buildServerList() {
    // 서버 목록을 빌드하는 메서드
    return ListView.builder(
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
    );
  }
}