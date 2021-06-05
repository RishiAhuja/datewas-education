import 'package:datewas_education/views/signUp.dart';
import 'package:datewas_education/views/teacher.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UserSelection extends StatefulWidget {
  @override
  _UserSelectionState createState() => _UserSelectionState();
}

class _UserSelectionState extends State<UserSelection> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              child: Text(
                'Datewas Online Education',
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                  textStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 29
                  )
                ),
              ),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SignUp())),
              child: Align(
                alignment: Alignment.center,
                child: Material(
                  borderRadius: BorderRadius.circular(10),
                  elevation: 8,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blue[900],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    width: MediaQuery.of(context).size.width/1.4,
                    height: MediaQuery.of(context).size.height/3.2,
                    child: Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.all(20),
                      child: Column(
                        children: [
                          SizedBox(width: 150, height: 150, child: Image.asset('assets/student.png')),
                          SizedBox(height: 10),
                          Text(
                            'Student',
                            style: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25
                                )
                            ),
                          ),
                        ],
                      ),
                    )
                  ),
                ),
              ),
            ),

            SizedBox(height: 20),
            GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => TeachSignUp())),
              child: Align(
                alignment: Alignment.center,
                child: Material(
                  borderRadius: BorderRadius.circular(10),
                  elevation: 8,
                  child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blue[900],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      width: MediaQuery.of(context).size.width/1.4,
                      height: MediaQuery.of(context).size.height/3.2,
                      child: Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.all(20),
                        child: Column(
                          children: [
                            SizedBox(width: 150, height: 150, child: Image.asset('assets/teacher.png')),
                            SizedBox(height: 10),
                            Text(
                              'Teacher',
                              style: GoogleFonts.montserrat(
                                  textStyle: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25
                                  )
                              ),
                            ),
                          ],
                        ),
                      )
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
