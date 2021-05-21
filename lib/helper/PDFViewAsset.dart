import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:google_fonts/google_fonts.dart';


class PDFViewAsset extends StatefulWidget {
  final File file;
  final int index;
  PDFViewAsset({this.file, this.index});
  @override
  _PDFViewAssetState createState() => _PDFViewAssetState();
}

class _PDFViewAssetState extends State<PDFViewAsset> {
  bool _isLoading = true;
  PDFDocument document;

  @override
  void initState() {
    super.initState();
    loadDocument();
  }

  loadDocument() async {
    document = await PDFDocument.fromFile(widget.file);
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          elevation: 0,
          leading: IconButton(icon: Icon(Icons.arrow_back_ios_outlined, color: Colors.white,), onPressed: () => Navigator.pop(context),),
          title: AutoSizeText(
            'PDF ${widget.index}',
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