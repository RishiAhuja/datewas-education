import 'package:datewas_education/helper/form.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class YearMonthly extends StatefulWidget {
  final int classInt;
  YearMonthly({@required this.classInt});
  @override
  _YearMonthlyState createState() => _YearMonthlyState();
}

class _YearMonthlyState extends State<YearMonthly> {
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => UploadingForm(collection: '${widget.classInt}S1', classInt: widget.classInt))),
              child: Align(
                alignment: Alignment.center,
                child: Material(
                  borderRadius: BorderRadius.circular(20),
                  elevation: 7,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        colors: [
                          Colors.red[200],
                          Colors.red[400],
                          Colors.red,
                          Colors.red[700]
                        ]
                      )
                    ),
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width/1.2,
                    height: MediaQuery.of(context).size.height/2.6,
                    child: Text(
                      'Yearly',
                      style: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontSize: 45,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 25,),
            GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => UploadingForm(collection: '${widget.classInt}S2', classInt: widget.classInt))),
              child: Align(
                alignment: Alignment.center,
                child: Material(
                  borderRadius: BorderRadius.circular(20),
                  elevation: 7,
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                            colors: [
                              Colors.blue[200],
                              Colors.blue[400],
                              Colors.blue,
                              Colors.blue[700]
                            ]
                        )
                    ),
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width/1.2,
                    height: MediaQuery.of(context).size.height/2.6,
                    child: Text(
                      'Monthly',
                      style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontSize: 45,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
