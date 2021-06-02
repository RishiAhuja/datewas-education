import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datewas_education/helper/form.dart';
import 'package:datewas_education/views/submitShow.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';


class TopicAdd extends StatefulWidget {
  final String collection;
  final int classInt;
  TopicAdd({@required this.collection, @required this.classInt});
  @override
  _TopicAddState createState() => _TopicAddState();
}


bool _isSyllabus = false;

class _TopicAddState extends State<TopicAdd> {
  List headerList = [];
  List linkList = [];
  List dateList = [];
  List timeList = [];
  List pdfList = [];
  List imageFiles = [];
  String imageF;
  bool _isLoaded = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.collection == '${widget.classInt}thSyllabus'){
      _isSyllabus = true;
    }
    loadData();
  }

  Widget DataLoaderList()
  {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: MediaQuery.of(context).size.height/1.35,
        child: ListView.builder(
            itemCount: headerList.length,
            itemBuilder: (BuildContext context,int index){
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: DataLoader(
                  link: linkList[index],
                  header: headerList[index],
                  date: dateList[index],
                  time: timeList[index],
                  pdf: pdfList[index],
                  imageFiles: imageFiles[index],
                  collection: widget.collection,
                ),
              );
            }
        ),
      ),
    );
  }
  loadData()
  async{
    print(widget.collection);
    QuerySnapshot snap = await
    Firestore.instance.collection(widget.collection).getDocuments();

    snap.documents.forEach((document) {
      setState(() {
        headerList.add(document.data['header']);
        linkList.add(document.data['link']);
        dateList.add(document.data['date']);
        timeList.add(document.data['time']);
        pdfList.add(document.data['pdf']);
        imageFiles.add(jsonEncode(document.data['imageFiles']));
        print(headerList);
      });
    });
    setState(() {
      _isLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.tealAccent[200],
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          Column(
            children: [
              Material(
                borderRadius: BorderRadius.circular(15),
                elevation: 7,
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width/1.5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient: LinearGradient(
                      colors: [
                        Colors.lightBlueAccent,
                        Colors.blue
                      ]
                    ),
                  ),
                  child: GestureDetector(
                    onTap: ()
                    {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => UploadingForm(collection: widget.collection, classInt: widget.classInt,)));
                    },
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Create one',
                        style: GoogleFonts.montserrat(
                          textStyle: TextStyle(
                              fontSize: 25,
                              color: Colors.white
                          ),
                        )
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              _isLoaded ? DataLoaderList() : Center(child: CircularProgressIndicator()),
            ],
          )
        ],
      )
    );
  }
}

class DataLoader extends StatelessWidget {
  final String header;
  final String link;
  final String date;
  final String time;
  final String pdf;
  final String imageFiles;
  final String collection;
  DataLoader({this.header, this.pdf, this.imageFiles, this.date, this.time, this.link, this.collection});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 10,
      borderRadius: BorderRadius.circular(30),
      child: Container(
          //padding: EdgeInsets.all(10),

          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30)
          ),
          child: Container(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Icon(Icons.book_rounded),
                    ),
                    SizedBox(width: 20),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AutoSizeText(
                          toBeginningOfSentenceCase(header),
                          maxLines: 4,
                          style: GoogleFonts.montserrat(),
                        ),
                        Text(
                          '$date at $time',
                          style: GoogleFonts.montserrat(),
                        )
                      ],
                    ),
                  ],
                ),
                _isSyllabus == false ? Padding(
                  padding: const EdgeInsets.only(right: 18),
                  child: IconButton(
                    icon: Icon(Icons.remove_red_eye),
                    onPressed: ()
                    {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Submmision(topic: header, collection: '${collection}Sub',)));
                    },
                  ),
                ): Container()
              ],
            )
          )
      ),
    );
  }
}
