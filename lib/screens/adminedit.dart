import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:msa_project/screens/adminhome.dart';
import 'package:msa_project/screens/login.dart';
import '../widgits/fields.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class adminedit extends StatefulWidget {
  final String docid;
  final String oldbusline;
  final String oldcapacity;
  final String oldDropPoint;
  final String oldReserved;
  final List oldreservedUsers;
  const adminedit({Key? key,
    required this.docid,
    required this.oldbusline,
    required this.oldcapacity,
    required this.oldDropPoint,
    required this.oldReserved,
    required this.oldreservedUsers
  }) : super(key: key);

  @override
  _admineditState createState() => _admineditState();
}

class _admineditState extends State<adminedit> {
  final TextEditingController busLineController = TextEditingController();
  final TextEditingController capacityController = TextEditingController();
  final TextEditingController dropPointController = TextEditingController();
  final TextEditingController reservedController = TextEditingController();
  List<String> reservedUsers = [];
  CollectionReference lines = FirebaseFirestore.instance.collection('lines');
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  Future<void> editLine() {
    return lines.doc(widget.docid).update({
      'bus_line': busLineController.text,
      'capacity': capacityController.text,
      'drop_point': dropPointController.text,
      'reserved': reservedController.text,
      'reservedUsers':reservedUsers,
    })
        .then((value) => print("Line edited"))
        .catchError((error) => print("Failed to edit line: $error"));
  }
   editstat(String nameuser) async{
     QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
         .collection('users')
         .where('username', isEqualTo: nameuser)
         .get();
     if(querySnapshot.docs.isNotEmpty) {
       DocumentSnapshot<Map<String, dynamic>> UDoc = querySnapshot.docs.first;
       await UDoc.reference.update({'statue': "no"});
     }
  }
  @override
  void initState() {
    super.initState();
    busLineController.text=widget.oldbusline;
    capacityController.text=widget.oldcapacity;
    dropPointController.text=widget.oldDropPoint;
    reservedController.text=widget.oldReserved;
    reservedUsers=List.from(widget.oldreservedUsers);
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
            colors: [Colors.cyan, Colors.purpleAccent],
          ),),
        child:Center(
          child: Container(
            width: 300,
            height: 500,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20,),
                  const Text(
                    'edit line',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize:22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10,),
                  Column(
                    children:[
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CustomTextFormField.log('bus Line', "Enter the bus Line",const Icon(Icons.bus_alert),busLineController,false)
                      )
                    ],
                  ),
                  const SizedBox(height: 10,),
                  Column(
                    children:[
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CustomTextFormField.log('capacity', "Enter the capacity",const Icon(Icons.numbers),capacityController,false)
                      )
                    ],
                  ),
                  const SizedBox(height: 10,),
                  Column(
                    children:[
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CustomTextFormField.log('drop point', "Enter the drop point",const Icon(Icons.location_on),dropPointController,false)
                      )
                    ],
                  ),
                  const SizedBox(height: 10,),
                  Column(
                    children:[
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CustomTextFormField.log('reserved', "number of reserved",const Icon(Icons.numbers),reservedController,false)
                      )
                    ],
                  ),
                  const SizedBox(height: 10,),
                  Column(
                    children: [
                      SizedBox(
                        width: 250,
                        child: TextButton(
                          onPressed: () async{
                            editLine();
                            Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) => admin_home()),
                            );
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
                                colors: [Colors.cyan, Colors.purpleAccent],
                                begin: Alignment.topLeft,
                                end: Alignment.topRight,
                              ),
                            ),
                            child: const Center(
                              child:  Text(
                                'edit',
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
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      const Text(
                        'Reserved Users:',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: reservedUsers.length,
                        itemBuilder: (BuildContext context, int k) {
                          return ListTile(
                            leading: const Icon(Icons.person),
                            title: Text(
                              reservedUsers[k],
                              style: const TextStyle(fontSize: 16.0),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                editstat(reservedUsers[k]);
                                setState(() {
                                  reservedUsers.removeAt(k);
                                });
                                Navigator.pop(context);
                              },
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 10.0),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Close'),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        backgroundColor: Colors.yellow,
        child: const Icon(Icons.person_pin_outlined),
      ),
    );
  }
}