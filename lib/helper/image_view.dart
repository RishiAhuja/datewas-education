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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Image ${_index + 1}',
          style: GoogleFonts.montserrat(
            textStyle: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold
            )
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () =>  Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
        ),
      ),
      body: InteractiveViewer(
        child: Image.file(widget.image),
      ),
    );
  }
}
