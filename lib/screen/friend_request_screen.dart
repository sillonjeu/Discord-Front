import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';

import '../auth/token_provider.dart';
import '../config/baseurl.dart';
class FriendRequestScreen extends StatefulWidget {
  @override
  _FriendRequestScreenState createState() => _FriendRequestScreenState();
}

class _FriendRequestScreenState extends State<FriendRequestScreen> {
  bool _isReceivedSelected = true;
  List<Map<String, String>> receivedRequests = [];
  List<Map<String, String>> sentRequests = [];

  @override
  void initState() {
    super.initState();
    fetchReceivedRequests();
    fetchSentRequests();
  }

  Future<void> fetchReceivedRequests() async {
    final accessToken = Provider.of<AuthProvider>(context, listen: false).accessToken;
    print("accessToken is ... "+accessToken!);
    try {
      final response = await http.get(
        Uri.parse(Baseurl.baseurl + '/friend/request/received'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );
      if (response.statusCode == 200) {
        final responseJson = jsonDecode(response.body);
        List<Map<String, String>> fetchedFriendsList = [];

        for (var friendData in responseJson["content"]) {
          String nickname = friendData["nickname"];
          String email = friendData["email"];

          fetchedFriendsList.add({"nickname": nickname, "email": email});
        }
        setState(() {
          receivedRequests = fetchedFriendsList;
          print("friend request received list is assigned");
        });
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      print('Error get friend request received list: $e');
    }
    // 백엔드에서 "받음" 데이터를 가져오는 로직

  }

  Future<void> fetchSentRequests() async {
    final accessToken = Provider.of<AuthProvider>(context, listen: false).accessToken;
    print("accessToken is ... "+accessToken!);
    try {
      final response = await http.get(
        Uri.parse(Baseurl.baseurl + '/friend/request/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );
      if (response.statusCode == 200) {
        final responseJson = jsonDecode(response.body);
        List<Map<String, String>> fetchedFriendsList = [];

        for (var friendData in responseJson["content"]) {
          String nickname = friendData["nickname"];
          String email = friendData["email"];

          fetchedFriendsList.add({"nickname": nickname, "email": email});
        }
        setState(() {
          sentRequests = fetchedFriendsList;
          print("friend request sent list is assigned");
        });
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      print('Error get friend request sent list: $e');
    }
    // 백엔드에서 "보냄" 데이터를 가져오는 로직
    // 임시 데이터
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('친구 요청'),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isReceivedSelected = true;
                  });
                  fetchReceivedRequests();
                },
                child: Text('받음'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isReceivedSelected ? Colors.blue : Colors.grey,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isReceivedSelected = false;
                  });
                  fetchSentRequests();
                },
                child: Text('보냄'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: !_isReceivedSelected ? Colors.blue : Colors.grey,
                ),
              ),
            ],
          ),
          Expanded(
            child: _isReceivedSelected ? buildReceivedList(context) : buildSentList(),
          ),
        ],
      ),
    );
  }

  Future<void> acceptRequest(BuildContext context, String email) async {
    final accessToken = Provider.of<AuthProvider>(context, listen: false).accessToken;
    try {
      final response = await http.post(
        Uri.parse(Baseurl.baseurl + '/friend/accept'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(<String, String>{
          'email': email,
        }),
      );
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('친구요청이 수락되었습니다.'),
            duration: Duration(seconds: 3), // 스낵바가 보여지는 시간
          ),
        );
        fetchReceivedRequests();
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      print('Error accept friend request: $e');
    }
    // Implement accept request logic here
  }

  Future<void> declineRequest(BuildContext context, String email) async {
    final accessToken = Provider.of<AuthProvider>(context, listen: false).accessToken;
    try {
      final response = await http.post(
        Uri.parse(Baseurl.baseurl + '/friend/decline'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(<String, String>{
          'email': email,
        }),
      );
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('친구요청이 거절되었습니다.'),
            duration: Duration(seconds: 3), // 스낵바가 보여지는 시간
          ),
        );
        fetchReceivedRequests();
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      print('Error decline friend request: $e');
    }
  }

  Future<void> blockRequest(BuildContext context, String email) async {
    final accessToken = Provider.of<AuthProvider>(context, listen: false).accessToken;
    try {
      final response = await http.post(
        Uri.parse(Baseurl.baseurl + '/friend/block'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(<String, String>{
          'email': email,
        }),
      );
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('친구요청이 차단되었습니다.'),
            duration: Duration(seconds: 3), // 스낵바가 보여지는 시간
          ),
        );
        fetchReceivedRequests();
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      print('Error block friend request: $e');
    }
  }

  Widget buildReceivedList(BuildContext context) {
    return ListView.builder(
      itemCount: receivedRequests.length,
      itemBuilder: (context, index) {
        var request = receivedRequests[index];
        return FriendRequestTile(
          nickname: request['nickname']!,
          email: request['email']!,
          onAccept: () => acceptRequest(context, request['email']!),
          onDecline: () => declineRequest(context, request['email']!),
          onBlock: () => blockRequest(context, request['email']!),
        );
      },
    );
  }

  Widget buildSentList() {
    return ListView.builder(
      itemCount: sentRequests.length,
      itemBuilder: (context, index) {
        var request = sentRequests[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage('https://via.placeholder.com/150'),
          ),
          title: Text(request['nickname']!),
        );
      },
    );
  }




}


class FriendRequestTile extends StatelessWidget {
  final String nickname;
  final String email;
  final VoidCallback onAccept;
  final VoidCallback onDecline;
  final VoidCallback onBlock;

  const FriendRequestTile({
    Key? key,
    required this.nickname,
    required this.email,
    required this.onAccept,
    required this.onDecline,
    required this.onBlock,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage('https://via.placeholder.com/150'),
      ),
      title: Text(nickname),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.block, color: Colors.red),
            onPressed: onBlock,
          ),
          IconButton(
            icon: Icon(Icons.close, color: Colors.grey),
            onPressed: onDecline,
          ),
          IconButton(
            icon: Icon(Icons.check, color: Colors.green),
            onPressed: onAccept,
          ),

        ],
      ),
    );
  }
}
