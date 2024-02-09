import 'package:flutter/material.dart';
import 'package:hansoridiscord/screens/ServerChatPage.dart';

class serverConversationList extends StatefulWidget{
  String name;
  String messageText;
  String imageUrl;
  String time;
  int total;
  bool isMessageRead;
  serverConversationList({required this.name,required this.messageText,required this.imageUrl,required this.time,required this.total,required this.isMessageRead});
  @override
  _serverConversationListState createState() => _serverConversationListState();
}

class _serverConversationListState extends State<serverConversationList> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context){
          return ServerChatPage();
        }));
      },
      child: Container(
        padding: EdgeInsets.only(left: 16,right: 16,top: 10,bottom: 10),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage: NetworkImage(widget.imageUrl),
                    maxRadius: 30,
                  ),
                  SizedBox(width: 16,),
                  Expanded(
                    child: Container(
                      color: Colors.transparent,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(widget.name, style: TextStyle(fontSize: 16),),
                          Text(widget.total.toString(), style: TextStyle(fontSize: 13, color: Colors.grey),),
                          SizedBox(height: 6,),
                          Text(widget.messageText,style: TextStyle(fontSize: 13,color: Colors.grey.shade600, fontWeight: widget.isMessageRead?FontWeight.bold:FontWeight.normal),),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Text(widget.time,style: TextStyle(fontSize: 12,fontWeight: widget.isMessageRead?FontWeight.bold:FontWeight.normal),),
          ],
        ),
      ),
    );
  }
}