import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:msa_project/screens/adminhome.dart';
import '../widgits/fields.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class adminadd extends StatelessWidget {
  final TextEditingController busLineController = TextEditingController();
  final TextEditingController capacityController = TextEditingController();
  final TextEditingController dropPointController = TextEditingController();
  final TextEditingController reservedController = TextEditingController();
  List reservedUsers = [];
  CollectionReference lines = FirebaseFirestore.instance.collection('lines');

  Future<void> addLine() {
    return lines
        .add({
      'bus_line': busLineController.text,
      'capacity': capacityController.text,
      'drop_point': dropPointController.text,
      'reserved': reservedController.text,
      'reservedUsers': reservedUsers,
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
                    'add new line',
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
                          Row(
                            children: [
                              SizedBox(
                                width:200,
                                child: TextButton(
                                  onPressed: () async{
                                    if(busLineController.text=='' || capacityController.text=='' || dropPointController.text=='' || reservedController.text=='')
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
                                    else{
                                    addLine();
                                    Navigator.pushReplacement(context,
                                      MaterialPageRoute(builder: (context) => admin_home()),
                                    );}
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
                                        'Add',
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
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pushReplacement(context,
                                  MaterialPageRoute(builder: (context) => const admin_home()),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.purpleAccent,
                                minimumSize: const Size(50, 35),
                              ),
                              child: const Text('cancel',
                              style:TextStyle(color: Colors.white,
                                fontSize: 16,
                              ),),
                            ),
                            ],),
                    ],
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