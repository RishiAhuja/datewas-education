import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NetworkImageView extends StatefulWidget {
  final String url;
  final int index;
  NetworkImageView({@required this.index, @required this.url});
  @override
  _NetworkImageViewState createState() => _NetworkImageViewState();
}

class _NetworkImageViewState extends State<NetworkImageView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          'Image ${widget.index + 1}',
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
            icon: Icon(
              Icons.arrow_back_ios, color: Colors.black,
            ), onPressed: () => Navigator.pop(context)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CachedNetworkImage(
          imageUrl: "${widget.url}",
          placeholder: (context, url) => Center(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error, size: 100, color: Colors.red),
                Padding(
                  padding: EdgeInsets.all(18.0),
                  child: Text(
                    'Please check your network and try again',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                      fontSize: 16
                    ),
                  ),
                )
              ],
            ),
          )
        ),
      ),
    );
  }
}
