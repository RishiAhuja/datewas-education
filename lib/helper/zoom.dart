import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datewas_education/helper/Images.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_linkify/flutter_linkify.dart';

class Zoom extends StatefulWidget {
  final int classInt;
  Zoom({@required this.classInt});

  @override
  _ZoomState createState() => _ZoomState();
}

class _ZoomState extends State<Zoom> {
  String _dateString;
  List headerList = [];
  List linkList = [];
  List dateList = [];
  List timeList = [];
  // Map<String, dynamic> imageFiles;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }

  loadData() async {
    QuerySnapshot snap = await Firestore.instance
        .collection('${widget.classInt}thZoomLink')
        .orderBy('date', descending: false)
        .getDocuments();

    snap.documents.forEach((document) {
      setState(() {
        headerList.add(document.data['header']);
        linkList.add(document.data['link']);
        dateList.add(document.data['date']);
        timeList.add(document.data['time']);
        print(linkList);
      });
    });
  }

  Widget DataList() {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(bottom: 20),
          alignment: Alignment.center,
          child: Text(
            'Zoom Link',
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
                textStyle: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 30)),
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height / 1.35,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: headerList.length,
              itemBuilder: (context, index) {
                return TileData(
                  link: linkList[index],
                  header: headerList[index],
                  date: dateList[index],
                  time: timeList[index],
                  index: index,
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_outlined),
          onPressed: () => Navigator.pop(context),
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: DataList(),
    );
  }
}

class TileData extends StatelessWidget {
  final String header;
  final String link;
  final String date;
  final String time;
  final int index;
  TileData({this.header, this.link, this.date, this.time, this.index});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Material(
            elevation: 10,
            borderRadius: BorderRadius.circular(7),
            child: Container(
              width: MediaQuery.of(context).size.width / 1.3,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.blue[900],
                  borderRadius: BorderRadius.circular(7)),
              child: Column(
                children: [
                  Text(
                    toBeginningOfSentenceCase('$header'),
                    style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20)),
                  ),
                  SizedBox(height: 10),
                  Linkify(
                    onOpen: (link) => _launchInBrowser(link.url),
                    text: "$link",
                    style: GoogleFonts.montserrat(textStyle: TextStyle(fontSize: 15, color: Colors.white)),
                    linkStyle: TextStyle(color: Colors.blue[200]),
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}

Future<void> _launchInBrowser(String url) async {
  if (url.startsWith('http://') || url.startsWith('https://')) {
    await launch(
      url,
      forceSafariVC: false,
      forceWebView: false,
      headers: <String, String>{'my_header_key': 'my_header_value'},
    );
  } else {
    url = 'https://$url';

    await launch(
      url,
      forceSafariVC: false,
      forceWebView: false,
      headers: <String, String>{'my_header_key': 'my_header_value'},
    );
  }
}
