import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datewas_education/helper/PDFViewAsset.dart';
import 'package:datewas_education/helper/image_view.dart';
import 'package:datewas_education/helper/pdf_view.dart';
import 'package:datewas_education/services/database.dart';
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

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      if(image != null){
        images.add(image);
        print(images);
        print(image.path);
        imagesNativePath.add(image.path);
      }

    });
  }



  uploadSolutionLoop()
  async{
    try {
      _getTime();
      _getDate();
      for (int i = 0; i < images.length; i++) {
        final StorageReference storageReference = FirebaseStorage().ref().child("multiple2/${imagesNativePath[i].toString()}");

        final StorageUploadTask uploadTask = storageReference.putFile(images[i]);

        final StreamSubscription<StorageTaskEvent> streamSubscription =
        uploadTask.events.listen((event) {
          print('EVENT ${event.type}');
          print(event.snapshot.bytesTransferred / 1000000);
          _setState(() {

            _bytesSend = (event.snapshot.bytesTransferred / 1000000).toStringAsFixed(2);
            print(_bytesSend);

          });
        });

        // Cancel your subscription when done.
        await uploadTask.onComplete;
        streamSubscription.cancel();

        String imageUrl = await storageReference.getDownloadURL();
        setState(() {
          urls.add(imageUrl);
          map['$i'] = '$imageUrl';
          print(map);
        });
        _setState(() {
          _fileSend = _fileSend + 1;
        });


      }

      Map<String, dynamic> userMap = {
        "date": _dateString,
        "time": _timeString,
        "header": questionHeader.text,
        "link": questionLink.text,
        'imageFiles': map,
      };

      databaseMethods.questionUpload(widget.classInt, userMap);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Uploaded successfully!', style: GoogleFonts.montserrat())));
      setState(() {

        _isSend = true;
      });
    } catch (e) {
      print(e);
    }

  }


