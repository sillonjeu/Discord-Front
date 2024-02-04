import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:discord_front/auth/custom_widets.dart';
import 'package:discord_front/auth/backend_auth.dart';
import 'package:discord_front/auth/token_provider.dart';
import 'package:discord_front/config/server.dart';
import 'package:discord_front/screen/server_page.dart' hide Server;

class FriendsListPage extends StatefulWidget {
  final Server server;
  final String useremail;

  FriendsListPage({Key? key, required this.server, required this.useremail}) : super(key: key);

  @override
  _FriendsListPageState createState() => _FriendsListPageState();
}

class _FriendsListPageState extends State<FriendsListPage> {
  List<Friend> friends = []; // 친구 목록 불러오기
  Set<String> _invitedFriends = {}; // 초대할 친구들

  @override
  void initState() {
    super.initState();
    _fetchFriendsData();
  }

  void _inviteFriend(String friendEmail) {
    setState(() {
      if (_invitedFriends.contains(friendEmail)) {
        _invitedFriends.remove(friendEmail);
      } else {
        _invitedFriends.add(friendEmail);
      }
    });
  }

  // 친구 목록 불러오기
  Future<void> _fetchFriendsData() async {
    final accessToken = Provider.of<AuthProvider>(context, listen: false).accessToken;
    if (accessToken != null) {
      friends = await AuthService.fetchFriendsData(accessToken);
      setState(() {});
    }
  }

  // 만들 서버 보내기
  Future<void> _sendServerData() async {
    final accessToken = Provider.of<AuthProvider>(context, listen: false).accessToken;
    if (accessToken != null) {
      await AuthService.sendServerData(widget.server, _invitedFriends, accessToken);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ServerPage(useremail: widget.useremail),
        ),
      );
    } else {
      CustomWidgets.showCustomDialog(context, 'Error', 'Access token is not available');
    }
  }

  // Todo: 이거 실제 주소로 연동 해야됨
  String _invitedLink = "https://invite.link/to/server";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Invite Friends to ${widget.server.name}'),
      ),
      body: Column(
        children: [
          if (_invitedFriends.isNotEmpty)
            Container(
              color: Colors.grey[100],
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Invited Friends: ${_invitedFriends.join(', ')}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
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
                final friend = friends[index];
                return ListTile(
                  contentPadding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
                  title: Text(friend.email, style: TextStyle(fontSize: 16)),
                  trailing: ElevatedButton(
                    onPressed: () => _inviteFriend(friend.email),
                    child: Text(_invitedFriends.contains(friend.email) ? 'Cancel Invite' : 'Invite'),
                  ),
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 50.0, right: 16.0, left: 16.0),
              child: CustomElevatedButton(
                label: (_invitedFriends.isNotEmpty ? 'Complete' : 'Skip'),
                onPressed: _sendServerData,
              ),
            ),
          ),
        ],
      ),
    );
  }
}