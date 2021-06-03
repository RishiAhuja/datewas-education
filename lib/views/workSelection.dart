import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datewas_education/helper/PDFViewAsset.dart';
import 'package:datewas_education/helper/TimeTableUpload.dart';
import 'package:datewas_education/helper/image_view.dart';
import 'package:datewas_education/helper/pdf_view.dart';
import 'package:datewas_education/helper/updateTextBook.dart';
import 'package:datewas_education/helper/yearMonth.dart';
import 'package:datewas_education/services/database.dart';
import 'package:datewas_education/views/topicApp.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as Path;


class WorkSelection extends StatefulWidget {

  final classInt;
  WorkSelection({this.classInt});
  @override
  _WorkSelectionState createState() => _WorkSelectionState();
}

String _timeString;
String _dateString;
String _uploadedFileURL;
String _bytesSend;
int _fileSend = 0;
bool _isSend = false;

StateSetter _setState;



File _image;
List <String> imagesNativePath = [];
List<File> images = [];
List urls = [];

String attachmentSolution = 'Attachment..';
String attachmentQuestion = 'Attachment..';

StorageReference storageReference = FirebaseStorage.instance
    .ref()
    .child('chats/${Path.basename(_image.path)}}');


final Map<String, String> map = {

};



class _WorkSelectionState extends State<WorkSelection> {
  final Firestore _db = Firestore.instance;

  final FirebaseMessaging _fcm = FirebaseMessaging();
  
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final picker = ImagePicker();

  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController videoMaterialHeader = new TextEditingController();
  TextEditingController videoMaterialLink = new TextEditingController();

  TextEditingController questionHeader = new TextEditingController();
  TextEditingController questionLink = new TextEditingController();

  TextEditingController solutionHeader = new TextEditingController();
  TextEditingController solutionLink = new TextEditingController();

  TextEditingController zoomHeader = new TextEditingController();
  TextEditingController zoomLink = new TextEditingController();



  void _getDate() {
    final String formattedDateTime =
    DateFormat('dd-MM-yy').format(DateTime.now()).toString();
    setState(() {
      _dateString = formattedDateTime;
      print(_dateString);
    });
  }

  void _getTime() {
    final String formattedDateTime =
    DateFormat('kk:mm:ss').format(DateTime.now()).toString();
    setState(() {
      _timeString = formattedDateTime;
      print(_timeString);
    });
  }

  uploadVideoMaterial()
  {
    _getDate();
    _getTime();

    Map<String, String> userMap = {
      "date": _dateString,
      "time": _timeString,
      "header": videoMaterialHeader.text,
      "link": videoMaterialLink.text,
  };

    try{
      databaseMethods.videoMaterialUpload(widget.classInt, userMap);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Uploaded successfully!', style: GoogleFonts.montserrat())));
    }catch(e){
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Can't Upload to database", style: GoogleFonts.montserrat(textStyle: TextStyle(color: Colors.redAccent)))));

    }
  }


