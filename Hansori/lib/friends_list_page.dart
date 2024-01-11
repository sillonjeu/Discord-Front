// friends_list_page.dart
import 'package:flutter/material.dart';

class FriendsListPage extends StatelessWidget {
  final String serverName;

  FriendsListPage({required this.serverName});

  final List<String> friends = [
    'Alice',
    'Bob',
    'Charlie',
    'David',
    // Add more friends here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Invite Friends to $serverName'),
      ),
      body: ListView.builder(
        itemCount: friends.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(friends[index]),
            trailing: ElevatedButton(
              onPressed: () {
                // Implement invitation logic
                print('Inviting ${friends[index]}');
              },
              child: Text('Invite'),
            ),
          );
        },
      ),
    );
  }
}
