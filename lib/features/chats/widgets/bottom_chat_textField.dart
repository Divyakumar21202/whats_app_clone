import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_app/common/enums/message_enum.dart';
import 'package:whats_app/common/providers/message_reply_provider.dart';
import 'package:whats_app/common/utils/utils.dart';
import 'package:whats_app/const/colors.dart';
import 'package:whats_app/features/chats/controllers/chat_controller.dart';
import 'package:whats_app/features/chats/widgets/message_reply_preview.dart';

class BottomTextField extends ConsumerStatefulWidget {
  const BottomTextField({
    super.key,
    required this.size,
    required this.receiverUserId,
  });

  final Size size;
  final String receiverUserId;

  @override
  ConsumerState<BottomTextField> createState() => _BottomTextFieldState();
}

class _BottomTextFieldState extends ConsumerState<BottomTextField> {
  final _controller = TextEditingController();
  bool isReplying = false;
  bool isSend = false;
  void sendTextMessage(bool isReplying) {
    if (isSend && isReplying) {
      ref.read(chatControllerProvider).sendTextMessage(
            context,
            _controller.text.trim(),
            widget.receiverUserId,
          );
    } else if (isSend && !isReplying) {
      ref.read(chatControllerProvider).sendTextMessage(
            context,
            _controller.text.trim(),
            widget.receiverUserId,
          );
    }
    setState(() {
      _controller.text = '';
      isSend = false;
      ref.read(messageReplyProvider.notifier).update((state) => null);
    });
  }

  void sendFileToFB(MessageEnum messageEnum, File file) {
    ref.read(chatControllerProvider).sendFileMessage(
          context: context,
          messageEnum: messageEnum,
          receiverUserId: widget.receiverUserId,
          file: file,
        );
  }

  void sendImage() async {
    File? image;
    image = await pickImageFomGallery(context);
    if (image != null) {
      sendFileToFB(
        MessageEnum.image,
        image,
      );
    }
  }

  void sendVideo() async {
    File? video;
    video = await pickVideoFomGallery(context);
    if (video != null) {
      sendFileToFB(
        MessageEnum.video,
        video,
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final messageReply = ref.watch(messageReplyProvider);
    final isShowMessageReply = messageReply != null;
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          children: [
            isShowMessageReply ? const MessageReplyPreview() : const SizedBox(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: widget.size.width * 0.80,
                  child: Column(
                    children: [
                      TextField(
                        onChanged: (val) {
                          if (val.isNotEmpty) {
                            isSend = true;
                            setState(() {});
                          } else {
                            isSend = false;
                            setState(() {});
                          }
                        },
                        controller: _controller,
                        decoration: InputDecoration(
                          filled: true,
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            borderSide: BorderSide(
                              width: 0,
                              style: BorderStyle.none,
                            ),
                          ),
                          hintStyle: const TextStyle(color: Colors.black),
                          suffixIcon: Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 20.0),
                            child: SizedBox(
                              width: 58,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      sendVideo();
                                    },
                                    child: const Icon(
                                      Icons.attach_file_rounded,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      sendImage();
                                    },
                                    child: const Icon(Icons.camera_alt),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          hintText: "Message",
                        ),
                      ),
                    ],
                  ),
                ),
                FloatingActionButton(
                  onPressed: () {
                    if (isSend) {
                      ref.watch(messageReplyProvider) != null
                          ? isReplying = true
                          : isReplying = false;
                      sendTextMessage(isReplying);
                    }
                  },
                  backgroundColor: Colors.green[400],
                  shape: const CircleBorder(
                    side: BorderSide.none,
                  ),
                  child:
                      isSend ? const Icon(Icons.send) : const Icon(Icons.mic),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
