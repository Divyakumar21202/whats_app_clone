import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_app/common/enums/message_enum.dart';
import 'package:whats_app/common/providers/message_reply_provider.dart';
import 'package:whats_app/const/colors.dart';
import 'package:whats_app/features/chats/widgets/display_text_image_gif.dart';

class MessageReplyPreview extends ConsumerWidget {
  const MessageReplyPreview({super.key});
  void cancelReply(WidgetRef ref) {
    ref.read(messageReplyProvider.notifier).update((state) => null);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messageReply = ref.watch(messageReplyProvider);
    final size = MediaQuery.sizeOf(context);
    return SingleChildScrollView(
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.only(
              bottom: 8,
              left: 8,
            ),
            decoration: BoxDecoration(
              color: Colors.purple,
              borderRadius: BorderRadius.circular(
                12,
              ),
            ),
            padding: const EdgeInsets.only(
              left: 10,
              right: 10,
              top: 5,
              bottom: 5,
            ),
            width: size.width * 0.8,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        messageReply!.isMe ? 'ME' : 'Opposite',
                        style: const TextStyle(
                            fontWeight: FontWeight.w400, color: title),
                      ),
                    ),
                    GestureDetector(
                      child: const Icon(
                        Icons.close,
                        size: 16,
                      ),
                      onTap: () {
                        cancelReply(ref);
                      },
                    ),
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                DisplayTextImageGif(
                  messageType: messageReply.messageEnum,
                  message: messageReply.message,
                  isMe: messageReply.isMe,
                ),
              ],
            ),
          ),
          SizedBox(
            width: size.width * 0.1,
          ),
        ],
      ),
    );
  }
}
