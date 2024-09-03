import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:msa_project/screens/login.dart';
import 'package:msa_project/screens/userhome.dart';
import 'package:msa_project/widgits/fields.dart';
import 'package:flutter/material.dart';
class signup extends StatefulWidget {
  const signup({super.key});

  @override
  State<signup> createState() => _signupState();
}
CollectionReference users = FirebaseFirestore.instance.collection('users');
class _signupState extends State<signup> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  Future<void> adduser() {
    return users
        .add({
      'username': usernameController.text,
      'phone': phoneController.text,
      'id': FirebaseAuth.instance.currentUser!.uid,
      'statue':'no',
      'line_name':''
    })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }
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
            colors: [Colors.cyan, Colors.purpleAccent]
          ),),
        child:Center(
          child: Container(
            width: 300,
            height: 610,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20,),
                  const Text(
                    'SIGN UP',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize:28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10,),
                  Column(
                    children:[
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CustomTextFormField.log('Username', "Enter Your Username",const Icon(Icons.person),usernameController,false)
                      )
                    ],
                  ),
                  const SizedBox(height: 10,),
                  Column(
                    children:[
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CustomTextFormField.log('email', "Enter Your email",const Icon(Icons.email),emailController,false)
                      )
                    ],
                  ),
                  const SizedBox(height: 10,),
                  Column(
                    children:[
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CustomTextFormField.log('Password', "Enter Your Password",const Icon(Icons.lock),passwordController,true)
                      )
                    ],
                  ),
                  const SizedBox(height: 10,),
                  Column(
                    children:[
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CustomTextFormField.log('confirm password', "confirm your password",const Icon(Icons.password_rounded),confirmPasswordController,true)
                      )
                    ],
                  ),
                  const SizedBox(height: 10,),
                  Column(
                    children:[
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CustomTextFormField.log('phone', "enter your phone number",const Icon(Icons.phone),phoneController,false)
                      )
                    ],
                  ),
                  const SizedBox(height: 5,),
                  Column(
                    children: [
                      SizedBox(
                        width: 250,
                        child: TextButton(
                          onPressed: () async{
                            if(usernameController.text=='' || emailController.text=='' || passwordController.text=='' || confirmPasswordController.text=='' || phoneController.text=='')
                              {
                                AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.error,
                                  animType: AnimType.scale,
                                  title: 'sorry',
                                  desc: 'please fill all fields',
                                  btnOkText: 'Okay',
                                  btnOkOnPress: (){},
                                  btnOkColor: Colors.red,
                                ).show();
                              }
                            else {
                              if (passwordController.text != confirmPasswordController.text)
                              {
                                AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.error,
                                  animType: AnimType.scale,
                                  title: 'sorry',
                                  desc: 'Password and confirm pass not the same',
                                  btnOkText: 'Okay',
                                  btnOkOnPress: () {},
                                  btnOkColor: Colors
                                      .red,
                                ).show();
                              } else {
                                try {
                                  final credential = await FirebaseAuth.instance
                                      .createUserWithEmailAndPassword(
                                    email: emailController.text,
                                    password: passwordController.text,
                                  );
                                  adduser();
                                  Navigator.pushReplacement(context,
                                    MaterialPageRoute(
                                        builder: (context) => user_home()),
                                  );
                                } on FirebaseAuthException catch (e) {
                                  if (e.code == 'weak-password') {
                                    print('The password provided is too weak.');
                                    AwesomeDialog(
                                      context: context,
                                      dialogType: DialogType.warning,
                                      animType: AnimType.scale,
                                      title: 'sorry',
                                      desc: 'The password provided is too weak',
                                      btnOkText: 'Okay',
                                      btnOkOnPress: () {},
                                      btnOkColor: Colors
                                          .red, // Customize OK button text
                                    ).show();
                                  } else if (e.code == 'email-already-in-use') {
                                    print(
                                        'The account already exists for that email.');
                                    AwesomeDialog(
                                      context: context,
                                      dialogType: DialogType.warning,
                                      animType: AnimType.scale,
                                      title: 'sorry',
                                      desc: 'The account already exists for that email',
                                      btnOkText: 'Okay',
                                      btnOkOnPress: () {},
                                      btnOkColor: Colors.red,
                                    ).show();
                                  }
                                } catch (e) {
                                  print(e);
                                }
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
                              child:  Text(
                                'Sign up',
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
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => const login()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purpleAccent,
                      minimumSize: const Size(50, 20),
                    ),
                    child: const Text('cancel',
                      style:TextStyle(color: Colors.white,
                        fontSize: 16,
                      ),),
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