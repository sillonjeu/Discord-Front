import 'package:flutter/material.dart';

import 'package:discord_front/screen/add_friend_screen.dart';
import 'package:discord_front/config/palette.dart';
void main() {
  runApp(MaterialApp(home: FriendsManageScreen()));
}

class FriendsManageScreen extends StatefulWidget {
  @override
  _FriendsManageScreenState createState() => _FriendsManageScreenState();
}

class _FriendsManageScreenState extends State<FriendsManageScreen> {
  String searchText = '';
  List<FriendTile> originalFriendsList = [
    // 백엔드에서 받아온 친구 목록
    FriendTile(name: 'Amanda', initial: 'A'),
    FriendTile(name: 'Daniel', initial: 'D'),
    FriendTile(name: 'Chris', initial: 'C'),
    FriendTile(name: 'Catherine', initial: 'C'),
    FriendTile(name: 'Brianna', initial: 'B'),
    FriendTile(name: 'Andrew', initial: 'A'),
    FriendTile(name: 'Doris', initial: 'D'),
    FriendTile(name: 'David', initial: 'D'),
    FriendTile(name: 'Bella', initial: 'B'),
    FriendTile(name: 'Clara', initial: 'C'),
    FriendTile(name: 'Brian', initial: 'B'),
    FriendTile(name: 'Benjamin', initial: 'B'),
    FriendTile(name: 'Cody', initial: 'C'),
    FriendTile(name: 'Alice', initial: 'A'),
    FriendTile(name: 'Daisy', initial: 'D'),
    FriendTile(name: 'Anna', initial: 'A'),
    FriendTile(name: 'Diana', initial: 'D'),
    FriendTile(name: 'Caleb', initial: 'C'),
    FriendTile(name: 'Bob', initial: 'B'),
    FriendTile(name: 'Anthony', initial: 'A'),

  ];
  List<FriendTile> sortedFriendsList = [];

  @override
  void initState() {
    super.initState();
    // 백엔드에서 친구 목록을 받아오는 로직
    // 예를 들어, fetchFriendsFromBackend();

    // 친구 목록 정렬
    sortedFriendsList = sortFriendsList(originalFriendsList);
    print("friends list sorted");
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

  @override
  Widget build(BuildContext context) {
    Map<String, List<FriendTile>> friendGroups = groupedFriends();

    return GestureDetector(
      onTap: (){
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
        backgroundColor: Palette.blackColor3,
        appBar: AppBar(
          backgroundColor: Palette.blackColor3,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white,),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text('친구', style: TextStyle(color: Colors.white)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddFriendScreen()),
                );
                // 친구 추가하기 로직
              },
              child: Text('친구 추가하기', style: TextStyle(color: Palette.btnColor)),
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: '검색하기',
                  hintStyle: TextStyle(color: Colors.grey), // 힌트 텍스트 색상 설정
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20), // 모서리 둥글기 설정
                  ),
                  fillColor: Palette.blackColor4, // 텍스트 필드 배경색 설정
                  filled: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 10), // 내부 패딩 조정
                ),
                onChanged: (value) {
                  setState(() {
                    searchText = value;
                  });
                },
              ),
            ),

            FriendRequestTile(),
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
                        child: Text(initial, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color:Colors.white,)),
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
                  Text('친구 요청', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                  Text(
                    '0개 받음 - 1개 보냄',
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

