import 'package:flutter/material.dart';
class GroupInfo extends StatelessWidget {
  const GroupInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return SafeArea(child: Scaffold(
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            BackButton(),
            Container(
               padding: EdgeInsets.all(20),
              child: Row(
                children: [Container(
                  height: size.height/12,
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,color: Colors.grey
                  ),
                  child: Icon(Icons.group,color: Colors.white,size: size.width/10,),
                ),
                SizedBox(width: size.width/20,),
                Text("Group Name",style: TextStyle(fontSize: size.width/16,fontWeight: FontWeight.w500),)],
              ),

            ),
            SizedBox(height: size.height/60,),
            Container(
              width: size.width/1.1,
              padding: EdgeInsets.all(20),
              child: Text("60 Members",style: TextStyle(fontSize: size.width/20,fontWeight: FontWeight.w500),),

            ),
            Flexible(child: ListView.builder(itemCount:10,shrinkWrap: true,itemBuilder: (context,index){
              return ListTile(
                leading: Icon(Icons.account_circle,size: 30,),
                title: Text("User1",style: TextStyle(fontSize: size.width/18,fontWeight: FontWeight.w500),),
              );
            })),
            SizedBox(height: size.height/20,),
            ListTile(
              onTap: (){},
              leading: Icon(Icons.logout),
              title: Text("Leave Group",style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: size.width/22,
                color: Colors.redAccent
              )),
            )
           ],
          ),
      ),
    ));
  }
}
