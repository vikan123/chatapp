import 'package:chatapp/Screen/homeScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class CreateGroup extends StatefulWidget {
  final List<Map<String, dynamic>> memberList;
  const CreateGroup({super.key, required this.memberList});

  @override
  State<CreateGroup> createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  final TextEditingController _groupName = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool isLoading = false;

  void createGroup() async {
    String groupId = Uuid().v1();
    setState(() {
      isLoading = true;
    });

    await _firestore
        .collection('groups')
        .doc('groupId')
        .set({"members": widget.memberList, "id": groupId});

    for (int i = 0; i < widget.memberList.length; i++) {
      String uid = widget.memberList[i]['name'];
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('groups')
          .doc(groupId)
          .set({"name": _groupName.text, "id": groupId});
    }
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => HomeScreen()), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(
          title: Text("Group Name"),
        ),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    SizedBox(
                      height: size.height / 10,
                    ),
                    Container(
                      width: size.width / 1.15,
                      height: size.height / 14,
                      alignment: Alignment.center,
                      child: TextField(
                        controller: _groupName,
                        decoration: InputDecoration(
                            hintText: "Enter Group Name",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                      ),
                    ),
                    SizedBox(
                      height: size.height / 30,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          createGroup();
                        },
                        child: Text("Create Group")),
                  ],
                ),
              ));
  }
}
