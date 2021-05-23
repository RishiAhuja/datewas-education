import 'package:cached_network_image/cached_network_image.dart';
import 'package:datewas_education/helper/NetworkImage.dart';
import 'package:datewas_education/helper/pdf_view.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SubmitDetails extends StatefulWidget {
  final String imageFiles;
  SubmitDetails({this.imageFiles});
  @override
  _SubmitDetailsState createState() => _SubmitDetailsState();
}
List _links = [];
List _extention = [];
class _SubmitDetailsState extends State<SubmitDetails> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _links.clear();
    RegExp exp = new RegExp(
        r"((https?:www\.)|(https?:\/\/)|(www\.))[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9]{1,6}(\/[-a-zA-Z0-9()@:%_\+.~#?&\/=]*)?");
    Iterable<RegExpMatch> matches = exp.allMatches('${widget.imageFiles}');

    matches.forEach((match) {
      _links.add('${widget.imageFiles}'.substring(match.start, match.end));
      print(_links);     
      if('${widget.imageFiles}'.substring(match.start, match.end).contains('jpg') || '${widget.imageFiles}'.substring(match.start, match.end).contains('jpeg') || '${widget.imageFiles}'.substring(match.start, match.end).contains('png')){
        _extention.add("image");
      }

      if('${widget.imageFiles}'.substring(match.start, match.end).contains('pdf')){
        _extention.add("pdf");
      }
    });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(icon: Icon(Icons.arrow_back_ios, color: Colors.black,), onPressed: () => Navigator.pop(context),),
      ),

      body: ListView.builder(
        shrinkWrap: true,
          itemCount: _links.length,
          itemBuilder: (BuildContext context,int index){
            return Container(
              margin: EdgeInsets.all(25),
              child: Material(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                elevation: 7,
                child: GestureDetector(
                  onTap: ()
                  {
                    if(_extention[index] == 'pdf')
                    {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => PDFView(text: 'PDF ${index + 1}', url: _links[index],)));
                    }
                    if(_extention[index] == 'image')
                    {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => NetworkImageView(index: index, url: _links[index])));
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(18),
                    width: MediaQuery.of(context).size.width/1.3,
                    child: Column(
                      children: [
                        _extention[index] == 'image' ? Column(
                          children: [
                            CachedNetworkImage(
                              imageUrl: "${_links[index]}",
                              fit:BoxFit.cover,
                              height: 65,
                              width: MediaQuery.of(context).size.width/1.3,
                              placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                              errorWidget: (context, url, error) => Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.error, size: 20, color: Colors.red),
                                  Padding(
                                    padding: EdgeInsets.all(18.0),
                                    child: Text(
                                      'Please check your network and try again',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.montserrat(
                                          fontSize: 14
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 17),
                          ],
                        ) : Container(),

                        Row(
                          children: [

                            _extention[index] == 'pdf' ? Icon(Icons.picture_as_pdf, color: Colors.black) : Icon(Icons.image, color: Colors.black),
                            SizedBox(width: 7),
                            Text(
                              'File ${index + 1}',
                              style: GoogleFonts.montserrat(
                                  textStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold
                                  )
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
      ),
    );
  }
}
