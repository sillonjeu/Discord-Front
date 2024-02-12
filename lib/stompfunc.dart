import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

//STOMP Client에 연결하기 
abstract class JsonSerializable {
  Map<String, dynamic>  toJson();
}

void connectStomp() {
  final String jwtToken = "";

  final stompClient = StompClient(
    config: StompConfig(
      url : "",
      onConnect: (StompFrame frame){
        print('STOMP Connected');
      },
      beforeConnect: () async {
        print("Connecting to STOMP server...");
        await Future.delayed(Duration(milliseconds: 200));
      
      },
      onWebSocketError: (dynamic error) => print(error.toString()),
      stompConnectHeaders: {'Authorization': 'Bearer $jwtToken'},
      webSocketConnectHeaders: {'Authorization': 'Bearer $jwtToken'}
    ),
  );

  stompClient.activate();
}

//서버에 원하는 경로 subscribe하기
void subscribeToServerResponse(StompClient stompclient) {
  stompclient.subscribe(
    destination: '/user/queue/response', // 서버가 응답을 보낼 주제
    callback: (StompFrame frame) {
      // 서버로부터 응답 데이터 수신
      if (frame.body != null) {
        List<dynamic> dataList = json.decode(frame.body!);
        updateUI(dataList); // UI 업데이트 함수 호출
      }
    },
  );
}

//서버에 데이터 전송
void sendDataToServer<T extends JsonSerializable>(StompClient stompclient, T data)
{
  final dataJson = json.encode(data.toJson());

  stompclient.send(
    destination: 'app/data/add',
    body: dataJson,
    );
}

//받아온 데이터로 UI 업데이트하기
void updateUI(List<dynamic> dataList) {
  //setState(() { StatefulWidget으로 변경후 다시 수정할 예정
    // 데이터를 기반으로 UI 업데이트
    // 예: 리스트 뷰에 아이템 추가하기
  //});
}

//image -> base64
Future<String> encodeImageToBase64(String imagePath) async {
  final ByteData bytes = await rootBundle.load(imagePath); // 이미지 파일 로드
  final Uint8List buffer = bytes.buffer.asUint8List();
  return base64Encode(buffer); // Base64 문자열로 인코딩
}

//base64 -> image
Widget decodeBase64ToImage(String base64String) {
  Uint8List bytes = base64Decode(base64String);
  return Image.memory(bytes);
}