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
  String appBarTitle = "Server Page";

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    // TabController의 리스너를 추가하여 현재 탭의 인덱스가 변경될 때마다 데이터를 새로고침하는 로직을 실행!!
    _tabController.addListener(_handleTabSelection);
    _fetchServerList();
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging || _tabController.index != _tabController.previousIndex) {
      _fetchServerList();
      setState(() {
        // 현재 선택된 탭에 따라 AppBar의 제목을 변경
        switch (_tabController.index) {
          case 0:
            appBarTitle = "Server Page";
            break;
          case 1:
            appBarTitle = "Friends Page";
            break;
          case 2:
            appBarTitle = "Notice Page";
            break;
        }
      });
    }
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
        title: Text(appBarTitle),
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
        // 중요!!: BottomNavigationBar에서 탭을 전환할 때 setState를 호출하여 UI가 새로운 탭 인덱스에 맞게 업데이트
        onTap: (index) {
          setState(() {
            _tabController.index = index;
          });
        },
      ),
      floatingActionButton: _tabController.index == 0 ? FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => CreateServerPage(useremail: widget.useremail),
            ),
          );
        },
      ) : null,
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