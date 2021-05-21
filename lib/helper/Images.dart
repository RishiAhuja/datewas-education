import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class NetworkImages extends StatefulWidget {
  final urls;
  NetworkImages({this.urls});

  @override
  _NetworkImagesState createState() => _NetworkImagesState();
}

class _NetworkImagesState extends State<NetworkImages> {
  List _links = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.urls);

    RegExp exp = new RegExp(
        r"((https?:www\.)|(https?:\/\/)|(www\.))[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9]{1,6}(\/[-a-zA-Z0-9()@:%_\+.~#?&\/=]*)?");
    Iterable<RegExpMatch> matches = exp.allMatches('${widget.urls}');

    matches.forEach((match) {
      //print('${widget.urls}'.substring(match.start, match.end));
      _links.add('${widget.urls}'.substring(match.start, match.end));
    });




  }
  @override
  Widget build(BuildContext context) {
    // return Container();
    return ListView.builder(
        itemCount: _links.length,
        itemBuilder: (BuildContext context, int index){
          return Container(
            child: CachedNetworkImage(
              imageUrl: "${_links[index]}",
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          );
        }
    );
  }
}
