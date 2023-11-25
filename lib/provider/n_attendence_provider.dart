import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class NAttendenceProvider with ChangeNotifier{
  List<dynamic> _nattendences = [];
  List<dynamic> get getNAttendences{
    return [..._nattendences];
  }

  void downloadData(int noOfDays, String userId) async{
    try{
     var response = await http.get(Uri.http("", "", {

     }));
     var res = jsonDecode(response.body);
     if(response.statusCode == 200 && res["items"].length > 0){
       _nattendences = res["items"];
       notifyListeners();
     }
    }
    catch(e){

    }
  }
  Future<List<Map<String, dynamic>>> downloadDataForFirsttime(int noOfDays, String userId) async{
    try{
      var response = await http.get(Uri.http("194.163.166.163:1251", "/ords/sc_attendence/attn/atrn_rep", {
        "usrid" : userId
      }));
      var res = jsonDecode(response.body);
      if(response.statusCode == 200 && res["items"].length > 0){
        _nattendences = res["items"];
      }
    }
    catch(e){

    }
    return [..._nattendences];
  }
}