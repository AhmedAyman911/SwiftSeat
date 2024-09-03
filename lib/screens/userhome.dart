import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:msa_project/screens/login.dart';

class user_home extends StatefulWidget {
  const user_home({Key? key}) : super(key: key);
  @override
  State<user_home> createState() => _State();
}
class _State extends State<user_home> {
  List bus = [];
  List users = [];
  String name='';
  String phone='';
  String statue='';
  String thename='';
  getData() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection(
        'lines').get();
    bus.addAll(querySnapshot.docs);
    setState(() {});
  }
  getUsers() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection(
        'users').get();
    users.addAll(querySnapshot.docs);
    setState(() {});
  }
  getname(){
    for(int i=0;i<users.length;i++)
      {
        if(users[i]['id'] == FirebaseAuth.instance.currentUser!.uid)
        {
            name=users[i]['username'];
            phone=users[i]['phone'];
            statue=users[i]['statue'];
            break;
        }
    }
  }
  updatestate(){
    CollectionReference user = FirebaseFirestore.instance
        .collection('users');
    for(int i=0;i<users.length;i++)
    {
      if(users[i]['id'] == FirebaseAuth.instance.currentUser!.uid)
      {
        user.doc(users[i].id).update({
          'statue': 'yes',
        }).then((value) {
          print("User statue updated");},
        ).catchError((error) =>
            print('Failed to update statue: $error'));
      }
    }
  }
  linetoUser(linen){
    CollectionReference user = FirebaseFirestore.instance
        .collection('users');
    for(int i=0;i<users.length;i++)
    {
      if(users[i]['id'] == FirebaseAuth.instance.currentUser!.uid)
      {
        user.doc(users[i].id).update({
          'line_name': linen,
        }).then((value) {
          print("User statue updated");},
        ).catchError((error) =>
            print('Failed to update statue: $error'));
      }
    }
  }
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    await getUsers();
    getname();
    getData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome $name',
          style: const TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Color(0xFFE26EE5),
          ),),
        centerTitle: true,
        backgroundColor:const Color(0xFF49108B),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushReplacement(context,
                MaterialPageRoute(
                    builder: (context) => const login()),
              );
            },
            icon: const Icon(Icons.exit_to_app),
            color:const Color(0xFFE26EE5),
          ),
        ],
      ),
      backgroundColor:const Color(0xFF49108B),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
          childAspectRatio: 2.1,
        ),
        itemCount: bus.length,
        itemBuilder: (BuildContext context, int i) {
          return Card(
            color: const Color(0xFF7E30E1),
            elevation: 5.0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                       CircleAvatar(
                        radius: 25,
                           backgroundImage: int.parse(bus[i]['capacity']) < 21
                              ? const AssetImage('assets/mini.png') : const AssetImage('assets/bus.png')
                      ),
                      const SizedBox(width: 10,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Line: ${bus[i]['bus_line']}',
                            style: const TextStyle(fontSize: 18.0,color: Colors.yellow),
                          ),
                          Text(
                            'Capacity: ${bus[i]['capacity']}',
                            style: const TextStyle(fontSize: 18.0,color: Colors.yellow),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10,),
                  Text(
                    'Drop Point: ${bus[i]['drop_point']}',
                    style: const TextStyle(fontSize: 18.0,color: Colors.yellow),
                  ),
                  Text(
                    'Reserved Seats: ${bus[i]['reserved']}',
                    style: const TextStyle(fontSize: 18.0,color: Colors.yellow),
                  ),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        if(statue=='no')
                          {
                            if(int.parse(bus[i]['reserved'])<int.parse(bus[i]['capacity']))
                            {
                              int newres = int.parse(bus[i]['reserved']);
                              newres += 1;
                              List<dynamic> reservedUsers = List.from(bus[i]['reservedUsers'] ?? []);
                              reservedUsers.add(name);
                              CollectionReference lines = FirebaseFirestore.instance
                                  .collection('lines');
                              lines.doc(bus[i].id).update({
                                'reserved': newres.toString(),
                                'reservedUsers':reservedUsers,
                              }).then((value) {
                                print("User booked");},
                              );
                              updatestate();
                              statue='yes';
                              thename=bus[i]['bus_line'];
                              linetoUser(thename);
                              AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.success,
                                  animType: AnimType.scale,
                                  title: 'Thank you',
                                  desc: 'see you there',
                                  btnOkText: 'Nice',
                                  btnOkOnPress: (){
                                    Navigator.pushReplacement(context,
                                      MaterialPageRoute(
                                          builder: (context) => const user_home()),
                                    );
                                  }
                              ).show();
                            }
                            else
                            {
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.warning,
                                animType: AnimType.scale,
                                title: 'sorry',
                                desc: 'this bus is full',
                                btnOkText: 'Okay',
                                btnOkOnPress: (){},
                                btnOkColor: Colors.red,
                              ).show();
                            }
                          }else{
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.error,
                            animType: AnimType.scale,
                            title: 'sorry',
                            desc: 'You are already booked a line',
                            btnOkText: 'Okay',
                            btnOkOnPress: (){},
                            btnOkColor: Colors.red,
                          ).show();
                        }
                      },
                      child: Text('Book'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
