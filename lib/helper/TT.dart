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

class TodayT extends StatefulWidget {

  @override
  _TodayTState createState() => _TodayTState();
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

class _TodayTState extends State<TodayT> {
  bool _isSyllabus = false;
  final picker = ImagePicker();
  final uploadStream = StreamController();
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
      for (int i = 0; i < _selectedFiles.length; i++) {
        final StorageReference storageReference = FirebaseStorage().ref().child("multiple4/${_selectedPath[i].toString()}");

        final StorageUploadTask uploadTask = storageReference.putFile(_selectedFiles[i]);

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
        _setState(() {
          urls.add(imageUrl);
          map['$i'] = '$imageUrl';
          print(map);
        });
        setState(() {
          _fileSend = _fileSend + 1;
        });


      }

      Map<String, dynamic> userMap = {
        "date": _dateString,
        "time": _timeString,
        "header": controller.text,
        "link": linkController.text,
        'imageFiles': map,
      };

      databaseMethods.todayT(userMap);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Uploaded successfully!', style: GoogleFonts.montserrat())));
      _setState(() {
        _fileSend = 0;
        _isSend = true;
      });
      setState(() {
        _isSend = true;
      });
      Navigator.pop(context);
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

                GestureDetector(
                  onTap: () => pickFile(),
                  child: Container(
                    width: MediaQuery.of(context).size.width / 1.3,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Container(
                            alignment: Alignment.center,
                            child: Material(
                              elevation: 7,
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                              child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 20),
                                  height: 65,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text('Attachment..',
                                        style: GoogleFonts.montserrat(
                                            textStyle: TextStyle(
                                                color: Colors.grey[400]))),
                                  )),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Expanded(
                          flex: 1,
                          child: Material(
                            elevation: 7,
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                            child: Container(
                                height: 65,
                                child: IconButton(
                                    icon: Icon(Icons.camera_alt),
                                    onPressed: () => getImage())),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
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
                      ListView.builder(
                          shrinkWrap: true,
                          itemCount: _selectedFiles.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Column(
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width / 1.3,
                                  child: GestureDetector(
                                    onTap: ()
                                    {
                                      if(_selectedExtention[index] == 'image')
                                      {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => ImageView(image: _selectedFiles[index], index: index,)));
                                      }

                                      if(_selectedExtention[index] == 'pdf')
                                      {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => PDFViewAsset(file: _selectedFiles[index], index: index + 1,)));
                                      }
                                    },
                                    child: Material(
                                      borderRadius: BorderRadius.circular(10),
                                      elevation: 7,
                                      color: Colors.white,
                                      child: Container(
                                          width: MediaQuery.of(context).size.width / 1.3,
                                          child: Container(
                                            child: Column(
                                              children: [
                                                _selectedExtention[index] == 'image'
                                                    ? Padding(
                                                  padding: const EdgeInsets.only(top: 20),
                                                  child: Image.file(
                                                    _selectedFiles[index],
                                                    fit: BoxFit.cover,
                                                    height: 45,
                                                    width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                        1.5,
                                                  ),
                                                )
                                                    : Container(),
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      _selectedExtention[index] == 'image'
                                                          ? Padding(
                                                        padding:
                                                        const EdgeInsets.all(8.0),
                                                        child: Text(
                                                          "Image ${index + 1}",
                                                          style: GoogleFonts.montserrat(
                                                              textStyle: TextStyle(
                                                                  fontWeight:
                                                                  FontWeight.bold,
                                                                  color: Colors.black,
                                                                  fontSize: 19)),
                                                        ),
                                                      )
                                                          : Padding(
                                                        padding:
                                                        const EdgeInsets.all(8.0),
                                                        child: Text(
                                                          "PDF ${index + 1}",
                                                          style: GoogleFonts.montserrat(
                                                              textStyle: TextStyle(
                                                                  fontWeight:
                                                                  FontWeight.bold,
                                                                  color: Colors.black,
                                                                  fontSize: 19)),
                                                        ),
                                                      ),


                                                      IconButton(
                                                        icon: Icon(Icons.clear),
                                                        onPressed: ()
                                                        {
                                                          setState(() {
                                                            _selectedPath.removeAt(index);
                                                            _selectedExtention.removeAt(index);
                                                            _selectedFiles.removeAt(index);
                                                          });
                                                        },
                                                      )
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          )),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10)
                              ],
                            );
                          }),

                      GestureDetector(
                        onTap: () {
                          uploadLoop();
                          showDialog(
                            barrierDismissible: false,
                            context: context,

                            builder: (BuildContext context) {

                              return AlertDialog(
                                // actions: <Widget>[
                                //   _isSend ? TextButton(
                                //     child: Text(
                                //       'OK',
                                //       style: GoogleFonts.montserrat(),
                                //     ),
                                //     onPressed: () {
                                //       Navigator.of(context).pop();
                                //       _fileSend = 0;
                                //       _bytesSend = '0';
                                //     },
                                //   ) : Container(),
                                // ],
                                content: StatefulBuilder(
                                  builder: (BuildContext context, StateSetter setState) {
                                    _setState = setState;
                                    return Container(width: 70, height: 70, child: Center(child: CircularProgressIndicator()));

                                    // return Container(
                                    //     child: Column(
                                    //       mainAxisSize: MainAxisSize.min,
                                    //       children: [
                                    //         Text('Files sent', style: GoogleFonts.montserrat(),),
                                    //
                                    //         Text('${_fileSend.toString()} / ${_selectedFiles.length}', style: GoogleFonts.montserrat(),),
                                    //         Text('$_bytesSend MB Sent', style: GoogleFonts.montserrat(),)
                                    //       ],
                                    //     )
                                    // );
                                  },
                                ),
                              );
                            },
                          );
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
