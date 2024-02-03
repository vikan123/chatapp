import 'package:chatapp/group_chat/group_chat_screen.dart';
import 'package:chatapp/methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'chatRoom.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver{
  bool isLoading = false;
   Map<String,dynamic> ?userMap;
  final TextEditingController _search = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    setStatus("Online");
  }

  void setStatus(String status) async
  {
    await _firestore.collection('users').doc(_auth.currentUser!.uid).update(
        {
          "status":status
        });
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state){
    if(state == AppLifecycleState.resumed){
      setStatus("Online");
    }else
      {
        setStatus("Offline");
      }
  }




  String chatRoomId(String user1, String user2){
    if(user1[0].toLowerCase().codeUnits[0]> user2.toLowerCase().codeUnits[0]){
      return "$user1$user2";
    }
    else
      return "$user2$user1";
  }

  void onSearch() async {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    setState(() {
      isLoading = true;
    });

    await _firestore
        .collection('users')
        .where("email", isEqualTo: _search.text)
        .get()
        .then((value) {
          setState(() {
            userMap = value.docs[0].data();
            isLoading = false;
          });
         print(userMap);

    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Screen"),
        actions: [
          IconButton(onPressed: ()=>logOut(context), icon: const Icon(Icons.logout))
        ],
      ),
      body: isLoading
          ? Center(
              child: Container(
                height: size.height / 20,
                width: size.width / 20,
                child: const CircularProgressIndicator(),
              ),
            )
          : Column(
              children: [
                SizedBox(
                  height: size.height / 20,
                ),
                Container(
                  width: size.width / 1.15,
                  height: size.height / 14,
                  alignment: Alignment.center,
                  child: TextField(
                    controller: _search,
                    decoration: InputDecoration(
                        hintText: "Search",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                ),
                SizedBox(
                  height: size.height / 30,
                ),
                ElevatedButton(
                    onPressed: () {
                      onSearch();
                    },
                    child: const Text("Search")),
                SizedBox(height: size.height/30,),
                userMap != null?ListTile(
                  onTap: (){

                    String roomId = chatRoomId(_auth.currentUser!.displayName.toString(), userMap?['name']);
                    Navigator.push(context, MaterialPageRoute(builder: (_)=>ChatRoom(
                      chatRoomId:roomId, userMap:userMap!)
                    ));
                  },
                  leading: const Icon(Icons.account_box,color: Colors.black,),
                  title: Text(userMap!['name'],style: const TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 17),),
                  subtitle: Text(userMap!['email']),
                  trailing: const Icon(Icons.chat,color: Colors.black,),
                ):Container()
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()=>Navigator.push(context,MaterialPageRoute(builder: (_)=>const GroupChatHomeScreen())),
        child: const Icon(Icons.group),
        
      ),
    );
    
  }

}




