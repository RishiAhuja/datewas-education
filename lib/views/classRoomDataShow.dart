import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datewas_education/helper/Images.dart';
import 'package:datewas_education/helper/pdf_view.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class ClassRoomDataShow extends StatefulWidget {
  final String collection;
  final String dataName;
  final bool PDForLink;
  ClassRoomDataShow({this.collection, this.dataName, this.PDForLink});
  @override
  _ClassRoomDataShowState createState() => _ClassRoomDataShowState();
}

class _ClassRoomDataShowState extends State<ClassRoomDataShow> {
  List headerList = [];
  List linkList = [];
  List dateList = [];
  List timeList = [];
  List pdfList = [];
  List imageFiles = [];
  // Map<String, dynamic> imageFiles;
  String imageF;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
    print(widget.collection);
  }

  loadData()
  async{
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
        //print(document.data['imageFiles']);
        print(imageF);
      });
    });
  }


  Widget DataList()
  {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 20),
          alignment: Alignment.center,
          child: Text(
            '${widget.dataName}',
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
                textStyle: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 30
                )
            ),
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height/1.35,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: headerList.length,
              itemBuilder: (context, index)
              {
                return TileData(
                  link: linkList[index],
                  header: headerList[index],
                  date: dateList[index],
                  time: timeList[index],
                  pdf: pdfList[index],
                  imageFiles: imageFiles[index],
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
        backgroundColor: Colors.tealAccent[200],
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
  final String pdf;
  final String imageFiles;

  TileData({this.header, this.link, this.date, this.time, this.pdf, this.imageFiles});

  @override
  Widget build(BuildContext context) {
    return Column(

      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => NetworkImages(urls: imageFiles, topic: header, date: date, time: time,))),
            child: Material(
              elevation: 10,
              borderRadius: BorderRadius.circular(30),
              child: Container(
                  padding: EdgeInsets.all(10),

                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30)
                  ),
                  child: Container(
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Icon(Icons.book_rounded),
                        ),
                        SizedBox(width: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AutoSizeText(                             
                              toBeginningOfSentenceCase(header),
                              maxLines: 4,                             
                              style: GoogleFonts.montserrat(),
                            ),
                            Text(
                              '$date at $time',
                              maxLines: 5,
                              style: GoogleFonts.montserrat(),
                            )
                          ],
                        ),
                      ],
                    ),
                  )
              ),
            ),
          ),
        )
      ],
    );
  }
}


Future<void> _launchInBrowser(String url, String text, context) async {


  // if(url.startsWith('http://') || url.startsWith('https://'))
  //   {
  //     if(url.contains('pdf'))
  //     {
  //       Navigator.push(context, MaterialPageRoute(builder: (context) => PDFView(url: url, text: text)));
  //     }
  //     else {
  //       await launch(
  //         url,
  //         forceSafariVC: false,
  //         forceWebView: false,
  //         headers: <String, String>{'my_header_key': 'my_header_value'},
  //       );
  //     }
  //
  //
  //   }
  // else{
  //   url = 'https://$url';
  //
  //
  //     await launch(
  //       url,
  //       forceSafariVC: false,
  //       forceWebView: false,
  //       headers: <String, String>{'my_header_key': 'my_header_value'},
  //     );
  //   }

}


