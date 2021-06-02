import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datewas_education/helper/pdf_view.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StudentsTextBook extends StatefulWidget {
  final int classInt;
  StudentsTextBook({this.classInt});
  @override
  _StudentsTextBookState createState() => _StudentsTextBookState();
}

class _StudentsTextBookState extends State<StudentsTextBook> {
  String punjabiUrl;
  String englishUrl;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }
  getData()
  async{
    Firestore.instance.collection('${widget.classInt}thTextBooks').document('1')
        .get().then((DocumentSnapshot) {
      print(DocumentSnapshot.data['english'].toString());

      setState(() {
        punjabiUrl = DocumentSnapshot.data['punjabi'].toString();
        englishUrl = DocumentSnapshot.data['english'].toString();

      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black
          ),
          onPressed: () =>  Navigator.pop(context),
        ),
      ),
      body: Container(
        child: Column(
          children: [

            Align(
              alignment: Alignment.center,
              child: Text(
                '${widget.classInt}th Text Books',
                style: GoogleFonts.montserrat(
                  textStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 27,
                      fontWeight: FontWeight.bold
                  ),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 25,),

            Align(
              alignment: Alignment.center,
              child: Material(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                elevation: 10,
                child: GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PDFView(url: punjabiUrl, text: 'Punjabi Text Book',))),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    width: MediaQuery.of(context).size.width/1.2,
                    height: 70,
                    child: Row(
                      children: [
                        Icon(
                            Icons.book,
                            color: Colors.black
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Punjabi Text Book',
                          style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22
                              )
                          ),
                        ),
                      ],
                    )
                  ),
                ),
              ),
            ),

            SizedBox(height: 25,),
            Align(
              alignment: Alignment.center,
              child: Material(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                elevation: 10,
                child: GestureDetector(
                  onTap: () {
                    // print(englishUrl);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => PDFView(url: englishUrl, text: 'English Text Book',),));
                  },
                  child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      width: MediaQuery.of(context).size.width/1.2,
                      height: 70,
                      child: Row(
                        children: [
                          Icon(
                              Icons.book,
                              color: Colors.black
                          ),
                          SizedBox(width: 10),
                          Text(
                            'English Text Book',
                            style: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22
                                )
                            ),
                          ),
                        ],
                      )
                  ),
                ),
              ),
            ),


          ],
        )
      ),
    );
  }
}
