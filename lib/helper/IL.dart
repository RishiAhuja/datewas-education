import 'dart:async';
import 'dart:io';

import 'package:datewas_education/helper/PDFViewAsset.dart';
import 'package:datewas_education/helper/image_view.dart';
import 'package:datewas_education/services/database.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class ImpL extends StatefulWidget {

  @override
  _ImpLState createState() => _ImpLState();
}
List _selectedFiles = [];
List _selectedExtention = [];
List _selectedPath = [];
List urls = [];

String _timeString;
String _dateString;


String _uploadedFileURL;
String _bytesSend;
int _fileSend = 0;
bool _isSend = false;

StateSetter _setState;



final Map<String, String> map = {

};

class _ImpLState extends State<ImpL> {
  bool _isSyllabus = false;
  final picker = ImagePicker();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController controller = TextEditingController();
  TextEditingController linkController = TextEditingController();
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
      print(_timeString);
    });
  }

  pickFile() async {
    try {
      FilePickerResult result = await FilePicker.platform.pickFiles();

      if (result != null) {
        File file = File(result.files.single.path);
        setState(() {
          _selectedFiles.add(file);
          _selectedPath.add(file.path);
          if (file.path.contains('jpg') ||
              file.path.contains('png') ||
              file.path.contains('jpeg')) {
            _selectedExtention.add("image");
            print("added");
          }
          if (file.path.contains('pdf')) {
            _selectedExtention.add("pdf");
          }
        });
        print(file.path);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Pick Canceled', style: GoogleFonts.montserrat())));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Pick Canceled due to ${e.toString()}',
              style: GoogleFonts.montserrat())));
    }
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      if (image != null) {
        _selectedFiles.add(image);
        print(_selectedFiles);
        print(image.path);
        _selectedPath.add(image.path);

        if (image.path.contains('jpg') ||
            image.path.contains('png') ||
            image.path.contains('jpeg')) {
          _selectedExtention.add("image");
          print("added");
        }
        if (image.path.contains('pdf')) {
          _selectedExtention.add("pdf");
        }
      }
    });
  }


  uploadLoop()
  async{
    try {
      _getTime();
      _getDate();
       Map<String, dynamic> userMap = {
        "date": _dateString,
        "time": _timeString,
        "header": controller.text,
        "link": linkController.text,
      };

      databaseMethods.IL(userMap);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Uploaded successfully!', style: GoogleFonts.montserrat())));


    } catch (e) {
      print(e);
    }

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _isSend = false;
    });
    _selectedFiles.clear();
    _selectedExtention.clear();
    _selectedPath.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: Colors.black,
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        child: ListView(
          shrinkWrap: true,
          children: [
            Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  child: Material(
                    elevation: 7,
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      width: MediaQuery.of(context).size.width / 1.3,
                      height: 65,
                      child: TextFormField(
                        controller: controller,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Header..',
                            hintStyle: GoogleFonts.montserrat(
                                textStyle: TextStyle(color: Colors.grey[400]))),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),

                Container(
                  alignment: Alignment.center,
                  child: Material(
                    elevation: 7,
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      width: MediaQuery.of(context).size.width / 1.3,
                      height: 65,
                      child: TextFormField(
                        controller: linkController,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Link..',
                            hintStyle: GoogleFonts.montserrat(
                                textStyle: TextStyle(color: Colors.grey[400]))),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20),

                Container(
                  width: MediaQuery.of(context).size.width / 1.3,
                  child: Column(
                    children: [
                      _selectedFiles.length != 0 ? Container(
                        margin: EdgeInsets.symmetric(vertical: 25, ),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Attachments',
                          style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 23)),
                        ),
                      ) : Container(),


                      GestureDetector(
                        onTap: () {
                          uploadLoop();
                        },
                        child: Container(
                            margin: EdgeInsets.symmetric(vertical: 25, ),
                            alignment: Alignment.center,
                            child: Material(
                              elevation: 7,
                              borderRadius: BorderRadius.circular(7),
                              child: Container(
                                height: 60,
                                width: MediaQuery.of(context).size.width/1.5,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(7),
                                  gradient: LinearGradient(
                                      colors: [
                                        Colors.blue[800],
                                        Colors.blue[900]
                                      ]
                                  ),

                                ),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Upload',
                                    style: GoogleFonts.montserrat(
                                        textStyle: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 23)),
                                  ),
                                ),
                              ),
                            )
                        ),
                      ),

                    ],
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