  uploadZoomLink()
  {
    _getDate();
    _getTime();

    Map<String, String> userMap = {
      "date": _dateString,
      "time": _timeString,
      "header": zoomHeader.text,
      "link": zoomLink.text,
    };

    try{
      databaseMethods.zoomUpload(widget.classInt, userMap);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Uploaded successfully!', style: GoogleFonts.montserrat())));
    }catch(e){
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Can't Upload to database", style: GoogleFonts.montserrat(textStyle: TextStyle(color: Colors.redAccent)))));

    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(color: Colors.black, icon: Icon(Icons.arrow_back_ios_outlined), onPressed: () => Navigator.pop(context),),
      ),
      body: Container(
        child: ListView(
          shrinkWrap: true,
          children: [
            Column(
                children: [
                  //Container(child: _uploadStatus(storageReference)),
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      '${widget.classInt}th Class',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          color: Colors.black
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),



                  GestureDetector(
                    onTap: ()
                    {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ShowTextBook(classInt: widget.classInt,)));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Material(
                            borderRadius: BorderRadius.circular(6),
                            elevation: 7,
                            child: Container(
                              width: MediaQuery.of(context).size.width/1.3,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  color: Colors.blue[900]
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                      'Text Books',
                                      style: GoogleFonts.montserrat(
                                        textStyle: TextStyle(
                                            fontSize: 20,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold
                                        ),
                                      )
                                  ),
                                ),
                              ),
                            ),


                          )
                        ],
                      ),
                    ),
                  ),




                  GestureDetector(
                    onTap: ()
                    {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => YearMonthly(classInt: widget
                          .classInt,)));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Material(
                            borderRadius: BorderRadius.circular(6),
                            elevation: 7,
                            child: Container(
                              width: MediaQuery.of(context).size.width/1.3,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  color: Colors.blue[900]
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                      'Syllabus',
                                      style: GoogleFonts.montserrat(
                                        textStyle: TextStyle(
                                            fontSize: 20,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold
                                        ),
                                      )
                                  ),
                                ),
                              ),
                            ),


                          )
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: ()
                    {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => TopicAdd(collection: '${widget.classInt}TM', classInt: widget
                          .classInt,)));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Material(
                            borderRadius: BorderRadius.circular(6),
                            elevation: 7,
                            child: Container(
                              width: MediaQuery.of(context).size.width/1.3,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  color: Colors.blue[900]
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                      'Text Material',
                                      style: GoogleFonts.montserrat(
                                        textStyle: TextStyle(
                                            fontSize: 20,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold
                                        ),
                                      )
                                  ),
                                ),
                              ),
                            ),


                          )
                        ],
                      ),
                    ),
                  ),



        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Material(
                borderRadius: BorderRadius.circular(6),
                elevation: 7,
                child: Container(
                  width: MediaQuery.of(context).size.width/1.3,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: Colors.blue[900]
                  ),
                  child: ExpansionTile(
                    onExpansionChanged: (val) {
                      val = false;
                      print(val);
                    },
                    trailing: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Colors.white,
                    ),
                    title: Align(
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Opacity(opacity: 0, child: Icon(Icons.keyboard_arrow_down_sharp)),
                          Text(
                              'Video Material',
                              style: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold
                                ),
                              )
                          ),
                        ],
                      ),
                    ),
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.fromLTRB(20, 20, 20, 10),
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white54, width: 3),
                            borderRadius: BorderRadius.circular(12)
                        ),
                        child: TextFormField(
                          controller: videoMaterialHeader,
                          decoration: InputDecoration(
                              hintText: 'Header...',
                              hintStyle: GoogleFonts.montserrat(
                                  textStyle: TextStyle(
                                      color: Colors.white54,
                                      fontWeight: FontWeight.bold
                                  )
                              ),
                              border: InputBorder.none
                          ),
                        ),
                      ),


                      Container(
                        margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white54, width: 3),
                            borderRadius: BorderRadius.circular(12)
                        ),
                        child: TextFormField(
                          controller: videoMaterialLink,
                          decoration: InputDecoration(
                              hintText: 'Link...',
                              hintStyle: GoogleFonts.montserrat(
                                  textStyle: TextStyle(
                                      color: Colors.white54,
                                      fontWeight: FontWeight.bold
                                  )
                              ),
                              border: InputBorder.none
                          ),
                        ),
                      ),

                      SizedBox(height: 10),

                      Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: GestureDetector(
                          onTap: () {
                           uploadVideoMaterial();
                           setState(() {
                             videoMaterialHeader.text = '';
                             videoMaterialLink.text = "";
                           });
                          },


                          child: Material(
                            borderRadius: BorderRadius.circular(10),
                            elevation: 7,
                            child: Container(
                              height: 55,
                              width: MediaQuery.of(context).size.width/2,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: LinearGradient(
                                      colors: [
                                        Colors.blue[300],
                                        Colors.blue
                                      ]
                                  )
                              ),
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                      'Upload',
                                      style: GoogleFonts.montserrat(
                                        textStyle: TextStyle(
                                            fontSize: 20,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold
                                        ),
                                      )
                                  )
                              ),
                            ),
                          ),
                        ),
                      ),




                    ],
                  ),
                ),
              ),



            ],
          ),
        ),




        GestureDetector(
          onTap: () 
          {
            Navigator.push(context, MaterialPageRoute(builder: (context) => TopicAdd(collection: '${widget.classInt}thQuestionBank', classInt: widget
              .classInt,)));
          },
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Material(
                    borderRadius: BorderRadius.circular(6),
                    elevation: 7,
                    child: Container(
                      width: MediaQuery.of(context).size.width/1.3,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: Colors.blue[900]
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                              'Daily Assignment',
                              style: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold
                                ),
                              )
                          ),
                        ),
                      ),
                      ),


                        )
                        ],
                      ),
                    ),
        ),


                  GestureDetector(
                    onTap: ()
                    {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => TopicAdd(collection: '${widget.classInt}thSolution', classInt: widget
                          .classInt,)));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Material(
                            borderRadius: BorderRadius.circular(6),
                            elevation: 7,
                            child: Container(
                              width: MediaQuery.of(context).size.width/1.3,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  color: Colors.blue[900]
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                      'Assignment Solutions',
                                      style: GoogleFonts.montserrat(
                                        textStyle: TextStyle(
                                            fontSize: 20,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold
                                        ),
                                      )
                                  ),
                                ),
                              ),
                            ),


                          )
                        ],
                      ),
                    ),
                  ),

        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Material(
                borderRadius: BorderRadius.circular(6),
                elevation: 7,
                child: Container(
                  width: MediaQuery.of(context).size.width/1.3,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: Colors.blue[900]
                  ),
                  child: ExpansionTile(
                    trailing: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Colors.white,
                    ),
                    title: Align(
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Opacity(opacity: 0, child: Icon(Icons.keyboard_arrow_down_sharp)),
                          Text(
                              'Zoom Link',
                              style: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold
                                ),
                              )
                          ),
                        ],
                      ),
                    ),
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.fromLTRB(20, 20, 20, 10),
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white54, width: 3),
                            borderRadius: BorderRadius.circular(12)
                        ),
                        child: TextFormField(
                          controller: zoomHeader,
                          decoration: InputDecoration(
                              hintText: 'Header...',
                              hintStyle: GoogleFonts.montserrat(
                                  textStyle: TextStyle(
                                      color: Colors.white54,
                                      fontWeight: FontWeight.bold
                                  )
                              ),
                              border: InputBorder.none
                          ),
                        ),
                      ),


                      Container(
                        margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white54, width: 3),
                            borderRadius: BorderRadius.circular(12)
                        ),
                        child: TextFormField(
                          controller: zoomLink,
                          decoration: InputDecoration(
                              hintText: 'Link...',
                              hintStyle: GoogleFonts.montserrat(
                                  textStyle: TextStyle(
                                      color: Colors.white54,
                                      fontWeight: FontWeight.bold
                                  )
                              ),
                              border: InputBorder.none
                          ),
                        ),
                      ),

                      SizedBox(height: 10),

                      Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: GestureDetector(
                          onTap: () {
                            uploadZoomLink();
                            setState(() {
                              zoomHeader.text = '';
                              zoomLink.text = '';
                            });
                          },

                          child: Material(
                            borderRadius: BorderRadius.circular(10),
                            elevation: 7,
                            child: Container(
                              height: 55,
                              width: MediaQuery.of(context).size.width/2,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: LinearGradient(
                                      colors: [
                                        Colors.blue[300],
                                        Colors.blue
                                      ]
                                  )
                              ),
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                      'Upload',
                                      style: GoogleFonts.montserrat(
                                        textStyle: TextStyle(
                                            fontSize: 20,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold
                                        ),
                                      )
                                  )
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),



            ],
          ),
        ),



                  GestureDetector(
                    onTap: ()
                    {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => TopicAdd(collection: '${widget.classInt}PYQ', classInt: widget
                          .classInt,)));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Material(
                            borderRadius: BorderRadius.circular(6),
                            elevation: 7,
                            child: Container(
                              width: MediaQuery.of(context).size.width/1.3,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  color: Colors.blue[900]
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                      'Question Bank',
                                      style: GoogleFonts.montserrat(
                                        textStyle: TextStyle(
                                            fontSize: 20,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold
                                        ),
                                      )
                                  ),
                                ),
                              ),
                            ),


                          )
                        ],
                      ),
                    ),
                  ),

                  GestureDetector(
                    onTap: ()
                    {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => TimeTable(classInt: widget.classInt,)));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Material(
                            borderRadius: BorderRadius.circular(6),
                            elevation: 7,
                            child: Container(
                              width: MediaQuery.of(context).size.width/1.3,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  color: Colors.blue[900]
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                      'Time Table',
                                      style: GoogleFonts.montserrat(
                                        textStyle: TextStyle(
                                            fontSize: 20,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold
                                        ),
                                      )
                                  ),
                                ),
                              ),
                            ),


                          )
                        ],
                      ),
                    ),
                  ),


                ],
            ),
          ],
        ),
      ),
    );
  }
}
