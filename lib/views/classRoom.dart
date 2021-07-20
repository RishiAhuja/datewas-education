import 'package:datewas_education/views/classRoomDataSelection.dart';
import 'package:datewas_education/views/classRoomDataShow.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ClassRoom extends StatefulWidget {
  @override
  _ClassRoomState createState() => _ClassRoomState();
}

class _ClassRoomState extends State<ClassRoom> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        leading: Opacity(opacity: 0, child: Container(),),
        centerTitle: true,
        title: Text(
          'Choose your class',
          style: GoogleFonts.montserrat(
            textStyle: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 25
            )
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          Column(
            children: [
              SizedBox(height: 30),
              classRoomButton('6th', context),
              classRoomButton('7th', context),
              classRoomButton('8th', context),
              classRoomButton('9th', context),
              classRoomButton('10th', context),
              classRoomButton('11th', context),
              classRoomButton('12th', context),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              topButton("Today's Thought", context),
              topButton('Important Links', context),

            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              topButton("Date Sheet", context),
              topButton("Daily Dakk", context),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              topButton("Performas", context),
              topButton("Apps", context),
            ],
          )
        ],
      ),
    );
  }
}



onClassRoomButtonPressed(String text, context)
{
  if(text == "Today's Thought")
  {
    Navigator.push(context, MaterialPageRoute(builder: (context) => ClassRoomDataShow(dataName: "Today's Thought", collection: 'TodayT', PDForLink: true, isSyllabus: true,)));
  }
  if(text == 'Important Links')
  {
    Navigator.push(context, MaterialPageRoute(builder: (context) => ClassRoomDataShow(dataName: 'Important Links', collection: 'IL', PDForLink: false, isSyllabus: false,)));
  }

  if(text == "6th"){
    Navigator.push(context, MaterialPageRoute(builder: (context) => ClassRoomDataSelection(classText: 6)));
  }

  if(text == "7th"){
    Navigator.push(context, MaterialPageRoute(builder: (context) => ClassRoomDataSelection(classText: 7)));
  }

  if(text == "8th"){
    Navigator.push(context, MaterialPageRoute(builder: (context) => ClassRoomDataSelection(classText: 8)));
  }

  if(text == "9th"){
    Navigator.push(context, MaterialPageRoute(builder: (context) => ClassRoomDataSelection(classText: 9)));
  }

  if(text == "10th"){
    Navigator.push(context, MaterialPageRoute(builder: (context) => ClassRoomDataSelection(classText: 10)));
  }

  if(text == "11th"){
    Navigator.push(context, MaterialPageRoute(builder: (context) => ClassRoomDataSelection(classText: 11)));
  }

  if(text == "12th"){
    Navigator.push(context, MaterialPageRoute(builder: (context) => ClassRoomDataSelection(classText: 12)));
  }

}
Widget classRoomButton(String classText, context)
{
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: GestureDetector(
      onTap: () => onClassRoomButtonPressed(classText, context),
      child: Material(
        borderRadius: BorderRadius.circular(6),
        elevation: 7,
        child: Container(
          height: 55,
          width: MediaQuery.of(context).size.width/1.3,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: Colors.blue[900]
          ),
          child: Align(
              alignment: Alignment.center,
              child: Text(
                  '$classText',
                  textAlign: TextAlign.center,
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

Widget topButton(String classText, context)
{
  return Padding(
    padding: const EdgeInsets.all(12.0),
    child: GestureDetector(
      onTap: () => onClassRoomButtonPressed(classText, context),
      child: Material(
        borderRadius: BorderRadius.circular(15),
        elevation: 7,
        child: Container(
          padding: EdgeInsets.all(8),
          height: 70,
          width: MediaQuery.of(context).size.width/2.5,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.blue[900]
          ),
          child: Align(
              alignment: Alignment.center,
              child: Text(
                  '$classText',
                  textAlign: TextAlign.center,
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

