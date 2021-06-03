import 'package:datewas_education/views/showUser.dart';
import 'package:datewas_education/views/workSelection.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UploadHomework extends StatefulWidget {
  @override
  _UploadHomeworkState createState() => _UploadHomeworkState();
}

class _UploadHomeworkState extends State<UploadHomework> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(icon: Icon(Icons.arrow_back_ios_outlined), onPressed: () => Navigator.pop(context), color: Colors.black,),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
      body: ListView(
        shrinkWrap: true,
        children: [
          Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  'Select a class!',
                  style: GoogleFonts.montserrat(
                    textStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 30
                    )
                  ),
                ),
              ),
              classButton("6th", context),
              classButton("7th", context),
              classButton("8th", context),
              classButton("9th", context),
              classButton("10th", context),
              classButton("11th", context),
              classButton("12th", context),
              SizedBox(height: 15),
              GestureDetector(
                onTap: ()
                {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Search()));
                },
                child: Material(
                  borderRadius: BorderRadius.circular(10),
                  elevation: 7,
                  child: Container(
                    height: 55,
                    width: MediaQuery.of(context).size.width/1.3,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(
                          colors: [
                            Colors.blue[300],
                            Colors.blue
                          ]
                        )
                    ),
                    child: Align(
                        alignment: Alignment.center,
                        child: Text(
                            'Users',
                            style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold
                              ),
                            )
                        )
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

onButtonPressed(String text, context)
{
  if(text == "6th")
    {
      Navigator.push(context, MaterialPageRoute(builder: (context) => WorkSelection(classInt: 6, )));
    }

  if(text == "7th")
  {
    Navigator.push(context, MaterialPageRoute(builder: (context) => WorkSelection(classInt: 7,)));
  }

  if(text == "8th")
  {
    Navigator.push(context, MaterialPageRoute(builder: (context) => WorkSelection(classInt: 8,)));
  }


  if(text == "9th")
  {
    Navigator.push(context, MaterialPageRoute(builder: (context) => WorkSelection(classInt: 9,)));
  }


  if(text == "10th")
  {
    Navigator.push(context, MaterialPageRoute(builder: (context) => WorkSelection(classInt: 10,)));
  }


  if(text == "11th")
  {
    Navigator.push(context, MaterialPageRoute(builder: (context) => WorkSelection(classInt: 11,)));
  }


  if(text == "12th")
  {
    Navigator.push(context, MaterialPageRoute(builder: (context) => WorkSelection(classInt: 12,)));
  }




}
Widget classButton(String classText, context)
{
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: GestureDetector(
      onTap: () => onButtonPressed(classText, context),
      child: Material(
        borderRadius: BorderRadius.circular(7),
        elevation: 7,
        child: Container(
          height: 55,
          width: MediaQuery.of(context).size.width/1.3,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7),
              color: Colors.blue[900]
          ),
          child: Align(
              alignment: Alignment.center,
              child: Text(
                  '$classText',
                  style: GoogleFonts.montserrat(
                    textStyle: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold
                    ),
                  )
              )
          ),
        ),
      ),
    ),
  );
}