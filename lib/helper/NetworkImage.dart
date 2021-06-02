import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:toast/toast.dart';

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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: ()
              async{
                try {
                  Toast.show("Downloading..", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
                  var imageId = await ImageDownloader.downloadImage("${widget.url}");
                  if (imageId == null) {
                    return;
                  }

                  // Below is a method of obtaining saved image information.
                  var fileName = await ImageDownloader.findName(imageId);
                  print(fileName);
                  var path = await ImageDownloader.findPath(imageId);
                  print(path);
                  var size = await ImageDownloader.findByteSize(imageId);
                  print(size);
                  var mimeType = await ImageDownloader.findMimeType(imageId);
                  print(mimeType);

                  Toast.show("Downloaded.", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);

                } on PlatformException catch (error) {
                  Toast.show("Download Failed..", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
                  print(error);
                }
              },
              icon: Icon(Icons.download_rounded, color: Colors.grey[600],),
            ),
          )
        ],
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InteractiveViewer(
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
          ),
        ],
      ),
    );
  }
}
