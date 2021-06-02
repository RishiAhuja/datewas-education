import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ShowTextBook extends StatefulWidget {
  final classInt;
  ShowTextBook({@required this.classInt});
  @override
  _ShowTextBookState createState() => _ShowTextBookState();
}

class _ShowTextBookState extends State<ShowTextBook> {
  String punjabi;
  String english;

  TextEditingController punjabiController = TextEditingController();
  TextEditingController englishController = TextEditingController();


  GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
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
      print(DocumentSnapshot.data['punjabi'].toString());

      setState(() {
        punjabi = DocumentSnapshot.data['punjabi'].toString();
        english = DocumentSnapshot.data['english'].toString();
      });
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
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
            Align(
              alignment: Alignment.center,
              child: Text(
                '${widget.classInt}th',
                style: GoogleFonts.montserrat(
                  textStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
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
                child: Container(
                  width: MediaQuery.of(context).size.width/1.2,
                  child: ExpansionTile(
                    title: Row(
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
                                  fontSize: 17
                              )
                          ),
                        ),
                      ],
                    ),
                    children: <Widget>[

                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        margin: EdgeInsets.all(25),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.grey[300],
                        ),
                        child: TextFormField(
                          controller: punjabiController,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Update Link..',
                              hintStyle: GoogleFonts.montserrat(
                                  textStyle: TextStyle()
                              )
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => updateData(),
                        child: Container(
                          width: MediaQuery.of(context).size.width/2,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            gradient: LinearGradient(
                                colors: [
                                  Colors.blue[200],
                                  Colors.blue[400],
                                  Colors.blue,
                                  Colors.blue[700]
                                ]
                            ),
                          ),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              'Update',
                              style: GoogleFonts.montserrat(
                                  textStyle: TextStyle(
                                      color: Colors.white,
                                      fontSize: 23,
                                      fontWeight: FontWeight
                                          .bold
                                  )
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20,)
                    ],
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
                child: Container(
                  width: MediaQuery.of(context).size.width/1.2,
                  child: ExpansionTile(
                    title: Row(
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
                                  fontSize: 17
                              )
                          ),
                        ),
                      ],
                    ),
                    children: <Widget>[

                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          margin: EdgeInsets.all(25),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.grey[300],
                          ),
                          child: TextFormField(
                            controller: englishController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Update Link..',
                              hintStyle: GoogleFonts.montserrat(
                                textStyle: TextStyle()
                              )
                            ),
                          ),
                        ),
                      GestureDetector(
                        onTap: () => updateData(),
                        child: Container(
                          width: MediaQuery.of(context).size.width/2,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            gradient: LinearGradient(
                              colors: [
                                Colors.blue[200],
                                Colors.blue[400],
                                Colors.blue,
                                Colors.blue[700]
                              ]
                            ),
                          ),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              'Update',
                              style: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 23,
                                  fontWeight: FontWeight
                                    .bold
                                )
                              ),
                            ),
                          ),
                        ),
                      ),
                       SizedBox(height: 20,)
                    ],
                  ),





                ),
              ),
            )




          ],
        ),
      ),
    );
  }
  updateData()
  {

    try {
      Firestore.instance
          .collection('${widget.classInt}thTextBooks')
          .document('1')
          .updateData({
            'punjabi' : '${punjabiController.text}',
            'english' : '${englishController.text}'
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Updated Successfully!', style: GoogleFonts.montserrat(),)));
      print("updated");

    }catch(e)
    {
      print(e);
    }


  }
}


