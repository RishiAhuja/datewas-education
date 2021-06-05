import 'dart:async';
import 'dart:math';

import 'package:datewas_education/services/database.dart';
import 'package:datewas_education/views/TeacherRoom.dart';
import 'package:datewas_education/views/classRoom.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timer_builder/timer_builder.dart';
import 'package:flutter_otp/flutter_otp.dart';

class OTPCheck extends StatefulWidget {
  final String otp;
  final String teachNumber;
  final String teachName;
  final String studentName;
  final String studentNumber;
  final String studentPunjab;
  final String studentClass;
  final String userType;
  OTPCheck({@required this.otp, @required this.userType, this.teachNumber, this.teachName, this.studentPunjab, this.studentClass, this.studentNumber, this.studentName});
  @override
  _OTPCheckState createState() => _OTPCheckState();
}

String randomString;
String sampleAppNumber;

class _OTPCheckState extends State<OTPCheck> {

  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();
  DatabaseMethods databaseMethods = DatabaseMethods();
  bool validation = true;
  bool _isLoading = false;
  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      border: Border.all(color: Colors.blue[900]),
      borderRadius: BorderRadius.circular(5.0),
    );
  }

  teachSignBoolToSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isSigned', true);
  }

  studentSignBoolToSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isSigned', false);
  }

  addBoolTeachToSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isTeach', true);
  }

  addBoolStudentToSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isTeach', false);
  }

  addTeacherNameToSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('user', widget.teachName);
  }

  addStudentNameToSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('user', widget.studentName);
  }

  addPunjabToSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('e-punjab', widget.studentPunjab);
  }


  addBoolToSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isSigned', true);
  }

  signUserUp()
  {
      Map<String, String> userMap = {
        "name": widget.studentName,
        "phone": widget.studentNumber,
        "class": widget.studentClass,
        'e-punjab' : widget.studentPunjab
      };

      setState(() {
        _isLoading = true;
      });
      databaseMethods.uploadUserInfo(userMap);
      addPunjabToSF();
      addStudentNameToSF();
      studentSignBoolToSF();
      addBoolToSF();
      addBoolStudentToSF();
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ClassRoom()));

  }

  signTeacherUp()
  {
    if(_pinPutController.text == randomString)
     {
       print('validated');
       setState(() {
         validation = true;

         Map<String, String> userMap = {
           "name": widget.teachName,
           "phone": widget.teachNumber,
         };
         _isLoading = true;
         databaseMethods.uploadTeacherInfo(userMap);
         addBoolToSF();
         addBoolTeachToSF();
         addTeacherNameToSF();
         teachSignBoolToSF();
         Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => TeachRoom()));
         //});
       });

     }
    else{
      print("can't validate");
      setState(() {
        validation = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    randomString = widget.otp;
    if(widget.userType == 'T'){
      setState(() {
        sampleAppNumber = widget.teachNumber;
      });
    }
    if(widget.userType == 'S')
      {
        setState(() {
          sampleAppNumber = widget.studentNumber;
        });
      }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Please Enter the OTP',
          style: GoogleFonts.montserrat(
            textStyle: TextStyle(
              color: Colors.black,
              fontSize: 19
            )
          ),
        ),
        leading: IconButton(icon: Icon(Icons.arrow_back_ios_outlined, color: Colors.black,), onPressed: () => Navigator.pop(context),),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: _isLoading ? Center(child: CircularProgressIndicator()) : ListView(
        shrinkWrap: true,
        children: [
          Column(
            children: [
              Container(
                color: Colors.white,
                margin: const EdgeInsets.all(20.0),
                padding: const EdgeInsets.all(20.0),
                child: PinPut(
                  eachFieldWidth: 47.0,
                  eachFieldHeight: 75.0,
                  fieldsCount: 4,
                  // onSubmit: (String pin) => _showSnackBar(pin, context),
                  focusNode: _pinPutFocusNode,
                  controller: _pinPutController,
                  submittedFieldDecoration: _pinPutDecoration.copyWith(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  selectedFieldDecoration: _pinPutDecoration,
                  followingFieldDecoration: _pinPutDecoration.copyWith(
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(
                      color: Colors.blue[900].withOpacity(.5),
                    ),
                  ),
                ),
              ),
              validation != true ? Container(
                alignment: Alignment.center,
                child: Text(
                  'Please enter the correct OTP!',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                      fontSize: 19,
                      color: Colors.red
                  ),
                ),
              ) : Container(),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 55,
                alignment: Alignment.centerRight,
                child: SampleApp(number: sampleAppNumber),
              ),
              SizedBox(height: 35,),
              GestureDetector(
                onTap: () {
                  if(widget.userType == 'T')
                   {
                      signTeacherUp();
                   }
                  if(widget.userType == 'S')
                   {
                     signUserUp();
                   }
                },
                child: Material(
                  elevation: 7,
                  borderRadius: BorderRadius.circular(7),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      color: Colors.blue[900]
                    ),
                    width: MediaQuery.of(context).size.width/1.5,
                    height: 65,
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Login',
                        style: GoogleFonts.montserrat(
                          textStyle: TextStyle(
                            fontSize: 21,
                            color: Colors.white
                          )
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      )
    );
  }
}


class SampleApp extends StatefulWidget {
  final String number;
  SampleApp({@required this.number});
  @override
  State<StatefulWidget> createState() {
    return SampleAppState();
  }
}

class SampleAppState extends State<SampleApp> {
  DateTime alert;
  FlutterOtp otp = FlutterOtp();
  @override
  void initState() {
    super.initState();
    alert = DateTime.now().add(Duration(seconds: 150));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: TimerBuilder.scheduled([alert], builder: (context) {
          // This function will be called once the alert time is reached
          var now = DateTime.now();
          var reached = now.compareTo(alert) >= 0;
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                !reached
                    ? TimerBuilder.periodic(Duration(seconds: 1),
                    alignment: Duration.zero, builder: (context) {
                      // This function will be called every second until the alert time
                      var now = DateTime.now();
                      var remaining = alert.difference(now);
                      return Padding(
                        padding: const EdgeInsets.only(right: 35.0),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            formatDuration(remaining),
                            style: GoogleFonts.montserrat(fontSize: 19),
                          ),
                        ),
                      );
                    })
                    : Padding(
                      padding: const EdgeInsets.only(right: 35.0),
                        child: Align(
                        alignment: Alignment.centerRight,
                          child:  FlatButton(
                            child: Text("Resend OTP", style: GoogleFonts.montserrat(fontSize: 19)),
                            onPressed: () {
                              randomGen();
                              otp.sendOtp(widget.number, 'OTP is : $randomString',
                                  1000, 6000, '+91');
                              setState(() {
                                alert = DateTime.now().add(Duration(seconds: 90));
                              });
                            },
                          ),),
                    ),
              ],
            ),
          );
        }),
    );
  }
}


String formatDuration(Duration d) {
  String f(int n) {
    return n.toString().padLeft(2, '0');
  }

  // We want to round up the remaining time to the nearest second
  d += Duration(microseconds: 999999);
  return "${f(d.inMinutes)}:${f(d.inSeconds % 60)}";
}

void randomGen(){
  random(min, max){
    var rn = new Random();
    return min + rn.nextInt(max - min);
  }
  randomString = random(1000,6000).toString();// Output : 19, 6, 15..
  print(randomString);
}
