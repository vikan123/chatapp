import 'package:chatapp/group_chat/group_info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GroupChatRoom extends StatelessWidget {
  GroupChatRoom({super.key});

  final TextEditingController _message = TextEditingController();
  String currentUsername = "User";
  List<Map<String, dynamic>> dummyChatList = [
    {"message": "User1 created this Group", "type": "notify"},
    {"message": "Hello this is user 1", "sendby": "User", "type": "text"},
    {"message": "Hello this is user 2", "sendby": "User2", "type": "text"},
    {"message": "Hello this is user 3", "sendby": "User3", "type": "text"},
    {"message": "Hello this is user 4", "sendby": "User4", "type": "text"},
    {"message": "Hello this is user 7", "sendby": "User7", "type": "text"},
    {"message":"User1 Added User8","type":"notify"}
  ];



  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Group Name"),
        actions: [IconButton(onPressed: () =>Navigator.of(context).push(MaterialPageRoute(builder: (_)=>const GroupInfo())), icon: const Icon(Icons.more_vert))],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: size.height / 1.27,
              width: size.width,
              child: ListView.builder(
                  itemCount: dummyChatList.length,
                  itemBuilder: (context, index) {
                    return messageTile(size, dummyChatList[index]);
                  }),
            ),
            Container(
              height: size.height / 10,
              width: size.width,
              alignment: Alignment.center,
              child: SizedBox(
                height: size.height / 20,
                width: size.width / 1.1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: size.height / 12,
                      width: size.width / 1.3,
                      child: TextField(
                        controller: _message,
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.photo),
                            ),
                            hintText: "Messages",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            )),
                      ),
                    ),
                    IconButton(onPressed: () {}, icon: const Icon(Icons.send))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget messageTile(Size size, Map<String,dynamic> chatMap){
    return Builder(builder: (_) {
     if(chatMap['type'] == "text"){
       return Container(
         width: size.width,
         alignment: chatMap['sendby'] == currentUsername ? Alignment
             .centerRight :
         Alignment.centerLeft,
         padding: EdgeInsets.symmetric(
             vertical: size.height / 175, horizontal: size.width / 80),
         child: Container(
           padding: const EdgeInsets.symmetric(
               vertical: 14, horizontal: 8),
           margin: const EdgeInsets.symmetric(
               vertical: 1, horizontal: 5),
           decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),
               color: Colors.blue),
           child: Column(crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               Text(chatMap['sendby'],style: const TextStyle(fontSize: 12,color: Colors.black45),),
               SizedBox(height: size.height/200,),
               Text(chatMap['message'],
                 style: const TextStyle(color: Colors.white,
                     fontSize: 18,
                     fontWeight: FontWeight.w600),),
             ],
           )
         ),
       );
     }
     else if(chatMap['type'] == "img"){
       return Container(
         width: size.width,
         alignment: chatMap['sendby'] == currentUsername ? Alignment
             .centerRight :
         Alignment.centerLeft,
         padding: EdgeInsets.symmetric(
             vertical: size.height / 175, horizontal: size.width / 80),
         child: Container(
           padding: const EdgeInsets.symmetric(
               vertical: 14, horizontal: 8),
           margin: const EdgeInsets.symmetric(
               vertical: 1, horizontal: 8),
           height: size.height/2,
           child: Image.network(chatMap['message'])
       ));
     }
     else if(chatMap['type'] == "notify"){
       return Container(
           width: size.width,
           alignment: Alignment.center,
           child: Container(
             margin: const EdgeInsets.symmetric(vertical: 5,horizontal: 8),
               padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 14),
               decoration: BoxDecoration(
                 borderRadius: BorderRadius.circular(20),
                 color: Colors.grey
               ),
               child: Text(chatMap['message'],
                 style: const TextStyle(color: Colors.white,
                     fontSize: 14,
                     fontWeight: FontWeight.bold),),
           ));
     }
     return const SizedBox();
    });
  }
}

