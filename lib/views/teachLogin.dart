import 'package:datewas_education/views/homeworkUploading.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toast/toast.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

String password = 'sachin@3377';

TextEditingController controller = TextEditingController();

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.tealAccent[200],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.tealAccent[200],
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 25),
                child: Container(
                  alignment: Alignment.topLeft,
                  child: Text(
                      'Login',
                    style: GoogleFonts.montserrat(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                    )
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(28.0),
                child: SizedBox(
                  width: 200,
                  height: 200,
                  child: Icon(
                      Icons.login,
                    color: Colors.white,
                    size: 100,
                  )
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: TextField(
                  controller: controller,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(
                        color: Colors.white,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide(
                        color: Colors.white,
                        width: 1.0,
                      ),
                    ),
                    hintText: 'Enter the password',
                    hintStyle: GoogleFonts.montserrat(textStyle: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    contentPadding: EdgeInsets.all(16),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () async{
                  if(controller.text.trim() == password){
                    Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UploadHomework()),
                  );
                  }
                  else{
                    Toast.show("Invalid Password", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
                  }
                },
                child: Material(
                  borderRadius: BorderRadius.circular(30),
                  elevation: 7,
                  child: Container(
                  height: 55,
                  width: MediaQuery.of(context).size.width/1.3,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.grey[400]
                  ),
                  child: Align(
                    alignment: Alignment.center,
                      child: Text(
                          'Login',
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
                )
              )
            ],
          ),
        ],
      ),
    );
  }
}
