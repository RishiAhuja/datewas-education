import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class PDFView extends StatefulWidget {
  final String url;
  final String text;
  PDFView({this.url, this.text});
  @override
  _PDFViewState createState() => _PDFViewState();
}

class _PDFViewState extends State<PDFView> {
  bool _isLoading = true;
  PDFDocument document;
  bool downloading=true;
  String downloadingStr="No data";
  double download=0.0;
  File f;

  @override
  void initState() {
    super.initState();
    loadDocument();
  }

  loadDocument() async {
    print(widget.url);
    document = await PDFDocument.fromURL(widget.url);
    setState(() => _isLoading = false);
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () => _launchInBrowser(widget.url),
              icon: Icon(Icons.download_rounded, color: Colors.white),
            )
          ],
          backgroundColor: Colors.blue,
          elevation: 0,
          leading: IconButton(icon: Icon(Icons.arrow_back_ios_outlined, color: Colors.white,), onPressed: () => Navigator.pop(context),),
          title: AutoSizeText(
            '${widget.text}',
            style: GoogleFonts.montserrat(
              textStyle:TextStyle(
                fontWeight: FontWeight.bold
              )
            ),
            ),
        ),
        body: Center(
          child: _isLoading
              ? Center(child: CircularProgressIndicator())
              : PDFViewer(
                  document: document,
                ),
        ),
      ),
    );
  }
}

Future<void> _launchInBrowser(String url) async {


  if(url.startsWith('http://') || url.startsWith('https://'))
  {
    await launch(
      url,
      forceSafariVC: false,
      forceWebView: false,
      headers: <String, String>{'my_header_key': 'my_header_value'},
    );


  }
  else{
    url = 'https://$url';


    await launch(
      url,
      forceSafariVC: false,
      forceWebView: false,
      headers: <String, String>{'my_header_key': 'my_header_value'},
    );
  }

}