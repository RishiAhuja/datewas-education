import 'package:datewas_education/helper/TimeTableShow.dart';
import 'package:datewas_education/helper/yearMonthStudent.dart';
import 'package:datewas_education/helper/zoom.dart';
import 'package:datewas_education/views/classRoomDataShow.dart';
import 'package:datewas_education/views/showTextBook.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ClassRoomDataSelection extends StatefulWidget {
  final int classText;
  ClassRoomDataSelection({this.classText});
  @override
  _ClassRoomDataSelectionState createState() => _ClassRoomDataSelectionState();
}

class _ClassRoomDataSelectionState extends State<ClassRoomDataSelection> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back_ios_outlined), onPressed: () => Navigator.pop(context), color: Colors.black,),
        backgroundColor: Colors.white,
        elevation: 0,
        // centerTitle: true,
        // title: Text(
        //   'Computer Science',
        //   style: GoogleFonts.montserrat(
        //     fontSize: 25,
        //     color: Colors.black,
        //     fontWeight: FontWeight.bold
        //   ),
        // ),
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          Column(
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  alignment: Alignment.center,
                  child: Text(
                    '${widget.classText}th class',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                      textStyle: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 35
                      )
                    ),
                  ),
                ),

                classRoomSelectionButton('Text Book', '${widget.classText}thTextBooks', 'null', widget.classText, false, context),
                classRoomSelectionButton('Syllabus', 'null', 'null', widget.classText, true, context),
                classRoomSelectionButton('Text Material', '${widget.classText}TM', '${widget.classText}TMS', widget.classText, false, context, ),
                classRoomSelectionButton('Video Material', '${widget.classText}thVideoMaterial', 'null', widget.classText, false, context, ),
                classRoomSelectionButton('Daily Assignment', '${widget.classText}thQuestionBank', '${widget.classText}thQuestionBankSub' ,widget.classText, false, context, ),
                classRoomSelectionButton('Assignment Solutions', '${widget.classText}thSolution','${widget.classText}thSolutionSub',  widget.classText, true, context, ),
                classRoomSelectionButton('Zoom Link', '${widget.classText}thZoomLink', 'null' , widget.classText, false, context, ),
                classRoomSelectionButton('Question Bank', '${widget.classText}PYQ','null',  widget.classText, true, context, ),
                classRoomSelectionButton('Time Table', 'null', 'null' , widget.classText, false, context, ),
              ],
          ),
        ],
      ),
    );
  }
}


onClassRoomSelectionButtonPressed(String text, String collection, String submmison, int classText, bool _syllabus, context)
{
  if(text == 'Video Material')
    {
      Navigator.push(context, MaterialPageRoute(builder: (context) => ClassRoomDataShow(dataName: 'Video Material', collection: '$collection', PDForLink: false, isSyllabus: _syllabus,)));
    }
  if(text == 'Text Book')
    {
      Navigator.push(context, MaterialPageRoute(builder: (context) => StudentsTextBook(classInt: classText, )));
    }

  if(text == 'Daily Assignment')
  {
    Navigator.push(context, MaterialPageRoute(builder: (context) => ClassRoomDataShow(dataName: 'Daily Assignment', collection: '$collection', PDForLink: true, submmison: submmison, ClassText: classText, isSyllabus: _syllabus,)));
  }

  if(text == 'Text Material')
  {
    Navigator.push(context, MaterialPageRoute(builder: (context) => ClassRoomDataShow(dataName: 'Text Material', collection: '$collection', PDForLink: true, submmison: submmison, ClassText: classText, isSyllabus: _syllabus,)));
  }

  if(text == 'Assignment Solutions')
  {
    Navigator.push(context, MaterialPageRoute(builder: (context) => ClassRoomDataShow(dataName: 'Assignment Solutions', collection: '$collection', PDForLink: true, submmison: submmison, ClassText: classText, isSyllabus: _syllabus,)));
  }

  if(text == 'Question Bank')
  {
    Navigator.push(context, MaterialPageRoute(builder: (context) => ClassRoomDataShow(dataName: 'Question Bank', collection: '$collection', PDForLink: true, submmison: submmison, ClassText: classText, isSyllabus: _syllabus,)));
  }


  if(text == 'Zoom Link')
  {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Zoom(classInt: classText)));
  }

  if(text == 'Time Table')
    {
      Navigator.push(context, MaterialPageRoute(builder: (context) => TimeTableShow(classInt: classText,)));
    }

  if(text == 'Syllabus')
    {
      Navigator.push(context, MaterialPageRoute(builder: (context) => YearMonthStudent(classInt: classText,)));
    }
}


Widget classRoomSelectionButton(String classText, String collection, recieveTask, classInt, isSyllabus, context, )
{
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: GestureDetector(
      onTap: () => onClassRoomSelectionButtonPressed(classText, collection, recieveTask, classInt, isSyllabus, context, ),
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

