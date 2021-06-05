import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:timer_builder/timer_builder.dart';

class OTPCheck extends StatefulWidget {
  final String otp;
  OTPCheck({@required this.otp});
  @override
  _OTPCheckState createState() => _OTPCheckState();
}

class _OTPCheckState extends State<OTPCheck> {

  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();

  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      border: Border.all(color: Colors.blue[900]),
      borderRadius: BorderRadius.circular(5.0),
    );
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
      body: ListView(
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
              Container(
                width: MediaQuery.of(context).size.width,
                height: 45,
                alignment: Alignment.centerRight,
                child: SampleApp(),
              )
            ],
          )
        ],
      )
    );
  }
}


class SampleApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SampleAppState();
  }
}

class SampleAppState extends State<SampleApp> {
  DateTime alert;

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
                          child: Text("Time Up!", style: GoogleFonts.montserrat(fontSize: 19))),
                    ),
                // RaisedButton(
                //   child: Text("Reset"),
                //   onPressed: () {
                //     setState(() {
                //       alert = DateTime.now().add(Duration(seconds: 150));
                //     });
                //   },
                // ),
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