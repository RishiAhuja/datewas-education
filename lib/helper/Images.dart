import 'dart:async';
import 'dart:io';

import 'package:datewas_education/helper/NetworkImage.dart';
import 'package:datewas_education/helper/PDFViewAsset.dart';
import 'package:datewas_education/helper/image_view.dart';
import 'package:datewas_education/helper/pdf_view.dart';
import 'package:datewas_education/services/database.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

bool _isSend = false;

StateSetter _setState;



File _image;
List <String> imagesNativePath = [];
List<File> images = [];
List urls = [];
String _timeString;
String _dateString;
String _uploadedFileURL;
String _bytesSend;
int _fileSend = 0;

List _selectedFiles = [];
List _selectedExtentions = [];

class NetworkImages extends StatefulWidget {
  final urls;
  final String topic;
  final String date;
  final String time;
  NetworkImages({this.urls, this.topic, this.date, this.time});

  @override
  _NetworkImagesState createState() => _NetworkImagesState();
}

class _NetworkImagesState extends State<NetworkImages> {
  DatabaseMethods databaseMethods = new DatabaseMethods();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final picker = ImagePicker();

  List _links = [];
  List _extention = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.urls);

    RegExp exp = new RegExp(
        r"((https?:www\.)|(https?:\/\/)|(www\.))[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9]{1,6}(\/[-a-zA-Z0-9()@:%_\+.~#?&\/=]*)?");
    Iterable<RegExpMatch> matches = exp.allMatches('${widget.urls}');

    matches.forEach((match) {
      //print('${widget.urls}'.substring(match.start, match.end));
      _links.add('${widget.urls}'.substring(match.start, match.end));
      if('${widget.urls}'.substring(match.start, match.end).contains('jpg') || '${widget.urls}'.substring(match.start, match.end).contains('jpeg') || '${widget.urls}'.substring(match.start, match.end).contains('png')){
        _extention.add("image");
      }

      if('${widget.urls}'.substring(match.start, match.end).contains('pdf')){
        _extention.add("pdf");
      }

    });




  }

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
        _selectedFiles.add(image);
        print(image.path);
        _selectedExtentions.add('image');
      }

    });
  }

  pickFile()
  async{
    try {
      FilePickerResult result = await FilePicker.platform.pickFiles();

      if(result != null) {
        File file = File(result.files.single.path);
        setState(() {
          _selectedFiles.add(file);
          _selectedExtentions.add('pdf');
        });
        print(file.path);

      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Pick Canceled', style: GoogleFonts.montserrat())));
      }
    }catch(e)
    {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('pick Canceled due to ${e.toString()}', style: GoogleFonts.montserrat())));

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

        // String imageUrl = await storageReference.getDownloadURL();
        // setState(() {
        //   urls.add(imageUrl);
        //   map['$i'] = '$imageUrl';
        //   print(map);
        // });
        // _setState(() {
        //   _fileSend = _fileSend + 1;
        // });


      }

      // Map<String, dynamic> userMap = {
      //   "date": _dateString,
      //   "time": _timeString,
      //   "header": questionHeader.text,
      //   "link": questionLink.text,
      //   'imageFiles': map,
      // };

      //databaseMethods.questionUpload(widget.classInt, userMap);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Uploaded successfully!', style: GoogleFonts.montserrat())));
      setState(() {

        _isSend = true;
      });
    } catch (e) {
      print(e);
    }

  }


  @override
  Widget build(BuildContext context) {
    // return Container();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          Column(
            children: [
              Container(
                padding: EdgeInsets.only(left: 20),
                child: Row(
                  children: [
                    Icon(Icons.menu_book, color: Colors.teal),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                                'Topic',
                                style:  GoogleFonts.montserrat(
                                    textStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: 22,

                                    )
                                )
                            )
                        ),
                        SizedBox(height: 5),
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                                '${widget.topic}',
                                style:  GoogleFonts.montserrat(
                                    textStyle: TextStyle(
                                      color: Colors.black45,
                                      fontSize: 20,

                                    )
                                )
                            )
                        )


                      ],
                    )
                  ],
                ),
              ),


              SizedBox(height: 20),

              Container(
                padding: EdgeInsets.only(left: 20),
                child: Row(
                  children: [
                    Icon(Icons.watch_later, color: Colors.teal),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                                'Test date and time',
                                style:  GoogleFonts.montserrat(
                                    textStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: 22,

                                    )
                                )
                            )
                        ),
                        SizedBox(height: 5),
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                                '${widget.date} at ${widget.time}',
                                style:  GoogleFonts.montserrat(
                                    textStyle: TextStyle(
                                      color: Colors.black45,
                                      fontSize: 20,

                                    )
                                )
                            )
                        )


                      ],
                    )
                  ],
                ),
              ),




              SizedBox(height: 20,),
              Container(
                padding: EdgeInsets.only(left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.attach_file_sharp, color: Colors.teal),
                        SizedBox(width: 10),
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                                'Attachments',
                                style:  GoogleFonts.montserrat(
                                    textStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: 22,

                                    )
                                )
                            )
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Container(
                      width: MediaQuery.of(context).size.width/1.3,
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: ListView.builder(
                            shrinkWrap: true,
                              itemCount: _links.length,
                              itemBuilder: (BuildContext context, int index){
                              return GestureDetector(
                                onTap: ()
                                {
                                  if(_extention[index] == 'pdf')
                                    {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => PDFView(text: 'PDF ${index + 1}', url: _links[index],)));
                                    }
                                  if(_extention[index] == 'image')
                                  {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => NetworkImageView(index: index, url: _links[index])));
                                  }
                                },
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                  width: MediaQuery.of(context).size.width/1.3,
                                  decoration: BoxDecoration(
                                    color: Colors.teal[200],
                                    borderRadius: BorderRadius.circular(10),

                                  ),
                                  child: Row(
                                    children: [
                                      _extention[index] == 'pdf' ? Icon(Icons.picture_as_pdf, color: Colors.white) : Icon(Icons.image, color: Colors.white),
                                      SizedBox(width: 7),
                                      Text(
                                          'File ${index + 1}',
                                        style: GoogleFonts.montserrat(
                                          textStyle: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold
                                          )
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                          ),
                      ),
                    ),








                  ],
                ),
              ),


            SizedBox(height: 20),

              Container(
                padding: EdgeInsets.only(left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.send_sharp, color: Colors.teal),
                        SizedBox(width: 10),
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                                'Submissions',
                                style:  GoogleFonts.montserrat(
                                    textStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: 22,

                                    )
                                )
                            )
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    GestureDetector(
                      onTap: ()
                      {
                        showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: Text('Select Files', style: GoogleFonts.montserrat(),),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  GestureDetector(
                                    onTap: () => getImage(),
                                    child: SizedBox(
                                      height: 50,
                                      width: MediaQuery.of(context).size.width/2,
                                      child: Material(
                                        elevation: 7,
                                        borderRadius: BorderRadius.circular(10),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.camera_alt),
                                            SizedBox(width: 10),
                                            Text(
                                              'Camera',
                                              style: GoogleFonts.montserrat(textStyle: TextStyle(fontSize: 20)),
                                            ),
                                          ],
                                        )
                                      ),
                                    ),
                                  ),

                                  SizedBox(height: 20),


                                  GestureDetector(
                                    onTap: () => pickFile(),
                                    child: SizedBox(
                                      height: 50,
                                      width: MediaQuery.of(context).size.width/2,
                                      child: Material(
                                          elevation: 7,
                                          borderRadius: BorderRadius.circular(10),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.image),
                                              SizedBox(width: 10),
                                              Text(
                                                'Gallery',
                                                style: GoogleFonts.montserrat(textStyle: TextStyle(fontSize: 20)),
                                              ),
                                            ],
                                          )
                                      ),
                                    ),
                                  )




                                ],
                              ),
                            )
                        );
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width/1.3,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: Colors.teal, width: 2)
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.attach_file_rounded, color: Colors.black),
                                SizedBox(width: 8),
                                Text(
                                  'Attach Files',
                                  style: GoogleFonts.montserrat(
                                   textStyle: TextStyle(
                                     color: Colors.black,
                                     fontSize: 20
                                   )
                                  )
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),



                    Container(
                      width: MediaQuery.of(context).size.width/1.3,
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: _selectedFiles.length,
                          itemBuilder: (BuildContext context, int index){
                            return GestureDetector(
                              onTap: ()
                              {
                                if(_selectedExtentions[index] == 'pdf')
                                {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => PDFViewAsset(file: _selectedFiles[index], index: index,)));
                                }
                                if(_selectedExtentions[index] == 'image')
                                {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => ImageView(index: index, image: _selectedFiles[index])));
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.only(left: 10),
                                margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                width: MediaQuery.of(context).size.width/1.3,
                                decoration: BoxDecoration(
                                  color: Colors.teal[200],
                                  borderRadius: BorderRadius.circular(10),

                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        _selectedExtentions[index] == 'pdf' ? Icon(Icons.picture_as_pdf, color: Colors.white) : Icon(Icons.image, color: Colors.white),
                                        SizedBox(width: 7),
                                        Text(
                                          'File ${index + 1}',
                                          style: GoogleFonts.montserrat(
                                              textStyle: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold
                                              )
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      child: IconButton(
                                        icon: Icon(Icons.clear, color: Colors.white),
                                        onPressed: ()
                                        {
                                          _selectedFiles.removeAt(index);
                                        },
                                      ),
                                    )

                                  ],
                                ),
                              ),
                            );
                          }
                      ),
                    ),

                    Container(
                      child: _selectedFiles != null ? Text("submit") : Container(),
                    )



                  ],
                ),
              ),













            ],
          )
        ],
      )
    );
  }
}
