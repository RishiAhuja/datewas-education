import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
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
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

bool _isSend = false;





File _image;
List <String> imagesNativePath = [];
List<File> images = [];
List urls = [];
String _timeString;
String _dateString;
String _uploadedFileURL;
double _bytesSend = 0.0;
int _fileSend = 0;

List _selectedFiles = [];
List _selectedExtentions = [];
List _selectedPath = [];

final Map<String, String> map = {

};



class NetworkImages extends StatefulWidget {
  GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  final urls;
  final String topic;
  final String date;
  final String time;
  final String uploadTask;
  final int classText;
  final bool isSyllabus;
  final String link;
  NetworkImages({this.urls, this.topic, this.date, this.time, this.uploadTask, this.link, this.classText, this.isSyllabus});

  @override
  _NetworkImagesState createState() => _NetworkImagesState();
}

class _NetworkImagesState extends State<NetworkImages> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  StateSetter _setState;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final picker = ImagePicker();

  List _links = [];
  List _extention = [];
  String userName;
  String punjab;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserValueSF();
    getPunjabValueSF();
    print(widget.urls);

    RegExp exp = new RegExp(
        r"((https?:www\.)|(https?:\/\/)|(www\.))[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9]{1,6}(\/[-a-zA-Z0-9()@:%_\+.~#?&\/=]*)?");
    Iterable<RegExpMatch> matches = exp.allMatches('${widget.urls}');

    matches.forEach((match) {
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
        _selectedPath.add(image.path.split("/").last);
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
          _selectedPath.add(file.path.split("/").last);
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

  getPunjabValueSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    String _punjab = prefs.getString('e-punjab');
    print(_punjab);
    if(_punjab != null)
    {
      setState(() {
        punjab = _punjab;
      });
    }
    return _punjab;
  }


  uploadSubmission()
  async{
    try {
      _getTime();
      _getDate();
      for (int i = 0; i < _selectedFiles.length; i++) {
        final StorageReference storageReferences = FirebaseStorage().ref().child("students/${_selectedPath[i].toString()}");

        final StorageUploadTask uploadTask = storageReferences.putFile(_selectedFiles[i]);

        final StreamSubscription<StorageTaskEvent> streamSubscription =
        uploadTask.events.listen((event) {
          print('EVENT ${event.type}');
          print(event.snapshot.bytesTransferred / 1000000);
          setState(() {
            _bytesSend = double.parse((event.snapshot.bytesTransferred / 1000000).toStringAsFixed(2));
            print(_bytesSend);

          });
        });

        // Cancel your subscription when done.
        await uploadTask.onComplete;
        streamSubscription.cancel();

        String imageUrl = await storageReferences.getDownloadURL();
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
        "name" : userName,
        "e-punjab" : punjab,
        'imageFiles': map,
        'topic': widget.topic
      };

      print(widget.uploadTask);
      print('${widget.classText}thQuestionBankSub');
      if(widget.uploadTask == '${widget.classText}thQuestionBankSub'){
        print("ok1");
        databaseMethods.questionSubmission(widget.classText, userMap);

      }
      if(widget.uploadTask == '${widget.classText}thSolutionSub'){
        print("ok2");

        databaseMethods.solutionSubmission(widget.classText, userMap);

      }



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
    return Scaffold(
      key: _scaffoldKey,
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
                              physics: NeverScrollableScrollPhysics(),
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
                                  child: Column(
                                    children: [
                                      _extention[index] == 'image' ? Column(
                                        children: [
                                          CachedNetworkImage(
                                              imageUrl: "${_links[index]}",
                                              fit:BoxFit.cover,
                                              height: 45,
                                              width: MediaQuery.of(context).size.width/1.3,
                                              placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                                              errorWidget: (context, url, error) => Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Icon(Icons.error, size: 20, color: Colors.red),
                                                  Padding(
                                                    padding: EdgeInsets.all(18.0),
                                                    child: Text(
                                                      'Please check your network and try again',
                                                      textAlign: TextAlign.center,
                                                      style: GoogleFonts.montserrat(
                                                          fontSize: 14
                                                      ),
                                                    ),
                                                  ),

                                                ],
                                              ),
                                          ),
                                          SizedBox(height: 7),
                                        ],
                                      ) : Container(),

                                      Row(
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
              widget.isSyllabus != true ? Container(
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
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: _selectedFiles.length,
                          itemBuilder: (BuildContext context, int index){
                            return Column(
                              children: [
                                GestureDetector(
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
                                    padding: EdgeInsets.only(top: 10),
                                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                    width: MediaQuery.of(context).size.width/1.3,
                                    decoration: BoxDecoration(
                                      color: Colors.teal[200],
                                      borderRadius: BorderRadius.circular(10),

                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        _selectedExtentions[index] == 'image' ? Image.file(_selectedFiles[index], fit:BoxFit.cover,
                                          height: 45,
                                          width: MediaQuery.of(context).size.width/1.5,) : Container(),
                                        Container(
                                          padding: EdgeInsets.only(left: 10),
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
                                                    setState(() {
                                                      _selectedFiles.removeAt(index);
                                                      _selectedExtentions.removeAt(index);
                                                      _selectedPath.removeAt(index);

                                                    });
                                                  },
                                                ),
                                              )

                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }
                      ),

                    ),
                    _selectedFiles.length != 0 ? Container(
                      padding: EdgeInsets.only(left: 10),
                      child: GestureDetector(
                        onTap: ()
                        {
                          uploadSubmission();
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
                                      _bytesSend = 0;
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

                                            Text('${_fileSend.toString()} / ${_selectedFiles.length}', style: GoogleFonts.montserrat(),),
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
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          width: MediaQuery.of(context).size.width/1.4,
                          height: 50,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [
                                    Colors.teal[100],
                                    Colors.teal[300],
                                    Colors.teal
                                  ]
                              ),
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: Center(
                            child: Text(
                              'Submit',
                              style: GoogleFonts.montserrat(
                                  textStyle: TextStyle(
                                      color: Colors.white,
                                      fontSize: 25
                                  )
                              ),
                            ),
                          ),
                        ),
                      ),
                    ) : Container(),
                  ],
                ),
              ) : Container(),
              widget.isSyllabus ? GestureDetector(
                onTap: () => _launchInBrowser(widget.link, context),
                child: Material(
                  elevation: 7,
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    width: MediaQuery.of(context).size.width/2.5,
                    height: 60,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        gradient: LinearGradient(
                        colors: [
                          Colors.teal[100],
                          Colors.teal[200],
                          Colors.teal[400],
                        ]
                      )
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Open Link',
                        style: GoogleFonts.montserrat(
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20
                          )
                        ),
                      ),
                    ),
                  ),
                ),
              ): Container()
            ],
          )
        ],
      )
    );
  }
}


Future<void> _launchInBrowser(String url, context) async {


  try {
    if (url.startsWith('http://') || url.startsWith('https://')) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    }
    else {
      url = 'https://$url';

      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    }
  }catch(e){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Can't Open Link", style: GoogleFonts.montserrat())));
  }
}
