import 'package:flutter/material.dart';
import 'dart:io';
import 'package:transparent_image/transparent_image.dart';
import 'package:mobile_app/widgets/widgets.dart';

class ImageContentWidget extends StatefulWidget {
  final String url;
  final bool fromNetwork;
  final double scale;

  ImageContentWidget({
    this.url,
    this.fromNetwork = true,
    this.scale = 1.0,
  });

  @override
  _ImageContentWidgetState createState() => _ImageContentWidgetState();
}

class _ImageContentWidgetState extends State<ImageContentWidget> {
  @override
  Widget build(BuildContext context) {
    print(widget.url);
    if (widget.url == 'null_thumbnail' || widget.url == 'null') {
      return Container();
    }

    return widget.fromNetwork
        ? _fromNetworkWidget(context)
        : Image.file(File.fromUri(Uri.file(widget.url)));
  }

  Widget _fromNetworkWidget(BuildContext context) {
    final thumbnail =
        networkImage(widget.url + '_thumbnail', scale: 0.5 * widget.scale);
    final original = networkImage(widget.url, scale: widget.scale);

    return Stack(
      children: <Widget>[
        FadeInImage(
          fadeOutDuration: Duration(milliseconds: 100),
          placeholder: MemoryImage(kTransparentImage),
          image: thumbnail,
          fit: BoxFit.contain,
        ),
        FadeInImage(
          fadeOutDuration: Duration(milliseconds: 100),
          placeholder: MemoryImage(kTransparentImage),
          image: original,
          fit: BoxFit.contain,
        ),
      ],
    );
  }
}
