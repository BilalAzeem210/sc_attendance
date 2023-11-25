import 'dart:async';

import 'package:essa_attendence/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../provider/n_attendence_provider.dart';
import '../widgets/drop_down.dart';
import 'login.dart';

class NoAttendanceScreen extends StatefulWidget {
  late String _userId,_empemail,_empmobile;
  NoAttendanceScreen(String userId,String empEmail,String empMobile){
    this._userId = userId;
    this._empemail = empEmail;
    this._empmobile = empMobile;
  }
  @override
  State<NoAttendanceScreen> createState() => _NoAttendanceScreenState();
}

class _NoAttendanceScreenState extends State<NoAttendanceScreen> {
  ValueNotifier<bool> _isFetchingStarted = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    bool isFirstTime = true;
    Size size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      floatingActionButton: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue.shade800
        ),
        onPressed: () {
          showModalBottomSheet(context: context, builder: (ctx) {
            return Container(
              height: size.height * 0.6,
              width: size.width,
              child: MyDropDown(widget._userId, _startFetchingData),
            );
          },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(topRight: Radius.circular(45),
                      topLeft: Radius.circular(45))
              )
          );
        },
        child: Text("Check your attendence",style: TextStyle(color: Colors.white),),
      ),
      appBar: AppBar(
        title: Text("Attendance Report",style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.blue.shade800,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      drawer: MyDrawer(widget._userId,widget._empemail,widget._empmobile),
      body: Container(
        width: size.width,
        height: size.height,
        child: FutureBuilder<List<dynamic>>(
          future: Provider.of<NAttendenceProvider>(context, listen: false)
              .downloadDataForFirsttime(7, widget._userId),
          builder: (ctx, snapshot) {
            if (ConnectionState.waiting == snapshot.connectionState) {
              return Center(
                child: CircularProgressIndicator(color: Colors.blue.shade800,),
              );
            }
            else {
              return Consumer<NAttendenceProvider>(
                builder: (ctx, data, ch) {
                  if (_isFetchingStarted.value) {
                    _isFetchingStarted.value = false;
                  }
                  return ValueListenableBuilder(
                      valueListenable: _isFetchingStarted,
                      builder: (ctx, value, ch) {
                        if (snapshot.hasData && isFirstTime) {
                          print("dataFirstTime : ${snapshot.data}");
                          isFirstTime = false;
                          return ListView.builder(itemBuilder: (ctx, position) {
                            return Container(
                              height: MediaQuery
                                  .of(context)
                                  .size
                                  .height * 0.35,
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width,
                              child: Card(
                                elevation: 10,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)
                                ),
                                child: Column(
                                  children: <Widget>[
                                    ListTile(
                                      leading: Text("Checkdate"),
                                      trailing: Text(
                                          snapshot.data![position]["t_chkdt"]),
                                    ),
                                    ListTile(
                                      leading: Text("Timein"),
                                      trailing: Text(
                                          snapshot.data![position]["t_timein"]),
                                    ),
                                    ListTile(
                                      leading: Text("Timeout"),
                                      trailing: Text(snapshot
                                          .data![position]["t_timeout"]),
                                    ),
                                    ListTile(
                                      leading: Text("Place"),
                                      trailing: Text(
                                          snapshot.data![position]["abkname"]),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                            itemCount: snapshot.data!.length,
                          );
                        }
                        else if (value) {
                          print("fetching...");
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        else {
                          List<dynamic> attendences = data.getNAttendences;
                          return ListView.builder(itemBuilder: (ctx, position) {
                            Container(
                              height: MediaQuery
                                  .of(context)
                                  .size
                                  .height * 0.35,
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width,
                              child: Card(
                                elevation: 10,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)
                                ),
                                child: Column(
                                  children: <Widget>[
                                    ListTile(
                                      leading: Text("Checkdate"),
                                      trailing: Text(
                                          attendences[position]["t_chkdt"]),
                                    ),
                                    ListTile(
                                      leading: Text("Timein"),
                                      trailing: Text(
                                          attendences[position]["t_timein"]),
                                    ),
                                    ListTile(
                                      leading: Text("Timeout"),
                                      trailing: Text(
                                          attendences[position]["t_timeout"]),
                                    ),
                                    ListTile(
                                      leading: Text("Place"),
                                      trailing: Text(
                                          attendences[position]["abkname"]),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                            itemCount: attendences.length,
                          );
                        }
                      });
                },
              );
            }
          },
        ),
      ),
    );
  }
  void _startFetchingData(String noOfDays){
    _isFetchingStarted.value = true;
    Timer(Duration(seconds: 2), (){
      // fetch data from provider
      Provider.of<NAttendenceProvider>(context, listen: false).downloadData(int.parse(noOfDays), widget._userId);
    });
  }
}