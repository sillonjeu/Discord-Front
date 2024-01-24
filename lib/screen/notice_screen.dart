import 'package:flutter/material.dart';

class NoticeScreen extends StatefulWidget {
  @override
  _NoticeScreenState createState() => _NoticeScreenState();
}

class _NoticeScreenState extends State<NoticeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('알림'),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () => _showSettingsDialog(context),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: ListView.builder(
          itemCount: 5, // 더미 데이터 개수
          itemBuilder: (context, index) {
            return ListTile(
              leading: CircleAvatar(
                // 임시 프로필 이미지
                child: Icon(Icons.person),
              ),
              title: Text('알림 제목 $index'), // 더미 알림 제목
              subtitle: Text('알림 내용 $index\n3시간 전'), // 더미 알림 내용 및 시간
              isThreeLine: true,
            );
          },
        ),
      ),
    );
  }

  Future<void> _handleRefresh() async {
    // 백엔드에서 새로운 알림 데이터를 가져오는 로직을 구현합니다.
    await Future.delayed(Duration(seconds: 2)); // 임시로 지연시간 추가
    // 새로고침 로직을 추가할 수 있습니다.
  }

  void _showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('알림 설정'),
          content: Text('알림 설정으로 이동하시겠습니까?'),
          actions: <Widget>[
            TextButton(
              child: Text('취소'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('이동'),
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
                // 알림 설정 페이지로 이동하는 로직을 구현합니다.
              },
            ),
          ],
        );
      },
    );
  }
}
