import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TimeTable extends StatefulWidget {
 final int classInt;
 TimeTable({this.classInt});

  @override
  _TimeTableState createState() => _TimeTableState();
}

class _TimeTableState extends State<TimeTable> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _hour, _minute, _time;

  String dateTime;

  DateTime selectedDate = DateTime.now();

  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);

  TextEditingController mondayStart = TextEditingController();
  TextEditingController tuesdayStart = TextEditingController();
  TextEditingController wednesdayStart = TextEditingController();
  TextEditingController thursdayStart = TextEditingController();
  TextEditingController fridayStart = TextEditingController();
  TextEditingController saturdayStart = TextEditingController();

  TextEditingController mondayEnd = TextEditingController();
  TextEditingController tuesdayEnd = TextEditingController();
  TextEditingController wednesdayEnd = TextEditingController();
  TextEditingController thursdayEnd = TextEditingController();
  TextEditingController fridayEnd = TextEditingController();
  TextEditingController saturdayEnd = TextEditingController();



  String mondayStartText = '00 : 00';
  String tuesdayStartText = '00 : 00';
  String wednesdayStartText = '00 : 00';
  String thursdayStartText = '00 : 00';
  String fridayStartText = '00 : 00';
  String saturdayStartText = '00 : 00';

  String mondayEndText = '00 : 00';
  String tuesdayEndText = '00 : 00';
  String wednesdayEndText = '00 : 00';
  String thursdayEndText = '00 : 00';
  String fridayEndText = '00 : 00';
  String saturdayEndText = '00 : 00';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }
  getData()
  async{
    // QuerySnapshot snap = await
    // Firestore.instance.collection('TimeTable').getDocuments();

    Firestore.instance.collection('TimeTable').document('${widget.classInt}th')
        .get().then((DocumentSnapshot) {
      print(DocumentSnapshot.data['mondayStart'].toString());

      setState(() {
        mondayStartText = DocumentSnapshot.data['mondayStart'].toString();
        tuesdayStartText = DocumentSnapshot.data['tuesdayStart'].toString();
        wednesdayStartText = DocumentSnapshot.data['wednesdayStart'].toString();
        thursdayStartText = DocumentSnapshot.data['thursdayStart'].toString();
        fridayStartText = DocumentSnapshot.data['fridayStart'].toString();
        saturdayStartText = DocumentSnapshot.data['saturdayStart'].toString();

        mondayEndText = DocumentSnapshot.data['mondayEnd'].toString();
        tuesdayEndText = DocumentSnapshot.data['tuesdayEnd'].toString();
        wednesdayEndText = DocumentSnapshot.data['wednesdayEnd'].toString();
        thursdayEndText = DocumentSnapshot.data['thursdayEnd'].toString();
        fridayEndText = DocumentSnapshot.data['fridayEnd'].toString();
        saturdayEndText = DocumentSnapshot.data['saturdayEnd'].toString();


        mondayStart.text = mondayStartText;
        tuesdayStart.text = tuesdayStartText;
        wednesdayStart.text = wednesdayStartText;
        thursdayStart.text = thursdayStartText;
        fridayStart.text = fridayStartText;
        saturdayStart.text = saturdayStartText;

        mondayEnd.text = mondayEndText;
        tuesdayEnd.text = tuesdayEndText;
        wednesdayEnd.text = wednesdayEndText;
        thursdayEnd.text = thursdayEndText;
        fridayEnd.text = fridayEndText;
        saturdayEnd.text = saturdayEndText;

      });
    });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.tealAccent,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.tealAccent,
        leading: IconButton(icon: Icon(Icons.arrow_back_ios), color: Colors.white, onPressed: () => Navigator.pop(context)),
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          Column(
            children: [
              Material(
                elevation: 7,
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  padding: EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width/1.3,
                  child: Column(
                    children: [
                      Text(
                        'Monday',
                        style: GoogleFonts.montserrat(
                          textStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 23
                          )
                        ),
                      ),
                      Divider(color: Colors.black,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () => _selectTime(context, mondayStart),
                            child: Container(
                              width: MediaQuery.of(context).size.width/3.3,
                              child: Align(
                                alignment: Alignment.center,
                                child: TextFormField(
                                  onChanged: (val) => mondayStartText = val,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.montserrat(),
                                  controller: mondayStart,
                                  enabled: false,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: mondayStartText,
                                    hintStyle: GoogleFonts.montserrat(textStyle: TextStyle(color: Colors.grey[400]))
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Text(
                            'To',
                            style: GoogleFonts.montserrat(
                              color: Colors.black,
                              fontSize: 15
                            ),
                          ),
                          GestureDetector(
                            onTap: () => _selectTime(context, mondayEnd),
                            child: Container(
                              width: MediaQuery.of(context).size.width/3.3,
                              child: Align(
                                alignment: Alignment.center,
                                child: TextFormField(
                                  onChanged: (val) => mondayEndText = val,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.montserrat(),
                                  controller: mondayEnd,
                                  enabled: false,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: mondayEndText,
                                      hintStyle: GoogleFonts.montserrat(textStyle: TextStyle(color: Colors.grey[400]))
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),


              SizedBox(height: 15),


              Material(
                elevation: 7,
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  padding: EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width/1.3,
                  child: Column(
                    children: [
                      Text(
                        'Tuesday',
                        style: GoogleFonts.montserrat(
                            textStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 23
                            )
                        ),
                      ),
                      Divider(color: Colors.black,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () => _selectTime(context, tuesdayStart),
                            child: Container(
                              width: MediaQuery.of(context).size.width/3.3,
                              child: Align(
                                alignment: Alignment.center,
                                child: TextFormField(
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.montserrat(),
                                  controller: tuesdayStart,
                                  enabled: false,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: tuesdayStartText,
                                      hintStyle: GoogleFonts.montserrat(textStyle: TextStyle(color: Colors.grey[400]))
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Text(
                            'To',
                            style: GoogleFonts.montserrat(
                                color: Colors.black,
                                fontSize: 15
                            ),
                          ),
                          GestureDetector(
                            onTap: () => _selectTime(context, tuesdayEnd),
                            child: Container(
                              width: MediaQuery.of(context).size.width/3.3,
                              child: Align(
                                alignment: Alignment.center,
                                child: TextFormField(
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.montserrat(),
                                  controller: tuesdayEnd,
                                  enabled: false,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: tuesdayEndText,
                                      hintStyle: GoogleFonts.montserrat(textStyle: TextStyle(color: Colors.grey[400]))
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),



              SizedBox(height: 15),



              Material(
                elevation: 7,
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  padding: EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width/1.3,
                  child: Column(
                    children: [
                      Text(
                        'Wednesday',
                        style: GoogleFonts.montserrat(
                            textStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 23
                            )
                        ),
                      ),
                      Divider(color: Colors.black,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () => _selectTime(context, wednesdayStart),
                            child: Container(
                              width: MediaQuery.of(context).size.width/3.3,
                              child: Align(
                                alignment: Alignment.center,
                                child: TextFormField(
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.montserrat(),
                                  controller: wednesdayStart,
                                  enabled: false,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: wednesdayStartText,
                                      hintStyle: GoogleFonts.montserrat(textStyle: TextStyle(color: Colors.grey[400]))
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Text(
                            'To',
                            style: GoogleFonts.montserrat(
                                color: Colors.black,
                                fontSize: 15
                            ),
                          ),
                          GestureDetector(
                            onTap: () => _selectTime(context, wednesdayEnd),
                            child: Container(
                              width: MediaQuery.of(context).size.width/3.3,
                              child: Align(
                                alignment: Alignment.center,
                                child: TextFormField(
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.montserrat(),
                                  controller: wednesdayEnd,
                                  enabled: false,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: wednesdayEndText,
                                      hintStyle: GoogleFonts.montserrat(textStyle: TextStyle(color: Colors.grey[400]))
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),


              SizedBox(height: 15),



              Material(
                elevation: 7,
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  padding: EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width/1.3,
                  child: Column(
                    children: [
                      Text(
                        'Thursday',
                        style: GoogleFonts.montserrat(
                            textStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 23
                            )
                        ),
                      ),
                      Divider(color: Colors.black,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () => _selectTime(context, thursdayStart),
                            child: Container(
                              width: MediaQuery.of(context).size.width/3.3,
                              child: Align(
                                alignment: Alignment.center,
                                child: TextFormField(
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.montserrat(),
                                  controller: thursdayStart,
                                  enabled: false,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: thursdayStartText,
                                      hintStyle: GoogleFonts.montserrat(textStyle: TextStyle(color: Colors.grey[400]))
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Text(
                            'To',
                            style: GoogleFonts.montserrat(
                                color: Colors.black,
                                fontSize: 15
                            ),
                          ),
                          GestureDetector(
                            onTap: () => _selectTime(context, thursdayEnd),
                            child: Container(
                              width: MediaQuery.of(context).size.width/3.3,
                              child: Align(
                                alignment: Alignment.center,
                                child: TextFormField(
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.montserrat(),
                                  controller: thursdayEnd,
                                  enabled: false,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: thursdayEndText,
                                      hintStyle: GoogleFonts.montserrat(textStyle: TextStyle(color: Colors.grey[400]))
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),




              SizedBox(height: 15),


              Material(
                elevation: 7,
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  padding: EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width/1.3,
                  child: Column(
                    children: [
                      Text(
                        'Friday',
                        style: GoogleFonts.montserrat(
                            textStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 23
                            )
                        ),
                      ),
                      Divider(color: Colors.black,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () => _selectTime(context, fridayStart),
                            child: Container(
                              width: MediaQuery.of(context).size.width/3.3,
                              child: Align(
                                alignment: Alignment.center,
                                child: TextFormField(
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.montserrat(),
                                  controller: fridayStart,
                                  enabled: false,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: fridayStartText,
                                      hintStyle: GoogleFonts.montserrat(textStyle: TextStyle(color: Colors.grey[400]))
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Text(
                            'To',
                            style: GoogleFonts.montserrat(
                                color: Colors.black,
                                fontSize: 15
                            ),
                          ),
                          GestureDetector(
                            onTap: () => _selectTime(context, fridayEnd),
                            child: Container(
                              width: MediaQuery.of(context).size.width/3.3,
                              child: Align(
                                alignment: Alignment.center,
                                child: TextFormField(
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.montserrat(),
                                  controller: fridayEnd,
                                  enabled: false,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: fridayEndText,
                                      hintStyle: GoogleFonts.montserrat(textStyle: TextStyle(color: Colors.grey[400]))
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),



              SizedBox(height: 15),

              Material(
                elevation: 7,
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  padding: EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width/1.3,
                  child: Column(
                    children: [
                      Text(
                        'Saturday',
                        style: GoogleFonts.montserrat(
                            textStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 23
                            )
                        ),
                      ),
                      Divider(color: Colors.black,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () => _selectTime(context, saturdayStart),
                            child: Container(
                              width: MediaQuery.of(context).size.width/3.3,
                              child: Align(
                                alignment: Alignment.center,
                                child: TextFormField(
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.montserrat(),
                                  controller: saturdayStart,
                                  enabled: false,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: saturdayStartText,
                                      hintStyle: GoogleFonts.montserrat(textStyle: TextStyle(color: Colors.grey[400]))
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Text(
                            'To',
                            style: GoogleFonts.montserrat(
                                color: Colors.black,
                                fontSize: 15
                            ),
                          ),
                          GestureDetector(
                            onTap: () => _selectTime(context, saturdayEnd),
                            child: Container(
                              width: MediaQuery.of(context).size.width/3.3,
                              child: Align(
                                alignment: Alignment.center,
                                child: TextFormField(
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.montserrat(),
                                  controller: saturdayEnd,
                                  enabled: false,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: saturdayEndText,
                                      hintStyle: GoogleFonts.montserrat(textStyle: TextStyle(color: Colors.grey[400]))
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),



              SizedBox(height: 15),
              GestureDetector(
                onTap: () {
                  try {
                    Firestore.instance
                        .collection('TimeTable')
                        .document('${widget.classInt}th')
                        .updateData({
                      "mondayStart" : "${mondayStart.text}",
                      "mondayEnd" : "${mondayEnd.text}",

                      "tuesdayStart" : "${tuesdayStart.text}",
                      "tuesdayEnd" : "${tuesdayEnd.text}",

                      "wednesdayStart" : "${wednesdayStart.text}",
                      "wednesdayEnd" : "${wednesdayEnd.text}",

                      "thursdayStart" : "${thursdayStart.text}",
                      "thursdayEnd" : "${thursdayEnd.text}",

                      "fridayStart" : "${fridayStart.text}",
                      "fridayEnd" : "${fridayEnd.text}",

                      "saturdayStart" : "${saturdayStart.text}",
                      "saturdayEnd" : "${saturdayEnd.text}",
                    });
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Updated Successfully!', style: GoogleFonts.montserrat(),)));
                    print("updated");

                  }catch(e)
                  {
                    print(e);
                  }
                },
                child: Material(
                  elevation: 8,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    width: MediaQuery.of(context).size.width/1.3,
                    height: 65,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                        colors: [
                          Colors.blue[200],
                          Colors.blue[400],
                          Colors.blue,
                          Colors.blue[600],
                          Colors.blue[800]
                        ]
                      )
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Update TimeTable',
                        style: GoogleFonts.montserrat(
                          textStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 23
                          )
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15),
            ],
          ),
        ],
      ),
    );
  }

  Future<Null> _selectTime(BuildContext context, TextEditingController controller) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null)
      setState(() {
        selectedTime = picked;
        _hour = selectedTime.hour.toString();
        _minute = selectedTime.minute.toString();
        _time = _hour + ' : ' + _minute;
        controller.text = _time;
      });
  }


}
