import 'dart:convert';

import 'package:essa_attendence/widgets/drawer.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class VisitReportScreen extends StatefulWidget {
 late String _usrid,_empMobile,_empemail;
 VisitReportScreen(String usrid,String empMobile,String empemail){
   _usrid = usrid;
   _empMobile = empMobile;
   _empemail = empemail;
 }
  @override
  State<VisitReportScreen> createState() => _VisitReportScreenState();
}

class _VisitReportScreenState extends State<VisitReportScreen> {
  late Future<List<dynamic>?> _dataFuture;
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
        title: Text('Visits Report',style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.blue.shade800,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      drawer: MyDrawer(widget._usrid,widget._empMobile,widget._empemail),
      body:FutureBuilder<List<dynamic>?>(
        future: _dataFuture,
        builder: (ctx,snapshot){
          print("data: ${snapshot.data}");
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(child: CircularProgressIndicator(),);

          }
          else if(snapshot.hasError){
            return Center(child: Text('Data Not Found'),);

          }
          else{
            return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (ctx,index){
                  return Card(
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.4,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: [
                          ListTile(
                            leading: const Text("Name:"),
                            trailing: Text(widget._usrid),
                          ),
                          ListTile(
                            leading: const Text("Visit Name:"),
                            trailing: Text(snapshot.data![index]['abkname']),
                          ),
                          ListTile(
                            leading: const Text("Date:"),
                            trailing: Text(snapshot.data![index]['t_chkdt']),
                          ),
                          ListTile(
                            leading: const Text("Time In:"),
                            trailing: Text(snapshot.data![index]['t_timein']),
                          ),
                          ListTile(
                            leading: const Text("Time Out:"),
                            trailing: Text(snapshot.data![index]['t_timeout']),
                          ),
                        ],
                      ),
                    ),
                  );

                });
          }


        },
      ),
    );
  }
  Future<List<dynamic>?> _fetchData() async{
    try{
      var response = await http.get(Uri.http("194.163.166.163:1251","/ords/sc_attendence/attn/visitor_rep",{"usrid" : widget._usrid}));
      int statusCode = response.statusCode;
      print(statusCode);
      if(statusCode == 200){
        var data = jsonDecode(response.body);
        print("data1 : ${data["items"]}");
        return data["items"];
      }
      return null;
    }
    catch(e){
      print(e.toString());
      return null;
    }
  }
}
