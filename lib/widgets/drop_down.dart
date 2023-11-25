import 'package:flutter/material.dart';

class MyDropDown extends StatefulWidget {
  late String _userId;
  late Function _fetchDataCallback;
  MyDropDown(String userId, Function fetchDataCallback){
    this._userId = userId;
    this._fetchDataCallback = fetchDataCallback;
  }

  @override
  State<MyDropDown> createState() => _MyDropDownState();
}

class _MyDropDownState extends State<MyDropDown> {
  List<String> _list = <String>['1', '2', '3', '4', '5', '6', '7', '8', '9', '10'];
  late String _dropdownValue;
  _MyDropDownState(){
    _dropdownValue = _list.first;
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
    Container(
      width: MediaQuery.of(context).size.width * 0.4,
      child: DropdownButton<String>(
        isExpanded: true,
      value: _dropdownValue,
        icon: const Icon(Icons.arrow_downward),
        elevation: 16,
        style: const TextStyle(color: Colors.black),
        underline: Container(
          height: 2,
          color: Colors.black87,
        ),
        onChanged: (String? value) {
          // This is called when the user selects an item.
          setState(() {
            print(value);
            _dropdownValue = value!;
          });
        },
        items: _list.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    ),
      SizedBox(height: 5,),
        ElevatedButton(onPressed: (){
          Navigator.pop(context);
          widget._fetchDataCallback(_dropdownValue);

        },
            style:ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade800),
            child: Text("Check attendence",style: TextStyle(color: Colors.white),))
      ],
    );
  }
}
