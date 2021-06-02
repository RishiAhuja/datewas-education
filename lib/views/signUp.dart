import 'package:datewas_education/services/database.dart';
import 'package:datewas_education/views/classRoom.dart';
import 'package:datewas_education/views/teachLogin.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool _isLoading = false;

  final formKey = GlobalKey<FormState>();
  TextEditingController nameController = new TextEditingController();
  TextEditingController numberController = new TextEditingController();
  TextEditingController punjabController = new TextEditingController();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  String _chosenValue;

  signUserUp()
  {
    if(formKey.currentState.validate()){
      Map<String, String> userMap = {
        "name": nameController.text,
        "phone": numberController.text,
        "class": _chosenValue,
        'e-punjab' : punjabController.text
      };

      setState(() {
        _isLoading = true;
      });
        databaseMethods.uploadUserInfo(userMap);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ClassRoom()));
      //});
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.tealAccent[200],
          elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.admin_panel_settings),
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
            },
          )
        ],
      ),
      body: _isLoading ? Center(child: CircularProgressIndicator(backgroundColor: Colors.tealAccent[200],)) : SafeArea(
        child: Container(
          child: ListView(
            shrinkWrap: true,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.fromLTRB(16, 0, 16, 15),
                    child: Text(
                        "Datewas Online Education",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 26,
                          color: Colors.white
                        )
                      ),
                    ),
                  ),

                  Material(
                    elevation: 20,
                    borderRadius: BorderRadius.circular(15),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      width: MediaQuery.of(context).size.width/1.2,
                      height: MediaQuery.of(context).size.height/1.5,
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.only(top: 20),
                            child: Text(
                              'Welcome!',
                              style: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                                  color: Colors.blue[900],
                                  fontSize: 25
                                )
                              ),
                            ),
                          ),
                          SizedBox(height: 15),


                          Form(
                            key: formKey,
                            child: Column(
                              children: [
                                // ----------Name Input Start----------- //
                                Container(
                                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey[400]),
                                        borderRadius: BorderRadius.circular(10)
                                    ),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(left: 10),
                                          child: Icon(
                                            Icons.people,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context).size.width/2,
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 20),
                                            child: TextFormField(validator: (val)
                                            {
                                              return val.isEmpty || val.length < 4 ? 'Atleast 4+ characters required' : null;
                                            },

                                              controller: nameController,
                                              decoration: InputDecoration(
                                                  hintStyle: GoogleFonts.montserrat(textStyle: TextStyle(color: Colors.grey)),
                                                  hintText: 'Name',
                                                  border: InputBorder.none
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                ),
                                // ----------Name Input End----------- //

                                // ----------Phone Number Input Start----------- //

                                Container(
                                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey[400]),
                                        borderRadius: BorderRadius.circular(10)
                                    ),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(left: 10),
                                          child: Icon(
                                            Icons.phone,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context).size.width/2,
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 20),
                                            child: TextFormField(
                                              validator: (val)
                                              {
                                                return val.isEmpty || val.length > 10 || val.length < 10 ? 'Please provide valid number' : null;
                                              },

                                              keyboardType: TextInputType.phone,
                                              controller: numberController,
                                              decoration: InputDecoration(

                                                  hintStyle: GoogleFonts.montserrat(textStyle: TextStyle(color: Colors.grey)),
                                                  hintText: 'Phone Number',
                                                  border: InputBorder.none
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                ),
                                // ----------Phone Number Input End----------- //


                                //-------------Dropdown-start------------//
                                Container(
                                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey[400]),
                                        borderRadius: BorderRadius.circular(10)
                                    ),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(left: 10),
                                          child: Icon(
                                            Icons.class__outlined,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context).size.width/2,
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 20),
                                            child: DropdownButtonHideUnderline(
                                              child: DropdownButton<String>(
                                                focusColor: Colors.white,
                                                value: _chosenValue,
                                                elevation: 15,

                                                style: TextStyle(color: Colors.white),
                                                iconEnabledColor:Colors.grey,
                                                items: <String>[
                                                  '6th',
                                                  '7th',
                                                  '8th',
                                                  '9th',
                                                  '10th',
                                                  '11th',
                                                  '12th',
                                                ].map<DropdownMenuItem<String>>((String value) {
                                                  return DropdownMenuItem<String>(
                                                    value: value,
                                                    child: Text(
                                                      value,
                                                      style: GoogleFonts.montserrat(
                                                        textStyle: TextStyle(color: Colors.black ),
                                                      )),
                                                  );
                                                }).toList(),
                                                hint: Text(
                                                  "Class",
                                                  style: GoogleFonts.montserrat(textStyle: TextStyle(
                                                      color: Colors.grey,),
                                                ),),
                                                onChanged: (String value) {
                                                  setState(() {
                                                    _chosenValue = value;
                                                    print(_chosenValue);
                                                  });
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                ),

                                //-------------Dropdown-End--------------//


                                // ----------E-Punjab Input Start----------- //

                                Container(
                                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey[400]),
                                        borderRadius: BorderRadius.circular(10)
                                    ),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(left: 10),
                                          child: Icon(
                                            Icons.confirmation_number_outlined,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context).size.width/2,
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 20),
                                            child: TextFormField(
                                              validator: (val)
                                              {
                                                return val.isEmpty || val.length > 10 || val.length < 3 ? 'Please provide valid E-Punjab number'
                                                    '' : null;
                                              },

                                              keyboardType: TextInputType.phone,
                                              controller: punjabController,
                                              decoration: InputDecoration(

                                                  hintStyle: GoogleFonts.montserrat(textStyle: TextStyle(color: Colors.grey)),
                                                  hintText: 'E-Punjab Number',
                                                  border: InputBorder.none
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                ),
                                // ----------E-Punjab Input End----------- //

                              ],
                            ),
                          ),

                          SizedBox(height: 30),

                          // ----------Login Button Start-------------//
                          GestureDetector(
                            onTap: (){
                              addPunjabToSF();
                              addUserNameToSF();
                              signUserUp();
                              addBoolToSF();
                            },

                            child: Container(
                              width: MediaQuery.of(context).size.width/1.45,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Colors.grey
                              ),
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  'Login',
                                  style: GoogleFonts.montserrat(
                                    textStyle: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold
                                    )
                                  ),
                                ),
                              ),
                            ),
                          )
                          // ----------Login Button End-------------//

                        ],
                      ),
                    ),
                  ),
                  SizedBox()
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  addBoolToSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isSigned', true);
  }

  addUserNameToSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('user', nameController.text);
  }

  addPunjabToSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('e-punjab', punjabController.text);
  }

}
