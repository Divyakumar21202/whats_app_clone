// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/material.dart';

import 'package:whats_app/common/enums/message_enum.dart';
import 'package:whats_app/const/colors.dart';
import 'package:whats_app/features/chats/widgets/video_player.dart';

class DisplayTextImageGif extends StatelessWidget {
  final MessageEnum messageType;
  final String message;
  final bool isMe;
  const DisplayTextImageGif({
    super.key,
    required this.messageType,
    required this.message,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    if (MessageEnum.text == messageType) {
      return Text(
        message,
        style: TextStyle(
          color: isMe ? title : Colors.black,
          fontSize: 16,
        ),
      );
    } else if (MessageEnum.image == messageType) {
      return CachedNetworkImage(
        imageUrl: message,
      );
    } else {
      return VideoPlayer(
        videoUrl: message,
      );
    }
  }
}
