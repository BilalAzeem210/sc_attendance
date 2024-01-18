import 'dart:convert';

import 'package:essa_attendence/screens/login.dart';
import 'package:essa_attendence/screens/map_review_screen.dart';
import 'package:essa_attendence/screens/no_attendance_screen.dart';
import 'package:essa_attendence/screens/profile_screen.dart';
import 'package:essa_attendence/screens/visit_report_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

class MyDrawer extends StatelessWidget {
  late String _userId;
  late String _empemail;
  late String _empMobile;

  double _latitude = 0.0;
  double _longitude = 0.0;

  MyDrawer(String userId,String empemail,String empMobile){
    this._userId = userId;
    this._empemail = empemail;
    this._empMobile = empMobile;

  }

  @override
  Widget build(BuildContext context) {
    return Drawer(

      child: SingleChildScrollView(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
                accountName: Text(_userId),
                accountEmail: Text(_empemail),
            decoration: const BoxDecoration(
              //image: DecorationImage(image: AssetImage('assets/images/drawer.png'),
              //fit: BoxFit.cover),
              color: Color(0xff01468f)
            ),
            ),
            InkWell(
              onTap: (){
                Navigator.pushReplacement(context, PageTransition(
                    child: ProfileScreen(_userId,_empemail,_empMobile),
                    type: PageTransitionType.rightToLeft)
                );

              },
              child: const ListTile(
                leading: Icon(Icons.person,size: 20,),
                title: Text('Profile',style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal
                ),),
              ),
            ),

            InkWell(
              onTap: (){
                var heightSize = MediaQuery.of(context).size.height * 0.5;
                var widthSize = MediaQuery.of(context).size.width;
                Navigator.of(context).pop();
                showModalBottomSheet(context: context, builder: (ctx){
                  TextEditingController remarksController = TextEditingController();
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: heightSize,
                      width: widthSize,
                      child: Column(
                        children: [
                          TextFormField(
                            decoration: const InputDecoration(
                              hintText: 'Remarks',
                            ),
                            maxLines: 5,
                            controller: remarksController,
                            onChanged: (val){
                              remarksController.text = val;
                            },
                          ),
                          const SizedBox(height: 10,),
                          ElevatedButton(
                              onPressed: ()async {
                                if (await _getLocation()) {
                                  print("latitude : ${_latitude}");
                                  print("longitude : ${_longitude}");
                                  try {
                                    DateTime date = DateTime.now();
                                    Map<int, String> months = {
                                      1: "JAN",
                                      2: "FEB",
                                      3: "MAR",
                                      4: "APR",
                                      5: "MAY",
                                      6: "JUN",
                                      7: "JUL",
                                      8: "AUG",
                                      9: "SEP",
                                      10: "OCT",
                                      11: "NOV",
                                      12: "DEC"
                                    };
                                    String isAMOrPM = date.hour < 12
                                        ? "AM"
                                        : "PM";
                                    var myDate = "${date.day}-${months[date
                                        .month]}-${date.year} ${date
                                        .hour}:${date.minute}:${date
                                        .second} $isAMOrPM";
                                    print(myDate);
                                    var response = await http.post(Uri.http(
                                        "194.163.166.163:1251",
                                        "/ords/sc_attendence/attn/attendence"),
                                        headers: <String, String>{
                                          'Content-Type': 'application/json'
                                        },
                                        body: jsonEncode(<String, dynamic>{
                                          "usrid": _userId,
                                          "checktype": "I",
                                          "gpslat": _latitude,
                                          "gpslon": _longitude,
                                          "remarks": remarksController.text
                                        })
                                    );
                                    print("post ${response.statusCode}");
                                    if (response.statusCode == 200) {
                                      print('Successfully: ${response.body
                                          .toString()}');
                                      ScaffoldMessenger.of(ctx).showSnackBar(
                                          SnackBar(content: Text(
                                              "Attendence successfully marked")));
                                    }
                                    else {
                                      ScaffoldMessenger.of(ctx).showSnackBar(
                                          SnackBar(content: Text(
                                              "Something went wrong in marking attendence")));
                                    }
                                    Navigator.of(ctx).pop();
                                  }

                                  catch (e) {
                                    print(e.toString());
                                  }
                                }
                                else{
                                  Navigator.of(ctx).pop();
                                  ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text("Please open your location")));
                                }
                              },
                              child: const Text('Mark Attendence',
                                style: TextStyle(color:Colors.white),),
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                          ),

                        ],
                      ),
                    ),
                  );
                });
              },
              child: const ListTile(
                leading: Icon(Icons.location_on_outlined,size: 20,),
              title: Text('Mark Attendence',
                style: TextStyle(fontWeight: FontWeight.normal,
                fontSize: 16),),
              ),
            ),

            InkWell(
              onTap: (){
                var heightSize = MediaQuery.of(context).size.height * 0.5;
                var widthSize = MediaQuery.of(context).size.width;
                Navigator.of(context).pop();
                showModalBottomSheet(context: context, builder: (ctx){
                  TextEditingController remarksController = TextEditingController();
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: heightSize,
                      width: widthSize,
                      child: Column(
                        children: [
                          TextFormField(
                            decoration: const InputDecoration(
                              hintText: 'Remarks',
                            ),
                            maxLines: 5,
                            controller: remarksController,
                            onChanged: (val){
                              remarksController.text = val;
                            },
                          ),
                          const SizedBox(height: 10,),
                          ElevatedButton(
                              onPressed: ()async {
                                if (await _getLocation()) {
                                  print("latitude : ${_latitude}");
                                  print("longitude : ${_longitude}");
                                  try {
                                    DateTime date = DateTime.now();
                                    Map<int, String> months = {
                                      1: "JAN",
                                      2: "FEB",
                                      3: "MAR",
                                      4: "APR",
                                      5: "MAY",
                                      6: "JUN",
                                      7: "JUL",
                                      8: "AUG",
                                      9: "SEP",
                                      10: "OCT",
                                      11: "NOV",
                                      12: "DEC"
                                    };
                                    String isAMOrPM = date.hour < 12
                                        ? "AM"
                                        : "PM";
                                    var myDate = "${date.day}-${months[date
                                        .month]}-${date.year} ${date
                                        .hour}:${date.minute}:${date
                                        .second} $isAMOrPM";
                                    print(myDate);
                                    var response = await http.post(Uri.http(
                                        "194.163.166.163:1251",
                                        "/ords/sc_attendence/attn/attendence"),
                                        headers: <String, String>{
                                          'Content-Type': 'application/json'
                                        },
                                        body: jsonEncode(<String, dynamic>{
                                          "usrid": _userId,
                                          "checktype": "I",
                                          "gpslat": _latitude,
                                          "gpslon": _longitude,
                                          "remarks": remarksController.text
                                        })
                                    );
                                    print("post ${response.statusCode}");
                                    if (response.statusCode == 200) {
                                      print('Successfully: ${response.body
                                          .toString()}');
                                      ScaffoldMessenger.of(ctx).showSnackBar(
                                          SnackBar(content: Text(
                                              "Visit successfully marked")));
                                    }
                                    else {
                                      ScaffoldMessenger.of(ctx).showSnackBar(
                                          SnackBar(content: Text(
                                              "Something went wrong in marking visit")));
                                    }
                                    Navigator.of(ctx).pop();
                                  }

                                  catch (e) {
                                    print(e.toString());
                                  }
                                }
                                else{
                                  Navigator.of(ctx).pop();
                                  ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text("Please open your location")));
                                }
                              },
                              child: const Text('Mark Visits',style: TextStyle(color: Colors.white),),
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                          ),

                        ],
                      ),
                    ),
                  );
                });
              },
              child: const ListTile(
                leading: Icon(Icons.location_on,size: 20,),
                title: Text('Mark Visits',style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal
                ),),
              ),
            ),

            ExpansionTile(
            title: Text("Reports",style: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 16,
            ),),
            leading: Icon(Icons.report,size: 20,), //add icon
            childrenPadding: EdgeInsets.only(left:60), //children padding
            children: [
            InkWell(
              onTap:(){
                Navigator.pushReplacement(context, PageTransition(child: NoAttendanceScreen(_userId,_empMobile,_empemail), type: PageTransitionType.rightToLeft));
              },
              child: ListTile(
              leading: Icon(Icons.location_city_sharp,size: 20,),
                title: Text("Attendence Last n Days",style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 16
                ),),

              ),
            ),
              InkWell(
                onTap: (){
                  Navigator.pushReplacement(context, PageTransition(child: VisitReportScreen(_userId,_empemail,_empMobile), type: PageTransitionType.rightToLeft));
                },
                child: ListTile(
                  leading: Icon(Icons.add,size: 20,),
                  title: Text("Visits Report",style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 16
                  ),),

                ),
              ),

            ]
    ),

           InkWell(
             onTap: (){
               Navigator.push(context, PageTransition(child: MapReviewScreen(), type: PageTransitionType.rightToLeft));
             },
             child: const ListTile(
                leading: Icon(Icons.map_sharp,size: 20,),
                title: Text("Presence in Map",style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal
                ),),

              ),
           ),
            const ListTile(
              leading: Icon(Icons.timeline,size: 20,),
              title: Text("Timeline",style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal
              ),),

            ),
            InkWell(
              onTap: (){
                Navigator.pushReplacement(context, PageTransition(child: const LoginView(), type: PageTransitionType.leftToRight));
              },
              child: const ListTile(
                leading: Icon(Icons.logout,size: 20,),
                title: Text("Logout",style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal
                ),),

              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _getLocation() async{
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return false;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return false;
      }
    }
    location.changeSettings(accuracy: LocationAccuracy.high);
    locationData = await location.getLocation();
    _latitude = locationData.latitude!;
    _longitude = locationData.longitude!;
    return true;
  }

}
