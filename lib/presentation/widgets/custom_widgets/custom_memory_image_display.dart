import 'dart:io';
import 'dart:typed_data';
import 'package:octo_image/octo_image.dart';
import 'package:flutter/material.dart';
import 'package:instax/presentation/widgets/other_widgets/play_this_video.dart';

class MemoryDisplay extends StatefulWidget {
  final bool isThatImage;
  final Uint8List imagePath;
  const MemoryDisplay(
      {super.key, this.isThatImage = true, required this.imagePath});

  @override
  State<MemoryDisplay> createState() => _MemoryDisplayState();
}

class _MemoryDisplayState extends State<MemoryDisplay> {
  @override
  void didChangeDependencies() {
    if (widget.isThatImage && widget.imagePath.isNotEmpty) {
      precacheImage(MemoryImage(widget.imagePath), context);
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return !widget.isThatImage
        ? PlayThisVideo(
            play: true,
            isThatFromMemory: true,
            videoUrl: File.fromRawPath(widget.imagePath).path,
          )
        : OctoImage(
            image: MemoryImage(widget.imagePath),
            errorBuilder: (context, url, error) => buildError(),
            fit: BoxFit.cover,
            width: double.infinity,
            placeholderBuilder: (context) => Center(child: buildSizedBox()),
          );
  }

  SizedBox buildError() {
    return SizedBox(
      child: Icon(Icons.warning_amber_rounded,
          size: 30, color: Theme.of(context).focusColor),
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
