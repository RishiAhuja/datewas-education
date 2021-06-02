import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datewas_education/helper/submitDetails.dart';
import 'package:datewas_education/services/database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class Submmision extends StatefulWidget {
  final String topic;
  final String collection;
  Submmision({this.topic, this.collection});

  @override
  _SubmmisionState createState() => _SubmmisionState();
}

class _SubmmisionState extends State<Submmision> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  List sub = [];
  List date = [];
  List time = [];
  List imageFiles = [];
  bool _isLoaded = false;
  List ePunjab = [];
  final Map<String, String> map = {

  };
  @override
  void initState() {
    // TODO: implement initState
    initiateSearch();
    super.initState();
  }
  initiateSearch()
  async{
    print('working');
    QuerySnapshot snap = await
    Firestore.instance.collection(widget.collection).where("topic", isEqualTo: widget.topic).getDocuments();

    snap.documents.forEach((document) {
      setState(() {
        sub.add(document.data['name']);
        date.add(document.data['date']);
        time.add(document.data['time']);
        ePunjab.add(document.data['e-punjab']);
        imageFiles.add(jsonEncode(document.data['imageFiles']));
        print(imageFiles);
      });
    });
    setState(() {
      _isLoaded = true;
    });
  }

  Widget SearchList()
  {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: sub.length,
      itemBuilder: (context, index)
      {
        return SearchTile(
          userName: sub[index],
          date: date[index],
          time: time[index],
          imageFiles: imageFiles[index],
          punjab: ePunjab[index]
        );
      },
    ) ;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back_ios, color: Colors.black), onPressed: () => Navigator.pop(context),),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: _isLoaded ? SearchList() : Center(child: CircularProgressIndicator(),),
    );
  }
}



class SearchTile extends StatelessWidget {

  final String userName;
  final String date;
  final String time;
  final String imageFiles;
  final String punjab;
  SearchTile({this.userName, this.time, this.date, this.imageFiles, this.punjab});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.only(top: 20),
      child: Material(
        elevation: 7,
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          width: MediaQuery.of(context).size.width/1.3,
          height: 75,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.supervised_user_circle_sharp),
                  SizedBox(width: 15,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          AutoSizeText(
                            toBeginningOfSentenceCase(userName),
                            minFontSize: 10,
                            maxLines: 3,
                            style: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold
                                )
                            ),
                          ),
                          SizedBox(width: 8),
                          punjab != null ?
                          AutoSizeText(
                            punjab,
                            minFontSize: 9,
                            style: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                                    color: Colors.grey[400],
                                    fontWeight: FontWeight.bold
                                )
                            ),
                          ) : Container()
                        ],
                      ),
                      SizedBox(height: 5,),
                      Text(
                        '$date at $time',
                        style: GoogleFonts.montserrat(
                          textStyle: TextStyle(
                            color: Colors.black45,

                          )
                        ),
                      )
                    ],
                  )
                ],
              ),
              IconButton(
                icon: Icon(Icons.remove_red_eye),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SubmitDetails(imageFiles: imageFiles)));
                },
              )
            ],
          ),
        ),
      )
    );
  }
}



