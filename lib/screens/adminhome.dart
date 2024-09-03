import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:msa_project/screens/adminadd.dart';
import 'package:msa_project/screens/adminedit.dart';
import 'login.dart';

class admin_home extends StatefulWidget {
  const admin_home({Key? key}) : super(key: key);
  @override
  State<admin_home> createState() => _State();
}
class _State extends State<admin_home> {
  List bus = [];
  String delline='';
  getData() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection(
        'lines').get();
    bus.addAll(querySnapshot.docs);
    setState(() {});
  }
  deltline(String delline) async{
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('line_name', isEqualTo: delline)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      List<DocumentSnapshot<Map<String, dynamic>>> userDocs = querySnapshot.docs;

      for (DocumentSnapshot<Map<String, dynamic>> doc in userDocs) {
        await doc.reference.update({'statue': "no"});
        await doc.reference.update({'line_name':''});
      }
    }
  }
  void initState() {
    super.initState();
    getData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Lines',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),),
        centerTitle: true,
        backgroundColor:const Color(0xFFA0E9FF),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushReplacement(context,
                MaterialPageRoute(
                    builder: (context) => const login()),
              );
            },
            icon: const Icon(Icons.exit_to_app),
          ),
        ],
      ),
      backgroundColor: const Color(0xFFA0E9FF),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
          childAspectRatio: 2.2,
        ),
        itemCount: bus.length,
        itemBuilder: (BuildContext context, int i) {
          return Card(
            color: const Color(0xFF00A9FF),
            elevation: 5.0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                        Text(
                          'Line: ${bus[i]['bus_line']}',
                          style: const TextStyle(fontSize: 18.0,color: Color(0xFFCDF5FD),),
                        ),
                        Text(
                          'Capacity: ${bus[i]['capacity']}',
                          style: const TextStyle(fontSize: 18.0,color: Color(0xFFCDF5FD),),
                        ),
                        Text(
                          'Drop Point: ${bus[i]['drop_point']}',
                          style: const TextStyle(fontSize: 18.0,color: Color(0xFFCDF5FD),),
                        ),
                    Text(
                      'Reserved Seats: ${bus[i]['reserved']}',
                      style: const TextStyle(fontSize: 18.0,color: Color(0xFFCDF5FD),),
                    ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (context) => adminedit(docid: bus[i].id,oldbusline: bus[i]['bus_line'], oldcapacity: bus[i]['capacity'], oldDropPoint: bus[i]['drop_point'], oldReserved: bus[i]['reserved'], oldreservedUsers: bus[i]['reservedUsers'],)),
                              );
                            },
                            child: const Text('Edit'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.warning,
                                  animType: AnimType.scale,
                                  title: 'Warning',
                                  desc: 'Are you sure you want to delete this line',
                                  btnOkText: 'Yes',
                                  btnCancelText: 'Cancel',
                                  btnCancelOnPress: (){
                                  },
                                  btnOkColor: Colors.red,
                                  btnCancelColor: Colors.green,
                                  btnOkOnPress: ()async{
                                    delline=bus[i]['bus_line'];
                                    await FirebaseFirestore.instance.collection('lines').doc(bus[i].id).delete();
                                    deltline(delline);
                                    Navigator.pushReplacement(context,
                                      MaterialPageRoute(
                                          builder: (context) => const admin_home()),
                                    );
                                  },
                              ).show();
                            },
                            child: const Text('Delete'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              List<dynamic> reservedUsers = List.from(bus[i]['reservedUsers'] ?? []);
                              String usersString = reservedUsers.join('\n');
                              showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context) {
                                  return Container(
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
                                        Text(
                                          usersString,
                                          style: const TextStyle(
                                            fontSize: 16.0,
                                          ),
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
                                  );
                                },
                              );
                            },
                            child: const Text('users'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => adminadd()),
          );
        },
        backgroundColor: const Color(0xFF89CFF3),
        child: const Icon(Icons.add),
      ),
    );
  }
}
