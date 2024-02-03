import 'package:chatapp/group_chat/add_member.dart';
import 'package:chatapp/group_chat/group_chat_room.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GroupChatHomeScreen extends StatefulWidget {
  const GroupChatHomeScreen({super.key});

  @override
  State<GroupChatHomeScreen> createState() => _GroupChatHomeScreenState();
}

class _GroupChatHomeScreenState extends State<GroupChatHomeScreen> {
  List groupList = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAvailableGroups();
  }

  void getAvailableGroups() async {
    await _firestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .collection('groups')
        .get()
        .then((value) {
          setState(() {
            groupList = value.docs;
            isLoading = false;
          });

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Groups"),
      ),
      body:isLoading?const Center(child: CircularProgressIndicator()) :ListView.builder(
          itemCount: groupList.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return ListTile(
              onTap: () => Navigator.push(
                  context, MaterialPageRoute(builder: (_) => GroupChatRoom())),
              leading: const Icon(Icons.group),
              title: Text(groupList[index]['name']),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) =>  const AddMembersInGroup())),
        tooltip: "Create Group",
        child: const Icon(
          Icons.create,
          color: Colors.black,
        ),
      ),
    );
  }
}