uploadQuestionLoop()
async{
  try {
    _getTime();
    _getDate();
    for (int i = 0; i < images.length; i++) {
      final StorageReference storageReference = FirebaseStorage().ref().child("multiple2/${imagesNativePath[i].toString()}");

      final StorageUploadTask uploadTask = storageReference.putFile(images[i]);

      final StreamSubscription<StorageTaskEvent> streamSubscription =
      uploadTask.events.listen((event) {
        print('EVENT ${event.type}');
        print(event.snapshot.bytesTransferred / 1000000);
        _setState(() {

          _bytesSend = (event.snapshot.bytesTransferred / 1000000).toStringAsFixed(2);
          print(_bytesSend);

        });
      });

      // Cancel your subscription when done.
      await uploadTask.onComplete;
      streamSubscription.cancel();

      String imageUrl = await storageReference.getDownloadURL();
      setState(() {
        urls.add(imageUrl);
        map['$i'] = '$imageUrl';
        print(map);
      });
      _setState(() {
        _fileSend = _fileSend + 1;
      });


    }

    Map<String, dynamic> userMap = {
      "date": _dateString,
      "time": _timeString,
      "header": questionHeader.text,
      "link": questionLink.text,
      'imageFiles': map,
    };

    databaseMethods.questionUpload(widget.classInt, userMap);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Uploaded successfully!', style: GoogleFonts.montserrat())));
    setState(() {

      _isSend = true;
    });
  } catch (e) {
    print(e);
  }

}
  uploadQuestionFile() async {

    try {
      StorageUploadTask uploadTask = storageReference.putFile(_image);
      await uploadTask.onComplete;
      
      storageReference.getDownloadURL().then((fileURL) {
        setState(() {
          _uploadedFileURL = fileURL;
          print(_uploadedFileURL);
        });
        _getDate();
        _getTime();


        Map<String, String> userMap = {
          "date": _dateString,
          "time": _timeString,
          "header": questionHeader.text,
          "link": questionLink.text,
          "pdf": _uploadedFileURL,
        };


          databaseMethods.questionUpload(widget.classInt, userMap);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Uploaded successfully!', style: GoogleFonts.montserrat())));







      }).onError((error, stackTrace) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Can't Upload to database due to a error - ${error.toString()}", style: GoogleFonts.montserrat(textStyle: TextStyle(color: Colors.redAccent)))));
      });
    }catch(e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Can't Upload to database due to a error - ${e.toString()}", style: GoogleFonts.montserrat(textStyle: TextStyle(color: Colors.redAccent)))));
    }



    }

  uploadSolutionFile() async {

    StorageUploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.onComplete;
    print('File Uploaded');
    storageReference.getDownloadURL().then((fileURL) {
      setState(() {
        _uploadedFileURL = fileURL;
        print(_uploadedFileURL);
      });
      _getDate();
      _getTime();
      Map<String, String> userMap = {
        "date": _dateString,
        "time": _timeString,
        "header": questionHeader.text,
        "link": questionLink.text,
        "pdf": _uploadedFileURL,
      };

      try{
        databaseMethods.solutionUpload(widget.classInt, userMap);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Uploaded successfully!', style: GoogleFonts.montserrat())));
      }catch(e){
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Can't Upload to database", style: GoogleFonts.montserrat(textStyle: TextStyle(color: Colors.redAccent)))));

      }
    });
  }

  pickFile(String text)
  async{
    try {
      FilePickerResult result = await FilePicker.platform.pickFiles();

      if(result != null) {
        File file = File(result.files.single.path);
        setState(() {
          images.add(file);
          imagesNativePath.add(file.path);
          _image = file;
        });
        print(file.path);

      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('pick Canceled', style: GoogleFonts.montserrat())));
      }
    }catch(e)
    {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('pick Canceled due to ${e.toString()}', style: GoogleFonts.montserrat())));

    }
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
        backgroundColor: Colors.tealAccent[200],
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
                      '${widget.classInt}th',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),


        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Material(
                borderRadius: BorderRadius.circular(30),
                elevation: 7,
                child: Container(
                  width: MediaQuery.of(context).size.width/1.3,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.grey[400]
                  ),
                  child: ExpansionTile(
                    trailing: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Colors.white,
                    ),
                    title: Text(
                        'Video Material',
                        style: GoogleFonts.montserrat(
                          textStyle: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold
                          ),
                        )
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
                          onTap: () => uploadVideoMaterial(),


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



        Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(
      children: [
        Material(
          borderRadius: BorderRadius.circular(30),
          elevation: 7,
          child: Container(
            width: MediaQuery.of(context).size.width/1.3,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.grey[400]
            ),
            child: ExpansionTile(
              trailing: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: Colors.white,
              ),
              title: Text(
                  'Question Bank',
                  style: GoogleFonts.montserrat(
                    textStyle: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold
                    ),
                  )
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
                    controller: questionHeader,
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
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  width: MediaQuery.of(context).size.width/1.5,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 3,
                        child: GestureDetector(
                            onTap: () => pickFile('q'),
                            child: Container(
                              height: 50,
                                //margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white54, width: 3),
                                    borderRadius: BorderRadius.circular(12)
                                ),
                                child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      '$attachmentQuestion',
                                      style: GoogleFonts.montserrat(
                                          textStyle: TextStyle(
                                              color: Colors.white54,
                                              fontWeight: FontWeight.bold
                                          )
                                      ),
                                    )
                                )
                            )
                        ),
                      ),

                      SizedBox(width: 10),
                      Expanded(
                        flex: 1,
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.white54, width: 3),
                              borderRadius: BorderRadius.circular(12)
                          ),
                          child: IconButton(
                            onPressed: ()
                            {
                              getImage();
                            },
                            icon: Icon(Icons.camera_alt, color: Colors.grey),
                          ),
                        ),
                      )
                    ],
                  ),
                ),


                SizedBox(height: 30),
            Container(
              width: MediaQuery.of(context).size.width/1.4,
              child: Column(
                children: [
                  images.isEmpty ? Container() : Container(
                    width: MediaQuery.of(context).size.width/1.4,
                    child: Column(
                      children: [
                        Text(
                          'Attachments',
                          style: GoogleFonts.montserrat(
                            textStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[200],
                                fontSize: 20
                            ),

                          ),
                        ),
                        ListView.builder(
                            shrinkWrap: true,
                            itemCount: images.length,
                            itemBuilder: (BuildContext context,int index){
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 8),
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey[300], width: 3),
                                        borderRadius: BorderRadius.circular(10)
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            GestureDetector(
                                              onTap: ()
                                              {
                                                print(imagesNativePath[index]);
                                                if(imagesNativePath[index].contains('jpg'))
                                                  {
                                                    Navigator.push(context, MaterialPageRoute(builder: (context) => ImageView(image: images[index], index: index,)));
                                                  }
                                                else{
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) => PDFViewAsset(file: images[index], index: index,)));
                                                }
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 5),
                                                child: Icon(
                                                  Icons.remove_red_eye,
                                                  color: Colors.white54,
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 10),
                                            Text(
                                              "Image ${index + 1}",
                                              style: GoogleFonts.montserrat(
                                                  textStyle: TextStyle(
                                                      color: Colors.white54,
                                                      fontWeight: FontWeight.bold
                                                  )
                                              ),
                                            ),
                                          ],
                                        ),
                                        IconButton(
                                          onPressed: ()
                                          {
                                            setState(() {
                                              images.removeAt(index);
                                              imagesNativePath.removeAt(index);
                                              print(images);
                                            });
                                          },
                                          icon: Icon(
                                              Icons.clear_rounded,
                                              color: Colors.white54
                                          ),
                                        )

                                      ],
                                    )
                                ),
                              );
                            }
                        ),
                      ],
                    ),
                  )

                ],
              )
            ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: GestureDetector(
                    onTap: () {
                          uploadQuestionLoop();
                          showDialog(
                            // barrierDismissible: false,
                            context: context,

                            builder: (BuildContext context) {

                              return AlertDialog(
                                actions: <Widget>[
                                  _isSend ? TextButton(
                                    child: Text(
                                        'OK',
                                      style: GoogleFonts.montserrat(),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      _fileSend = 0;
                                      _bytesSend = '0';
                                    },
                                  ) : Container(),
                                ],
                                content: StatefulBuilder(
                                  builder: (BuildContext context, StateSetter setState) {
                                    _setState = setState;

                                    return Container(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text('Files sent', style: GoogleFonts.montserrat(),),

                                          Text('${_fileSend.toString()} / ${images.length}', style: GoogleFonts.montserrat(),),
                                          Text('$_bytesSend MB Sent', style: GoogleFonts.montserrat(),)
                                        ],
                                      )
                                    );
                                  },
                                ),
                              );
                            },
                          );
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


                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Material(
                          borderRadius: BorderRadius.circular(30),
                          elevation: 7,
                          child: Container(
                            width: MediaQuery.of(context).size.width/1.3,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Colors.grey[400]
                            ),
                            child: ExpansionTile(
                              trailing: Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: Colors.white,
                              ),
                              title: Text(
                                  'Solutions',
                                  style: GoogleFonts.montserrat(
                                    textStyle: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold
                                    ),
                                  )
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
                                    controller: solutionHeader,
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
                                  margin: EdgeInsets.symmetric(horizontal: 10),
                                  width: MediaQuery.of(context).size.width/1.5,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: GestureDetector(
                                            onTap: () => pickFile('s'),
                                            child: Container(
                                                height: 50,
                                                padding: EdgeInsets.symmetric(horizontal: 10),
                                                decoration: BoxDecoration(
                                                    border: Border.all(color: Colors.white54, width: 3),
                                                    borderRadius: BorderRadius.circular(12)
                                                ),
                                                child: Align(
                                                    alignment: Alignment.centerLeft,
                                                    child: Text(
                                                      '$attachmentQuestion',
                                                      style: GoogleFonts.montserrat(
                                                          textStyle: TextStyle(
                                                              color: Colors.white54,
                                                              fontWeight: FontWeight.bold
                                                          )
                                                      ),
                                                    )
                                                )
                                            )
                                        ),
                                      ),

                                      SizedBox(width: 10),
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                          height: 50,
                                          decoration: BoxDecoration(
                                              border: Border.all(color: Colors.white54, width: 3),
                                              borderRadius: BorderRadius.circular(12)
                                          ),
                                          child: IconButton(
                                            onPressed: ()
                                            {
                                              getImage();
                                            },
                                            icon: Icon(Icons.camera_alt, color: Colors.grey),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),


                                SizedBox(height: 30),
                                Container(
                                    width: MediaQuery.of(context).size.width/1.4,
                                    child: Column(
                                      children: [
                                        images.isEmpty ? Container() : Container(
                                          width: MediaQuery.of(context).size.width/1.4,
                                          child: Column(
                                            children: [
                                              Text(
                                                'Attachments',
                                                style: GoogleFonts.montserrat(
                                                  textStyle: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.grey[200],
                                                      fontSize: 20
                                                  ),

                                                ),
                                              ),
                                              ListView.builder(
                                                  shrinkWrap: true,
                                                  itemCount: images.length,
                                                  itemBuilder: (BuildContext context,int index){
                                                    return Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Container(
                                                          padding: EdgeInsets.symmetric(horizontal: 8),
                                                          decoration: BoxDecoration(
                                                              border: Border.all(color: Colors.grey[300], width: 3),
                                                              borderRadius: BorderRadius.circular(10)
                                                          ),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  GestureDetector(
                                                                    onTap: ()
                                                                    {
                                                                      print(imagesNativePath[index]);
                                                                      if(imagesNativePath[index].contains('jpg'))
                                                                      {
                                                                        Navigator.push(context, MaterialPageRoute(builder: (context) => ImageView(image: images[index], index: index,)));
                                                                      }
                                                                      else{
                                                                        Navigator.push(context, MaterialPageRoute(builder: (context) => PDFViewAsset(file: images[index], index: index,)));
                                                                      }
                                                                    },
                                                                    child: Padding(
                                                                      padding: const EdgeInsets.symmetric(horizontal: 5),
                                                                      child: Icon(
                                                                        Icons.remove_red_eye,
                                                                        color: Colors.white54,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  SizedBox(width: 10),
                                                                  Text(
                                                                    "Image ${index + 1}",
                                                                    style: GoogleFonts.montserrat(
                                                                        textStyle: TextStyle(
                                                                            color: Colors.white54,
                                                                            fontWeight: FontWeight.bold
                                                                        )
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              IconButton(
                                                                onPressed: ()
                                                                {
                                                                  setState(() {
                                                                    images.removeAt(index);
                                                                    imagesNativePath.removeAt(index);
                                                                    print(images);
                                                                  });
                                                                },
                                                                icon: Icon(
                                                                    Icons.clear_rounded,
                                                                    color: Colors.white54
                                                                ),
                                                              )

                                                            ],
                                                          )
                                                      ),
                                                    );
                                                  }
                                              ),
                                            ],
                                          ),
                                        )

                                      ],
                                    )
                                ),
                                SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 15),
                                  child: GestureDetector(
                                    onTap: () {
                                      uploadSolutionLoop();
                                      showDialog(
                                        // barrierDismissible: false,
                                        context: context,

                                        builder: (BuildContext context) {

                                          return AlertDialog(
                                            actions: <Widget>[
                                              _isSend ? TextButton(
                                                child: Text(
                                                  'OK',
                                                  style: GoogleFonts.montserrat(),
                                                ),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                  _fileSend = 0;
                                                  _bytesSend = '0';
                                                },
                                              ) : Container(),
                                            ],
                                            content: StatefulBuilder(
                                              builder: (BuildContext context, StateSetter setState) {
                                                _setState = setState;

                                                return Container(
                                                    child: Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        Text('Files sent', style: GoogleFonts.montserrat(),),

                                                        Text('${_fileSend.toString()} / ${images.length}', style: GoogleFonts.montserrat(),),
                                                        Text('$_bytesSend MB Sent', style: GoogleFonts.montserrat(),)
                                                      ],
                                                    )
                                                );
                                              },
                                            ),
                                          );
                                        },
                                      );
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




        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Material(
                borderRadius: BorderRadius.circular(30),
                elevation: 7,
                child: Container(
                  width: MediaQuery.of(context).size.width/1.3,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.grey[400]
                  ),
                  child: ExpansionTile(
                    trailing: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Colors.white,
                    ),
                    title: Text(
                        'Zoom Link',
                        style: GoogleFonts.montserrat(
                          textStyle: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold
                          ),
                        )
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
                          onTap: () => uploadZoomLink(),


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





                  // workSelection('Video Material', videoMaterialHeader, videoMaterialLink, false, uploadVideoMaterial, pickFile ,context),
                  // workSelection('Question Bank', questionHeader, questionLink, true, uploadQuestionFile, pickFile, context),
                  // workSelection('Solutions', solutionHeader, solutionLink, true, uploadSolutionFile, pickFile, context),
                  // workSelection('Zoom Link', zoomHeader, zoomLink, false, uploadZoomLink, pickFile , context),

                ],
            ),
          ],
        ),
      ),
    );
  }




}

class ImageTile extends StatefulWidget {
  final List<File> imageList;
  ImageTile({this.imageList});
  @override
  _ImageTileState createState() => _ImageTileState();
}

class _ImageTileState extends State<ImageTile> {

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20,
      width: 20,
      child: ListView.builder(
        shrinkWrap: true,
          itemCount: (widget.imageList).length,
          itemBuilder: (BuildContext context,int index){
            return GestureDetector(
              onTap: ()
              {},
              child: Container(
                color: Colors.tealAccent[100],
              ),
            );
          }
      ),
    );
  }
}
