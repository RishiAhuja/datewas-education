import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
int _index;
class ImageView extends StatefulWidget {
  final File image;
  final int index;
  ImageView({this.image, this.index});
  @override
  _ImageViewState createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.index);
    _index = widget.index;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Image $_index',
          style: GoogleFonts.montserrat(
            textStyle: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold
            )
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.tealAccent[200],
        leading: IconButton(
          onPressed: () =>  Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
      ),
      body: InteractiveViewer(
        child: Image.file(widget.image),
      ),
    );
  }
}
