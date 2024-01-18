import 'dart:convert';
import 'package:essa_attendence/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);
  static String email = "";

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formState = GlobalKey<FormState>();
  final _hidePassword = ValueNotifier<bool>(true);
  bool _isLoading = false;
  String? _email;
  String? _password;
  var sharedPreference;
  TextEditingController _passwordController = TextEditingController();
  ValueNotifier<bool> _loginListen = ValueNotifier<bool>(true);
  var _deviceToken,_dbExistence,_isFirsttime;
  Future<bool> _checkDbExistence() async{
    print("checking db existence");

    sharedPreference = (await SharedPreferences.getInstance());
    var token = sharedPreference.getString("deviceToken");
    _email = sharedPreference.getString("_email");
    _password = sharedPreference.getString("_password");
    if(_password != null){
      _passwordController.text = _password!;
      _passwordController.selection = TextSelection.fromPosition(TextPosition(offset: _password!.length));
    }
    if(token != null){
      print("sh token : ${token}");
      // bind data
      _deviceToken = token;
      return false;
    }
    else{
      print("first time login");
      return true;
    }
  }


  @override
  void initState() {
    Future.delayed(Duration.zero, () async{
      _dbExistence = await _checkDbExistence();
      if(_dbExistence){
        //first time
        _isFirsttime = true;
      }
      else{
        // not first time
        _isFirsttime = false;
        print("deviceToken from local db : $_deviceToken");
        setState(() {

        });
      }
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child:Container(
          height: screenHeight,
          width: screenWidth,
          decoration: const BoxDecoration(
            color: Colors.white
          ),

          child: SingleChildScrollView(
            child: Column(

              children: <Widget>[
                SizedBox(height: screenHeight * 0.1,),Image(
                          image: const AssetImage("assets/images/sclogo.png"),
                          width: MediaQuery.of(context).size.width * 0.7,
                        ),
                SizedBox(height: screenHeight * 0.03,),
                SingleChildScrollView(
                  child: SizedBox(
                    width: screenWidth * 100 / 100,
                    height: screenHeight * .50,

                    child: Container(
                      child: Form(key: _formState,
                        child: Column(
                          children: <Widget>[
                            const SizedBox(height: 10,),
                            const SizedBox(height: 10,),
                            Flexible(flex: 1,child: Padding(padding: const EdgeInsets.symmetric(horizontal: 15,),
                              child: TextFormField(
                                validator: (val){
                                  if(_email!.isEmpty){
                                    return "Please provide valid username";
                                  }
                                  return null;
                                },
                                onSaved: (val){
                                  if(_isFirsttime) {
                                    print("first save");
                                    _email = val!;
                                  }
                                  LoginView.email = _email!;
                                },
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(
                                    Icons.email_rounded
                                  ),
                                    hintText: _email == null ? "Email" : _email,
                                    fillColor: const Color(0xfff6f7fa),
                                    filled: true,
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(color: Color(0xfff6f7fa)),
                                        borderRadius: BorderRadius.circular(15)
                                    ),

                                    enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Color(0xfff6f7fa)
                                        ),
                                        borderRadius: BorderRadius.circular(15)
                                    )
                                ),
                              ),),
                            )
                            ,
                            const SizedBox(height: 20,),
                            Flexible(flex: 1,child: Padding(padding: const EdgeInsets.symmetric(horizontal: 15),
                              child: ValueListenableBuilder<bool>(
                                valueListenable: _hidePassword,
                                builder: (ctx, value, child){
                                  return TextFormField(
                                    controller: _passwordController,
                                    onSaved: (val){
                                      _password = val!;
                                    },
                                    validator: (val){
                                      if(val!.length < 3){
                                        return "Please provide a password of least 3 character";
                                      }
                                      return null;
                                    },
                                    obscureText: _hidePassword.value,
                                    obscuringCharacter: "*",
                                    decoration: InputDecoration(
                                      hintText: _password == null ? "Password" : _password,
                                      suffixIcon: IconButton(icon: _hidePassword.value ? const Icon(Icons.visibility_off) : const Icon(Icons.visibility), onPressed: (){
                                        _hidePassword.value = !_hidePassword.value;
                                      },),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(color: Color(0xfff6f7fa)),
                                          borderRadius: BorderRadius.circular(15)
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(color: Color(0xfff6f7fa)),
                                          borderRadius: BorderRadius.circular(15)
                                      ),
                                      filled: true,
                                      fillColor: const Color(0xfff6f7fa),
                                      prefixIcon: const Icon(Icons.password)
                                    ),
                                  );
                                },
                              ),
                            ),
                            ),
                            const SizedBox(height: 30,),
                            Flexible(flex: 1,child: InkWell(
                              onTap: (){
                                _validateUser();
                              },
                              child: Container(
                                width: 150,
                                height: 40,
                                decoration: BoxDecoration(color: const Color(0xff0095D9),
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: const [
                                      BoxShadow(blurRadius: 1.0, offset: Offset(1, 5), color: Colors.black12)
                                    ]
                                ),
                                child: _isLoading ? const Center(child: CircularProgressIndicator(color: Colors.white,)) : const Center(child: Text("Login", style: TextStyle(
                                    color: Colors.white
                                ),
                                ),
                                ),
                              ),
                            ),
                            ),
                            const SizedBox(height: 10,),

                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),


    );
  }

  Future<void> _validateUser() async {
    var currentState = _formState.currentState!;
    currentState.save();
    bool isValid = currentState.validate();
    print("valid : ${isValid}");
    if (isValid) {
      _isLoading = true;
      setState(() {

      });
      print("validate user");
      try {
        if(_isFirsttime){
          // firsttime login
          String? deviceToken = Uuid().v1() + DateTime.now().toString();
          print("token : ${deviceToken}");
          print("sending req");
          Uri uri = Uri.http("194.163.166.163:1251", "/ords/sc_attendence/attn/login_email",
              {"empemail": _email, "password": _password, "tokenid" : null});
          var response = await http.get(uri);
          print(response.statusCode);
          var res = jsonDecode(response.body);
          print(res["items"]);
          if(response.statusCode == 200){
            var empId = res["items"][0]["usrid"];
            var deviceTokenResponse = await http.put(
              Uri.http("194.163.166.163:1251", "/ords/sc_attendence/attn/token"),
              body: jsonEncode({
                "usrid": empId,
                "tokenid": deviceToken
              }),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
            );
            print("first put status : ${deviceTokenResponse.statusCode}");
            if(deviceTokenResponse.statusCode == 200){
              await sharedPreference.setString("deviceToken", deviceToken);
              await sharedPreference.setString("_email", _email);
              await sharedPreference.setString("_password", _password);
              print("data successfully inserted");
              Navigator.pushReplacement(context, PageTransition(child: ProfileScreen(res["items"][0]["usrid"], res["items"][0]["empemail"],res["items"][0]["empmobile"]), type: PageTransitionType.rightToLeft));
            }
          }
          _loginListen.value = false;
        }
        else{
          print("not firsttime");
          print("dev tok : $_deviceToken");
          print("pass : $_password");
          print("mob : $_email");
          // not firsttime login
          Uri uri = Uri.http("194.163.166.163:1251", "/ords/sc_attendence/attn/login_email",
              {"empemail": _email, "password": _password, "tokenid" : _deviceToken});
          var response = await http.get(uri);
          print(response.statusCode);
          var res = jsonDecode(response.body);
          print(res["items"]);

          if(response.statusCode == 200 && res["items"].length > 0){
            Navigator.pushReplacement(context, PageTransition(child: ProfileScreen(res["items"][0]["usrid"], res["items"][0]["empemail"],res["items"][0]["empmobile"]), type: PageTransitionType.rightToLeft));

          }
          else{
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                backgroundColor: Colors.black,
                content: Text("Please enter correct credentials",style: TextStyle(
                  color: Colors.white
                ),)));
            setState(() {
              _isLoading = false;
            });
            _loginListen.value = false;
          }
        }
      }
      catch(e){
        print(e.toString());

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(backgroundColor: Colors.black,
          content: Text("Login Failed",style: TextStyle(
            color: Colors.white,
          ),
          ),
        ),
        );
        setState(() {
          _isLoading = false;
        },
        );
      }
    }
  }

@override
  void dispose() {
    // TODO: implement dispose
  _passwordController.dispose();
  super.dispose();
  }
}