import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UploadingForm extends StatefulWidget {
  const UploadingForm({Key key}) : super(key: key);

  @override
  _UploadingFormState createState() => _UploadingFormState();
}

class _UploadingFormState extends State<UploadingForm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(icon: Icon(Icons.arrow_back_ios), color: Colors.black, onPressed: () => Navigator.pop(context),),
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              child: Material(
                elevation: 7,
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  width: MediaQuery.of(context).size.width/1.3,
                  height: 65,
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Header..',
                      hintStyle: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                          color: Colors.grey[400]
                        )
                      )
                    ),
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
                  width: MediaQuery.of(context).size.width/1.3,
                  height: 65,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Attachment..',
                        style: GoogleFonts.montserrat(
                            textStyle: TextStyle(
                                color: Colors.grey[400]
                            )
                        )
                    ),
                  )
                ),
              ),
            ),



          ],
        ),
      ),
    );
  }
}
