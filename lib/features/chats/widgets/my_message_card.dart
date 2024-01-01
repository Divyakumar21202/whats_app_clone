// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:swipe_to/swipe_to.dart';

import 'package:whats_app/common/enums/message_enum.dart';
import 'package:whats_app/features/chats/widgets/display_text_image_gif.dart';

class MyMessageCard extends StatelessWidget {
  final String message;
  final String time;
  final MessageEnum messageEnum;
  final VoidCallback onLeftSwipe;
  final String repliedText;
  final String userName;
  final MessageEnum repliedMessageType;
  final bool isSeen;
  const MyMessageCard({
    super.key,
    required this.message,
    required this.time,
    required this.messageEnum,
    required this.onLeftSwipe,
    required this.repliedText,
    required this.userName,
    required this.repliedMessageType,
    required this.isSeen,
  });

  @override
  Widget build(BuildContext context) {
    return SwipeTo(
      onLeftSwipe: (val) {
        onLeftSwipe();
      },
      child: Align(
        alignment: Alignment.centerRight,
        child: ConstrainedBox(
          constraints:
              BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width - 45),
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6)),
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              elevation: 1,
              color: Colors.red[400],
              child: Column(
                children: [
                  if (repliedText.isNotEmpty) ...[
                    Container(
                      margin: const EdgeInsets.only(
                        top: 6,
                        right: 6,
                        left: 6,
                        bottom: 2,
                      ),
                      padding: const EdgeInsets.only(
                        left: 6,
                        right: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 255, 4, 0),
                        borderRadius: BorderRadius.circular(
                          12,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'You',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          DisplayTextImageGif(
                            isMe: true,
                            messageType: repliedMessageType,
                            message: repliedText,
                          ),
                        ],
                      ),
                    ),
                  ],
                  Stack(
                    children: [
                      Padding(
                        padding: MessageEnum.text == messageEnum
                            ? const EdgeInsets.only(
                                right: 30, left: 10, top: 5, bottom: 20)
                            : const EdgeInsets.only(
                                top: 5, left: 5, right: 5, bottom: 30),
                        child: DisplayTextImageGif(
                          isMe: true,
                          messageType: messageEnum,
                          message: message,
                        ),
                      ),
                      Positioned(
                        right: 10,
                        bottom: 4,
                        child: Row(
                          children: [
                            Text(time),
                            const SizedBox(
                              width: 5,
                            ),
                            isSeen
                                ? const Icon(
                                    Icons.done_all,
                                    color: Colors.blue,
                                    size: 20,
                                  )
                                : const Icon(
                                    Icons.done,
                                    size: 20,
                                  ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class OtherPersonMessageCard extends StatelessWidget {
  final String message;
  final String time;
  final MessageEnum messageEnum;
  final VoidCallback onRightSwipe;
  final String repliedText;
  final String userName;
  final MessageEnum repliedMessageType;
  const OtherPersonMessageCard({
    super.key,
    required this.message,
    required this.time,
    required this.messageEnum,
    required this.onRightSwipe,
    required this.repliedText,
    required this.userName,
    required this.repliedMessageType,
  });
  @override
  Widget build(BuildContext context) {
    return SwipeTo(
      onRightSwipe: (val) {
        onRightSwipe();
      },
      child: Align(
          alignment: Alignment.centerLeft,
          child: ConstrainedBox(
            constraints:
                BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width - 45),
            child: Padding(
              padding: const EdgeInsets.all(6),
              child: Card(
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Stack(
                  children: [
                    Padding(
                      padding: MessageEnum.text == messageEnum
                          ? const EdgeInsets.only(
                              right: 30,
                              left: 10,
                              top: 5,
                              bottom: 20,
                            )
                          : const EdgeInsets.only(
                              top: 5, left: 5, right: 5, bottom: 30),
                      child: DisplayTextImageGif(
                        isMe: false,
                        messageType: messageEnum,
                        message: message,
                      ),
                    ),
                    Positioned(
                      right: 10,
                      bottom: 4,
                      child: Row(
                        children: [
                          Text(time),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
