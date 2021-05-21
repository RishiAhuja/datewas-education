import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datewas_education/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';


class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController searchController = TextEditingController();
  List usernameList = [];
  List phoneList = [];
  List classList = [];


  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    initiateSearch();
  }


  initiateSearch()
  async{
    QuerySnapshot snap = await
    Firestore.instance.collection('users').getDocuments();

    snap.documents.forEach((document) {
      setState(() {
        usernameList.add(document.data['name']);
        phoneList.add(document.data['phone']);
        classList.add(document.data['class']);
        print(document.data['class']);
      });
      // print(phoneList);
    });
  }

  Widget SearchList()
  {


    return ListView.builder(
      shrinkWrap: true,
      itemCount: usernameList.length,
      itemBuilder: (context, index)
      {
        return Tile(
          userEmail: phoneList[index],
          userName: usernameList[index],
          userClass: classList[index]
        );
      },
     );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.tealAccent[200],
      ),
      body: SearchList(),
    );

  }
}



class Tile extends StatelessWidget {

  final String userName;
  final String userEmail;
  final String userClass;

  Tile({this.userEmail, this.userName, this.userClass});

  @override
  Widget build(BuildContext context) {
    return Column(

      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Material(
            elevation: 10,
            borderRadius: BorderRadius.circular(30),
            child: Container(
              padding: EdgeInsets.all(10),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30)
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Icon(Icons.person),
                        ),
                        SizedBox(width: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              toBeginningOfSentenceCase(userName),
                              style: GoogleFonts.montserrat(textStyle: TextStyle(fontSize: 20)),
                            ),
                            Text(
                              userEmail,
                              style: GoogleFonts.montserrat(),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(right: 30),
                    child: Text(
                      userClass,
                      style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                          fontSize: 18
                        )
                      ),
                    ),
                  )
                ]

              )
            ),
          ),
        )
      ],
    );
  }
}
