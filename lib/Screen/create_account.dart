import 'package:chatapp/Screen/homeScreen.dart';
import 'package:chatapp/methods.dart';
import 'package:flutter/material.dart';
class CreateAccount extends StatefulWidget {
  const CreateAccount({super.key});

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
   bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: isLoading?
         Center( child:Container(
            height: size.height/20,
            width: size.width/20,
            alignment: Alignment.center,
            child: CircularProgressIndicator(),
          ))
          :SingleChildScrollView(child:Column(
        children: [
          SizedBox(height: size.height/20,),
          Container(
            alignment: Alignment.centerLeft,
            width: size.width/0.1,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: (){},
            ),
          ),
          SizedBox(height: size.height/50,),
          SizedBox(
            width: size.width/1.2,
            child: const Text(
              "Welcome",style: TextStyle(fontSize: 28,fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            width: size.width/1.2,
            child: const Text(
              "Create Account to continue!",
              style: TextStyle(color: Colors.grey,fontWeight: FontWeight.w500,fontSize: 20),
            ),
          ),
          SizedBox(height: size.height/10,),
          Padding(padding: const EdgeInsets.symmetric(vertical: 18),
              child:Container(
                width: size.width,
                alignment: Alignment.center,
                child: field(size,"Name",Icons.person,_name),
              )),
          Container(
            width: size.width,
            alignment: Alignment.center,
            child: field(size,"email",Icons.account_box,_email),
          ),
          Padding(padding: const EdgeInsets.symmetric(vertical: 18),
              child:Container(
                width: size.width,
                alignment: Alignment.center,
                child: field(size,"password",Icons.lock,_password),
              )),
          SizedBox(height: size.height/20,),
          customButton(size),
          SizedBox(height: size.height/40,),
          GestureDetector(
            onTap: ()=>Navigator.pop(context),
            child: const Text("Login",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500,color: Colors.blue),),
          )

        ],
      ),
    ));
  }
  Widget customButton(Size size){
    return GestureDetector(onTap: (){
      if(_name.text.isNotEmpty&&_email.text.isNotEmpty&&_password.text.isNotEmpty){
        setState(() {
          isLoading = true;

        });
        createAccount(_name.text, _email.text, _password.text).then((user){
          if(user != null){
            setState(() {
              isLoading = false;
            });
            Navigator.push(context, MaterialPageRoute(builder: (_)=>const HomeScreen()));
            print("Account created!");
          }
          else{
            print("Account not create!");
          }
        });
      }else{
        print("Please enter fields");
      }
    },
      child:Container(
      height: size.height/14,
      width: size.width/1.2,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.blue,
      ),
      alignment: Alignment.center,
      child: const Text("Create Account",style:TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold)),
    ));
  }

  Widget field(Size size,String hintText, IconData icon, TextEditingController cont){
    return SizedBox(
      height: size.height/15,
      width: size.width/1.1,
      child: TextField(
        controller: cont,
        decoration: InputDecoration(
            prefixIcon: Icon(icon),
            hintText: hintText,
            hintStyle: const TextStyle(color: Colors.grey),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10)
            )
        ),
      ),
    );
  }
}
