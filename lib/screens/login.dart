import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:msa_project/screens/adminhome.dart';
import 'package:msa_project/screens/signup.dart';
import 'package:msa_project/screens/userhome.dart';
import 'package:msa_project/widgits/fields.dart';
import 'package:flutter/material.dart';
import 'package:msa_project/screens/adminadd.dart';

class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  @override
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  TextEditingController adminNameController = TextEditingController();
  TextEditingController adminpassController = TextEditingController();

  bool _isObscured = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.transparent,
      body:Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            colors: [Colors.cyan, Colors.purpleAccent],
          ),),
        child:Center(
          child: SingleChildScrollView(
            child: Container(
              width: 300,
              height: 500,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  //const SizedBox(height: 5,),
                  const Icon(Icons.person,size: 100,),
                  const Text(
                    'LOGIN',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize:28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5,),
                  Column(
                    children:[
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CustomTextFormField.log('Email', "Enter Your email",const Icon(Icons.person),emailController,false)
                      )
                    ],
                  ),
                  const SizedBox(height: 10,),
                  Column(
                    children:[
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CustomTextFormField.pas('Password', "Enter Your Password",const Icon(Icons.lock),passwordController,
                            _isObscured,
                                (bool value) {
                              setState(() {
                                _isObscured = value;
                              });
                            },
                          )
                      ),
                    ],
                  ),
                  const SizedBox(height: 10,),
                  Column(
                    children: [
                      SizedBox(
                        width: 250,
                        child: TextButton(
                          onPressed: () async {
                            try {
                              final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                                email: emailController.text,
                                password: passwordController.text,
                              );
                              if (credential.user != null) {
                                Navigator.pushReplacement(context,
                                  MaterialPageRoute(builder: (context) => user_home()),
                                );
                              }
                            } on FirebaseAuthException catch (e) {
                              print(e);
                              if (emailController.text == '') {
                                AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.warning,
                                  animType: AnimType.scale,
                                  title: 'Sorry',
                                  desc: 'you have to fill your info',
                                  btnOkText: 'Okay',
                                  btnOkOnPress: () {},
                                  btnOkColor: Colors.red,
                                ).show();
                              }else{
                                AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.error,
                                  animType: AnimType.scale,
                                  title: 'Sorry',
                                  desc: 'Wrong Email or password provided for that user.',
                                  btnOkText: 'Okay',
                                  btnOkOnPress: () {},
                                  btnOkColor: Colors.red,
                                ).show();
                              }
                            }
                          },
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                          ),
                          child: Container(
                            width: double.infinity,
                            height: 35,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              gradient: const LinearGradient(
                                colors: [Colors.cyan, Colors.purpleAccent], // Gradient colors
                                begin: Alignment.topLeft,
                                end: Alignment.topRight,
                              ),
                            ),
                            child: const Center(
                              child: Text(
                                'Login',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10,),
                  const Column(
                    children: [
                      Text('Or signup here',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 10,),
                  Column(
                  children: [
                    GestureDetector(
                      onTap: (){
                        Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => signup()),
                        );
                      },
                     child:const Text(
                      'Sign Up',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 11,
                        ),
                      ),
                    ),]
                  ),
                  SingleChildScrollView(
                    child: Column(
                        children: [
                          Row(
                            children: [
                              const SizedBox(height: 70,),
                              const SizedBox(width: 125,),
                              const Text(
                                'Admin:',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 11,
                                ),
                              ),
                              IconButton(onPressed:(){
                                showModalBottomSheet(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Container(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children:[
                                         Row(
                                           children: [
                                             Container(
                                               width:180,
                                               child: TextFormField(
                                                 controller: adminNameController,
                                                 decoration:const InputDecoration(
                                                   labelText: "Admin name",
                                                   border: OutlineInputBorder(),
                                                 ),
                                               ),
                                             ),
                                              const SizedBox(width: 15,),
                                              Container(
                                                width:150,
                                                child: TextFormField(
                                                  controller: adminpassController,
                                                obscureText: true,
                                                decoration: const InputDecoration(
                                                labelText: "Admin password",
                                                border: OutlineInputBorder(),
                                                ),
                                                ),
                                              ),
                                           ],
                                         ),
                                          ElevatedButton(
                                            onPressed: () {
                                              if(adminNameController.text=='admin'&&adminpassController.text=='123'){
                                                Navigator.pushReplacement(context,
                                                    MaterialPageRoute(builder: (context) => const admin_home()));
                                              }
                                              else{
                                                AwesomeDialog(
                                                  context: context,
                                                  dialogType: DialogType.error,
                                                  animType: AnimType.scale,
                                                  title: 'Are you kidding me',
                                                  desc: 'you Are Not Admin',
                                                  btnOkText: 'Okay',
                                                  btnOkOnPress: () {},
                                                  btnOkColor: Colors.red,
                                                ).show();
                                              }
                                            },
                                            style:ElevatedButton.styleFrom(
                                              backgroundColor: Colors.black,
                                              foregroundColor: Colors.white,
                                            ),
                                            child:const Text('Login'),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              ///////////
                                /**/
                              },icon:const Icon(Icons.person_pin_outlined),),
                            ],
                          ),
                        ]
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}