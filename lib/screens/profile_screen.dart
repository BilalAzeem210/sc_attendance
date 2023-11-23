import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:essa_attendence/widgets/drawer.dart';
import 'package:flutter/material.dart';


class ProfileScreen extends StatefulWidget {
  late String _userId,_empemail,_empMobile;
  ProfileScreen(String userId,String empemail,String empMobile, {super.key}){
    _userId = userId;
    _empemail = empemail;
    _empMobile = empMobile;
  }
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<Map<String, dynamic>?> _dataFuture;
  @override
  void initState() {
    // TODO: implement initState
    _dataFuture = _fetchData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Screen',style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.blue.shade800,
        iconTheme: IconThemeData(color: Colors.white),


      ),
      drawer: MyDrawer(widget._userId,widget._empemail,widget._empMobile),
      body: Padding(
            padding: EdgeInsets.all(8.0),
            child: Card(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.8,
                width: MediaQuery.of(context).size.width,
                child: FutureBuilder<Map<String,dynamic>?>(
                  future: _dataFuture,
                    builder: (ctx , snapshot){
                    if (snapshot.hasData && snapshot.data != null) {
                      Map<String, dynamic> data = snapshot.data!;
                      return SingleChildScrollView(
                          child: Column(
                            children: [
                              const Text('YOUR INFORMATION', style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold
                              ),),
                              const SizedBox(height: 5,),

                              ListTile(
                                leading: const Text("Name:"),
                                trailing: Text(data["empname"]),
                              ),
                              ListTile(
                                leading: const Text("Department:"),
                                trailing: Text(data["dptname"]),
                              ),
                              ListTile(
                                leading: const Text("Designation:"),
                                trailing: Text(data["dsgdsc"]),
                              ),
                              ListTile(
                                leading: const Text("Mobile no:"),
                                trailing: Text(widget._empMobile),
                              ),
                              ListTile(
                                leading: const Text("Present:"),
                                trailing: Text(data["c_present"].toString()),
                              ),
                              ListTile(
                                leading: const Text("Rest:"),
                                trailing: Text(data["c_rest"].toString()),
                              ),
                              ListTile(
                                leading: const Text("Absent:"),
                                trailing: Text(data["c_absent"].toString()),
                              ),
                              ListTile(
                                leading: const Text("Leave:"),
                                trailing: Text(data["c_leave"].toString()),
                              ),
                              ListTile(
                                leading: const Text("Late:"),
                                trailing: Text(data["c_latein"].toString()),
                              ),
                              ListTile(
                                leading: const Text("Over time:"),
                                trailing: Text(data["t_ovthrs"].toString()),
                              ),
                            ],
                          ),
                        );
                    }
                    return const Center(child: Text('Data Not Found'),);
                  }
                ),
              ),
            )
            ),
    );
  }
  Future<Map<String, dynamic>?> _fetchData() async{
    try{
      var response = await http.get(Uri.http("194.163.166.163:1251","/ords/sc_attendence/attn/employee_info",{"usrid" : widget._userId, "monid" : "202107"}));
      int statusCode = response.statusCode;
      print(statusCode);
      if(statusCode == 200){
        var data = jsonDecode(response.body);
        print("data : ${data["items"][0]}");
        return data["items"][0];
      }
      return null;
    }
    catch(e){
      print(e.toString());
      return null;
    }
  }
}
