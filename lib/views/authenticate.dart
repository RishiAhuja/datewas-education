import 'package:datewas_education/views/classRoom.dart';
import 'package:datewas_education/views/signUp.dart';
import 'package:datewas_education/views/userSelection.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

bool _isSigned = false;
String userName;

class _AuthenticateState extends State<Authenticate> {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();


  @override
  void initState() {
    super.initState();
    getBoolValuesSF();
    getUserValueSF();
    _firebaseMessaging.configure(
      onMessage: (message) async{
        setState(() {    
          print(message);
          print(message['notification']['title']);      
        });

      },
      onResume: (message) async{
        setState(() {
         print(message);
        });

      },
      onLaunch: (message) async{
        setState(() {
          print(message);
        });
      }
    );

    }

  @override
  Widget build(BuildContext context) {

    if(_isSigned){
      return MaterialApp(
          title: 'Datewas Education',
          theme: ThemeData(
            scaffoldBackgroundColor: Colors.white,
            // scaffoldBackgroundColor: Colors.tealAccent[200],
            primarySwatch: Colors.blue,
          ), home: ClassRoom());
    }
    else {
      return MaterialApp(
          title: 'Datewas Education',
          theme: ThemeData(
            scaffoldBackgroundColor: Colors.white,
            primarySwatch: Colors.blue,
          ), home: UserSelection());
    }


  }

  getBoolValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    bool boolValue = prefs.getBool('isSigned');
    print(boolValue);
    if(boolValue != null)
    {
      setState(() {
        _isSigned = boolValue;
      });
    }
    return boolValue;
  }


  getUserValueSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    String user = prefs.getString('user');
    print(user);
    if(user != null)
    {
      setState(() {
        userName = user;
      });
    }
    return user;
  }

}



