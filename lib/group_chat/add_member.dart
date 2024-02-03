import 'package:chatapp/group_chat/creategroup.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class AddMembersInGroup extends StatefulWidget {
  const AddMembersInGroup({super.key});

  @override
  State<AddMembersInGroup> createState() => _AddMembersInGroupState();
}

class _AddMembersInGroupState extends State<AddMembersInGroup> {
  final TextEditingController _search = TextEditingController();
  List<Map<String,dynamic>> memberList=[];
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoading = false;
  Map<String,dynamic> ?userMap;
 final  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUserDetails();
  }

  void getCurrentUserDetails() async{
    await _firestore.collection('user').doc(_auth.currentUser!.uid).get().then((map){
      setState(() {
        memberList.add({
          "name":map['name'],
          "email":map['email'],
          "uid":map['uid'],
          "isAdmin":true
        });
      });

    });
  }

  void onSearch() async {

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

  void onResultTap(){
    bool isAlreadyExist = false;
  for(int i=0;i<memberList.length;i++){
    if(memberList[i]['name'] == userMap!['name']){
      isAlreadyExist = true;
    }
  }
  if(!isAlreadyExist){
    setState(() {
      memberList.add({
        "name":userMap!['name'],
        "email":userMap!['email'],
        "uid":userMap!['uid'],
        "isAdmin":false
      });
      userMap = null;
    });
  }

  }



  void onRemove(int index){
    if(memberList[index]['name'] != _auth.currentUser!.uid) {
      setState(() {
        memberList.removeAt(index);
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Members"),
      ),
      body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                    child: ListView.builder(
                        itemCount: memberList.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return ListTile(
                            onTap: (){
                              onRemove(index);
                            },
                            leading: const Icon(Icons.account_circle),
                            title: Text(memberList[index]['name']),
                            subtitle: Text(memberList[index]['email']),
                            trailing: const Icon(Icons.close),
                          );
                        })),
                Container(
                  width: size.width / 1.2,
                  height: size.height / 10,
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
                isLoading?Container(
                  height: size.height/12,
                  width: size.width/12,
                  alignment: Alignment.center,
                  child: const CircularProgressIndicator(),
                ):
                ElevatedButton(onPressed: (){
                  onSearch();
                }, child: const Text("Search")),
                userMap != null?ListTile(
                  onTap: (){
                    onResultTap();
                  },
                  title: Text(userMap!['name']),
                  subtitle: Text(userMap!['email']),
                  leading: const Icon(Icons.account_box),
                  trailing: const Icon(Icons.add),
                ):const SizedBox()
              ],
            ),
          )),
      floatingActionButton: memberList.length>=2?FloatingActionButton(
        child: const Icon(Icons.forward),
        onPressed: ()=>Navigator.of(context).push(MaterialPageRoute(builder: (_)=> CreateGroup(memberList: memberList,))),
      ):const SizedBox(),
    );
  }
}



