import 'package:discord_front/auth/custom_widets.dart';
import 'package:flutter/material.dart';
import 'package:discord_front/config/server.dart';
import 'package:discord_front/screen/server_page.dart' hide Server;
import 'package:provider/provider.dart';
import '../auth/backend_auth.dart';
import '../auth/token_provider.dart';

class FriendsListPage extends StatefulWidget {
  final Server server;
  final String useremail;

  FriendsListPage({Key? key, required this.server, required this.useremail})
      : super(key: key);
  @override
  _FriendsListPageState createState() => _FriendsListPageState();
}

class _FriendsListPageState extends State<FriendsListPage> {
// Todo: 이거도 실제 친구 목록으로 바꿔야됨 -> 다원이꺼랑 연동
  final List<String> friends = [
    'Friend1@naver.com',
    'Friend2@naver.com',
    'Friend3@naver.com',
    'Friend4@naver.com',
  ];

  Set<String> _invitedFriends = {};

  void _inviteFriend(String friendName) {
    setState(() {
      if (_invitedFriends.contains(friendName)) {
        _invitedFriends.remove(friendName);
      } else {
        _invitedFriends.add(friendName);
      }
    });
  }

  // backend_auth 확인하기
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
      CustomWidgets.showCustomDialog(
          context,
          'Error',
          'Access token is not available'
      );
    }
  }

  // Todo: 이거도 실제 주소로 바꿔야함
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
