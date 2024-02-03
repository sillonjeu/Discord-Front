import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:discord_front/screen/add_friend_screen.dart';
import 'package:discord_front/config/palette.dart';
import 'package:provider/provider.dart';

import '../auth/token_provider.dart';
import '../config/baseurl.dart';
import 'package:http/http.dart' as http;

import 'friend_request_screen.dart';

void main() {
  runApp(MaterialApp(home: FriendsManageScreen()));
}

class FriendsManageScreen extends StatefulWidget {
  @override
  _FriendsManageScreenState createState() => _FriendsManageScreenState();
}

class _FriendsManageScreenState extends State<FriendsManageScreen> {
  String searchText = '';
  List<FriendTile> sortedFriendsList = [];
  bool isLoading = true;
  int sentcount = 10;
  int receivedcount = 10;

  Future<void> _handleRefresh() async {
    await fetchRequests();
    await fetchFriends();
    // 새로고침 이후 UI를 업데이트하기 위해 setState를 사용할 수 있습니다.
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    // 백엔드에서 친구 목록을 받아오는 로직
    // 친구 목록 정렬
    fetchRequests();
    fetchFriends();

  }

  List<FriendTile> sortFriendsList(List<FriendTile> friends) {
    // 친구 목록을 알파벳 순으로 정렬
    // 예시를 위한 간단한 정렬 로직
    friends.sort((a, b) => a.name.compareTo(b.name));
    return friends;
  }

  Map<String, List<FriendTile>> groupedFriends() {
    Map<String, List<FriendTile>> map = {};
    for (var friend in sortedFriendsList) {
      String initial = friend.initial.toUpperCase();
      if (friend.name.toLowerCase().contains(searchText.toLowerCase())) {
        map.putIfAbsent(initial, () => []).add(friend);
      }
    }
    return map;
  }

  Future<void> fetchRequests() async {
    //fetchrequest는 항상 fetchfriends와 함께 실행되기 때문에 딱히 setstate를 쓰지 않았습니다. 근데 만약
    //비지니스 로직이 바뀌면 setstate를 추가해야 합니다!!!!
    final accessToken =
        Provider.of<AuthProvider>(context, listen: false).accessToken;
    try {
      final response1 = await http.get(
        Uri.parse(Baseurl.baseurl + '/friend/request/received'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );
      final response2 = await http.get(
        Uri.parse(Baseurl.baseurl + '/friend/request/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );
      if (response1.statusCode == 200 && response2.statusCode == 200) {
        final responseJson1 = jsonDecode(response1.body);
        final responseJson2 = jsonDecode(response2.body);

        setState(() {
          sentcount = responseJson2["numberOfElements"];
          receivedcount = responseJson1["numberOfElements"];
        });
      } else {
        print(response1.statusCode);
        print(response2.statusCode);
      }
    } catch (e) {
      print('Error get friends list: $e');
    }
  }

  Future<void> fetchFriends() async {
    setState(() {
      isLoading = true;
    });
    final accessToken =
        Provider.of<AuthProvider>(context, listen: false).accessToken;
    print("accessToken is ... " + accessToken!);
    try {
      final response = await http.get(
        Uri.parse(Baseurl.baseurl + '/list/friend?page=0&size=20'),
        //TODO: 이거 친구 젠부 가져와야 함.
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );
      if (response.statusCode == 200) {
        final responseJson = jsonDecode(response.body);
        List<FriendTile> fetchedFriendsList = [];

        for (var friendData in responseJson["content"]) {
          String nickname = friendData["nickname"];
          String initial =
          nickname.isNotEmpty ? nickname[0].toUpperCase() : '?';

          fetchedFriendsList.add(FriendTile(name: nickname, initial: initial));
        }
        setState(() {
          sortedFriendsList = sortFriendsList(fetchedFriendsList);
          print("friends list sorted");
        });
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      print('Error get friends list: $e');
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Map<String, List<FriendTile>> friendGroups = groupedFriends();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
        backgroundColor: Palette.blackColor3,
        appBar: AppBar(
          backgroundColor: Palette.blackColor3,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text('친구', style: TextStyle(color: Colors.white)),
          actions: [
            TextButton(
              onPressed: () {
                // 친구 추가하기 화면으로 이동
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddFriendScreen()),
                );
              },
              child: Text('친구 추가하기', style: TextStyle(color: Palette.btnColor)),
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: _handleRefresh,
          child: isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: '검색하기',
                          hintStyle: TextStyle(color: Colors.grey),
                          // 힌트 텍스트 색상 설정
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20), // 모서리 둥글기 설정
                          ),
                          fillColor: Palette.blackColor4,
                          // 텍스트 필드 배경색 설정
                          filled: true,
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 10), // 내부 패딩 조정
                        ),
                        style: TextStyle(color: Colors.white), // 입력 텍스트 색상 설정
                        onChanged: (value) {
                          setState(() {
                            searchText = value;
                          });
                        },
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => FriendRequestScreen()),
                        );
                      },
                      child: FriendRequestTile(
                        receivedCnt: receivedcount,
                        sentCnt:  sentcount,
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: friendGroups.keys.length,
                        itemBuilder: (context, index) {
                          String initial = friendGroups.keys.elementAt(index);
                          List<FriendTile> friends = friendGroups[initial]!;

                          if (friends.isEmpty) {
                            return SizedBox.shrink();
                          }

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(initial,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    )),
                              ),
                              ...friends
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class FriendTile extends StatelessWidget {
  final String name;
  final String initial;

  FriendTile({required this.name, required this.initial});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        color: Palette.blackColor2, // 타일 배경색
        borderRadius: BorderRadius.circular(10), // 모서리 둥글기
      ),
      child: ListTile(
        leading: CircleAvatar(
          // 임시 이미지
          backgroundImage: NetworkImage('https://via.placeholder.com/150'),
        ),
        title: Text(name, style: TextStyle(color: Colors.white)), // 텍스트 색상 변경
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.phone, color: Colors.white),
              onPressed: () {
                // 통화 로직
              },
            ),
            IconButton(
              icon: Icon(Icons.chat_bubble_outline, color: Colors.white),
              onPressed: () {
                // 메시지 보내기 로직
              },
            ),
          ],
        ),
      ),
    );
  }
}

class FriendRequestTile extends StatelessWidget {
  final int receivedCnt;
  final int sentCnt;

  // 생성자 추가
  const FriendRequestTile({
    Key? key,
    required this.receivedCnt,
    required this.sentCnt,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      margin: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Palette.blackColor2, // 타일 배경색
        borderRadius: BorderRadius.circular(10), // 모서리 둥글기
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.people, color: Colors.white), // 아이콘 색상 변경
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('친구 요청',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white)),
                  Text(
                    '$receivedCnt개 받음 - $sentCnt개 보냄',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
          Icon(Icons.chevron_right, color: Colors.white), // 아이콘 색상 변경
        ],
      ),
    );
  }
}

