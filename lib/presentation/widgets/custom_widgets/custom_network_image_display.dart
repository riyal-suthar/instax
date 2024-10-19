import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import '../other_widgets/play_this_video.dart';

class NetworkDisplay extends StatefulWidget {
  final int cachingHeight, cachingWidth;
  final String url, blurHash;
  final double aspectRatio;
  final bool isThatImage;
  final double? height;
  final double? width;
  const NetworkDisplay(
      {super.key,
      this.cachingHeight = 720,
      this.cachingWidth = 720,
      required this.url,
      this.blurHash = "",
      this.aspectRatio = 0.0,
      this.isThatImage = true,
      this.height,
      this.width});

  @override
  State<NetworkDisplay> createState() => _NetworkDisplayState();
}

class _NetworkDisplayState extends State<NetworkDisplay> {
  @override
  void didChangeDependencies() {
    if (widget.isThatImage && widget.url.isNotEmpty) {
      precacheImage(NetworkImage(widget.url), context);
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return widget.aspectRatio == 0 ? whichBuild(height: null) : aspectRatio();
  }

  Widget aspectRatio() {
    return AspectRatio(
      aspectRatio: widget.aspectRatio,
      child: whichBuild(),
    );
  }

  Widget whichBuild({double? height = double.infinity}) {
    return !widget.isThatImage
        ? PlayThisVideo(
            play: true,
            videoUrl: widget.url,
            blurHash: widget.blurHash,
          )
        : buildOcto(height);
  }

  Widget buildOcto(height) {
    int cachingHeight = widget.cachingHeight;
    int cachingWidth = widget.cachingWidth;
    if (widget.aspectRatio != 1 && cachingHeight == 720) cachingHeight = 960;

    return CachedNetworkImage(
      imageUrl: widget.url,
      fit: BoxFit.cover,
      width: widget.width ?? double.infinity,
      height: widget.height ?? height,
      placeholder: widget.blurHash.isNotEmpty
          ? (context, _) => _blurHash
          : (context, _) => Center(child: loadingWidget()),
      errorWidget: (context, url, error) => buildError(),
    );
  }

  Widget get _blurHash => BlurHash(hash: widget.blurHash, color: Colors.white);

  SizedBox buildError() {
    return SizedBox(
      width: double.infinity,
      height: widget.aspectRatio,
      child: Icon(Icons.warning_amber_rounded,
          size: 30, color: Theme.of(context).focusColor),
    );
  }

  Widget loadingWidget() {
    double aspectRatio = widget.aspectRatio;
    return aspectRatio == 0
        ? buildSizedBox()
        : AspectRatio(
            aspectRatio: aspectRatio,
            child: buildSizedBox(),
          );
  }

  Widget buildSizedBox() {
    return Container(
      width: double.infinity,
      color: Theme.of(context).textTheme.bodyMedium!.color,
      child: Center(
          child: CircleAvatar(
        radius: 57,
        backgroundColor: Theme.of(context).textTheme.bodySmall!.color,
        child: Center(
            child: CircleAvatar(
          radius: 56,
          backgroundColor: Theme.of(context).textTheme.bodyMedium!.color,
        )),
      )),
    );
  }
}
