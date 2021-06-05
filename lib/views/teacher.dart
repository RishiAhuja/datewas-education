import 'dart:math';

import 'package:datewas_education/helper/otpCheck.dart';
import 'package:datewas_education/services/database.dart';
import 'package:datewas_education/views/classRoom.dart';
import 'package:datewas_education/views/teachLogin.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_otp/flutter_otp.dart';


class TeachSignUp extends StatefulWidget {
  @override
  _TeachSignUpState createState() => _TeachSignUpState();
}

void randomGen(){
  random(min, max){
    var rn = new Random();
    return min + rn.nextInt(max - min);
  }
  randomString = random(1000,6000).toString();// Output : 19, 6, 15..
  print(randomString);
}

String randomString;
class _TeachSignUpState extends State<TeachSignUp> {
  bool _isLoading = false;
  FlutterOtp otp = FlutterOtp();
  final formKey = GlobalKey<FormState>();
  TextEditingController nameController = new TextEditingController();
  TextEditingController numberController = new TextEditingController();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  String _chosenValue;



  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back_ios_outlined, color: Colors.black,), onPressed: () => Navigator.pop(context),),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.admin_panel_settings, color: Colors.black),
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
            },
          )
        ],
      ),
      body: _isLoading ? Center(child: CircularProgressIndicator(backgroundColor: Colors.tealAccent[200],)) : SafeArea(
        child: Container(
          child: ListView(
            shrinkWrap: true,
            children: [
              Column(
                children: [
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.fromLTRB(16, 0, 16, 15),
                    child: Text(
                      "Datewas Online Education",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(
                          textStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 26,
                              color: Colors.black
                          )
                      ),
                    ),
                  ),
                  SizedBox(height: 60,),
                  Align(
                    alignment: Alignment.center,
                    child: Material(
                      elevation: 20,
                      borderRadius: BorderRadius.circular(15),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        width: MediaQuery.of(context).size.width/1.2,
                        height: MediaQuery.of(context).size.height/2.3,
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.only(top: 20),
                              child: Text(
                                'Welcome!',
                                style: GoogleFonts.montserrat(
                                    textStyle: TextStyle(
                                        color: Colors.blue[900],
                                        fontSize: 25
                                    )
                                ),
                              ),
                            ),
                            SizedBox(height: 15),


                            Form(
                              key: formKey,
                              child: Column(
                                children: [
                                  // ----------Name Input Start----------- //
                                  Container(
                                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                      decoration: BoxDecoration(
                                          border: Border.all(color: Colors.blue[900]),
                                          borderRadius: BorderRadius.circular(10)
                                      ),
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(left: 10),
                                            child: Icon(
                                              Icons.people,
                                              color: Colors.blue[900],
                                            ),
                                          ),
                                          Container(
                                            width: MediaQuery.of(context).size.width/2,
                                            child: Padding(
                                              padding: const EdgeInsets.only(left: 20),
                                              child: TextFormField(validator: (val)
                                              {
                                                return val.isEmpty || val.length < 4 ? 'Atleast 4+ characters required' : null;
                                              },

                                                controller: nameController,
                                                decoration: InputDecoration(
                                                    hintStyle: GoogleFonts.montserrat(textStyle: TextStyle(color: Colors.blue[900])),
                                                    hintText: 'Name',
                                                    border: InputBorder.none
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                  ),
                                  // ----------Name Input End----------- //

                                  // ----------Phone Number Input Start----------- //

                                  Container(
                                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                      decoration: BoxDecoration(
                                          border: Border.all(color: Colors.blue[900]),
                                          borderRadius: BorderRadius.circular(10)
                                      ),
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(left: 10),
                                            child: Icon(
                                              Icons.phone,
                                              color: Colors.blue[900],
                                            ),
                                          ),
                                          Container(
                                            width: MediaQuery.of(context).size.width/2,
                                            child: Padding(
                                              padding: const EdgeInsets.only(left: 20),
                                              child: TextFormField(
                                                validator: (val)
                                                {
                                                  return val.isEmpty || val.length > 10 || val.length < 10 ? 'Please provide valid number' : null;
                                                },

                                                keyboardType: TextInputType.phone,
                                                controller: numberController,
                                                decoration: InputDecoration(

                                                    hintStyle: GoogleFonts.montserrat(textStyle: TextStyle(color: Colors.blue[900])),
                                                    hintText: 'Phone Number',
                                                    border: InputBorder.none
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                  ),
                                  // ----------Phone Number Input End----------- //

                                ],
                              ),
                            ),

                            SizedBox(height: 30),

                            // ----------Login Button Start-------------//
                            GestureDetector(
                              onTap: (){
                                randomGen();
                                otp.sendOtp(numberController.text, 'OTP is : $randomString',
                                    1000, 6000, '+91');
                                print('oo god!');
                                Navigator.push(context, MaterialPageRoute(builder: (context) => OTPCheck(otp: randomString, teachNumber: numberController.text, teachName: numberController.text, userType: 'T',)));
                              },

                              child: Container(
                                width: MediaQuery.of(context).size.width/1.45,
                                height: 50,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(7),
                                    color: Colors.blue[900]
                                ),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Login',
                                    style: GoogleFonts.montserrat(
                                        textStyle: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold
                                        )
                                    ),
                                  ),
                                ),
                              ),
                            )
                            // ----------Login Button End-------------//

                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox()
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  addBoolToSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isSigned', true);
  }

  addUserNameToSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('user', nameController.text);
  }

}
