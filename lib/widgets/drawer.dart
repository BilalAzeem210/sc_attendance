import 'package:essa_attendence/screens/login.dart';
import 'package:essa_attendence/screens/profile_screen.dart';
import 'package:essa_attendence/screens/visit_report_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:location/location.dart';

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
              color: Colors.blue
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
                              onPressed: ()async{
                                await _getLocation();
                                print("latitude : ${_latitude}");
                                print("longitude : ${_longitude}");
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
                              onPressed: ()async{
                                await _getLocation();
                                print("latitude : ${_latitude}");
                                print("longitude : ${_longitude}");
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
            ListTile(
            leading: Icon(Icons.location_city_sharp,size: 20,),
              title: Text("Attendence Last n Days",style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 16
              ),),
    
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

           const ListTile(
              leading: Icon(Icons.map_sharp,size: 20,),
              title: Text("Presence in Map",style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal
              ),),

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

  Future<void> _getLocation() async{
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    locationData = await location.getLocation();
    _latitude = locationData.latitude!;
    _longitude = locationData.longitude!;
  }

}
