import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';
import 'package:mobile_app/widgets/widgets.dart';
import 'image_content.dart';

class VideoContentWidget extends StatefulWidget {
  final String url;
  final bool fromNetwork;
  final bool autoplay;
  final double volume;

  VideoContentWidget(
      {this.url,
      this.fromNetwork = true,
      this.autoplay = true,
      this.volume = 1.0});

  @override
  _VideoContentWidgetState createState() => _VideoContentWidgetState();
}

class _VideoContentWidgetState extends State<VideoContentWidget> {
  VideoPlayerController _controller;

  @override
  void didUpdateWidget(VideoContentWidget oldWidget) {
    if (widget.url == oldWidget.url) {
      _controller.setVolume(widget.volume);
      super.didUpdateWidget(oldWidget);
      return;
    }

    _initWidget();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    _initWidget();
    super.initState();
  }

  _initWidget() async {
    final controller = _controller;
    setState(() {
      _controller = null;
    });

    await controller?.dispose();
    if (widget.fromNetwork) {
      print('[VideoContentWidget] Playing video ${widget.url}');
      _controller = VideoPlayerController.network(widget.url);
    } else {
      _controller =
          VideoPlayerController.file(File.fromUri(Uri.file(widget.url)));
    }

    _initPlayer().then((_) {
      print('set state');
      setState(() {});
    });
  }

  Future<void> _initPlayer() async {
    try {
      await _controller.setLooping(true);
      await _controller.setVolume(widget.volume);
      await _controller.initialize();
      if (widget.autoplay) {
        await _controller.play();
      }
      if (_controller.value.hasError) {
        print(_controller.value.errorDescription);
      }
    } catch (error) {
      print(error.toString());
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
  }

  Widget _buildLoadingWidget(BuildContext context) {
    if (widget.fromNetwork) {
      return Stack(
        alignment: Alignment.center,
        children: <Widget>[
          ImageContentWidget(
            url: widget.url + '_thumbnail',
            scale: 0.5,
          ),
          Material(
            color: Colors.transparent,
            child: CircularProgressIndicator(),
          ),
        ],
      );
    }

    return Center(
      child: CircularProgressIndicator(),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller.value.initialized) {
      return Padding(
        padding: EdgeInsets.only(top: 18.0),
        child: _buildLoadingWidget(context),
      );
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          _controller.value.isPlaying
              ? _controller.pause()
              : _controller.play();
        });
      },
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          ),
          _controller.value.isPlaying
              ? Container()
              : Icon(
                  Icons.play_arrow,
                )
        ],
      ),
    );
  }
}
