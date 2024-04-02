// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:whats_app/common/providers/message_reply_provider.dart';
import 'package:whats_app/common/widgets/loader.dart';
import 'package:whats_app/features/chats/controllers/chat_controller.dart';
import 'package:whats_app/features/chats/widgets/message_reply_preview.dart';
import 'package:whats_app/features/chats/widgets/my_message_card.dart';
import 'package:whats_app/models/message.dart';

class ChatList extends ConsumerStatefulWidget {
  final String otherUserUid;
  final bool isGroup;
  const ChatList({
    super.key,
    required this.otherUserUid,
    required this.isGroup,
  });

  @override
  ConsumerState<ChatList> createState() => _ChatListState();
}

class _ChatListState extends ConsumerState<ChatList> {
  final ScrollController messageController = ScrollController();
  @override
  void dispose() {
    super.dispose();
    messageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.isGroup? StreamBuilder(
      stream: ref
          .watch(chatControllerProvider)
          .getGroupChatMessages(widget.otherUserUid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Loader();
        }
        List<Message> messages = snapshot.data!;
        return ListView.builder(
          controller: messageController,
          itemCount: messages.length,
          itemBuilder: ((context, index) {
            Message singleMessage = messages[index];
            // if (!singleMessage.isSeen &&
            //     singleMessage.receiverId ==
            //         FirebaseAuth.instance.currentUser!.uid) {
            //   ref.read(chatControllerProvider).setChatMessageSeen(
            //         context,
            //         singleMessage.messageId,
            //         widget.otherUserUid,
            //       );
            // }
            if (singleMessage.senderId == FirebaseAuth.instance.currentUser!.uid) {
              return MyMessageCard(
                isSeen: singleMessage.isSeen,
                message: singleMessage.text,
                time: DateFormat.Hm().format(singleMessage.timeSent).toString(),
                messageEnum: singleMessage.type,
                onLeftSwipe: () {
                  // ref.watch(messageReplyProvider.notifier).update(
                  //   (state) {
                  //     return MessageReply(
                  //       message: singleMessage.text,
                  //       isMe: true,
                  //       messageEnum: singleMessage.type,
                  //     );
                    // },
                  // );
                  // const MessageReplyPreview();
                },
                repliedText: singleMessage.repliedMessage,
                userName: singleMessage.repliedTo,
                repliedMessageType: singleMessage.repliedMessageType,
              );
            } else {
              return OtherPersonMessageCard(
                messageEnum: singleMessage.type,
                message: singleMessage.text,
                time: DateFormat.Hm().format(singleMessage.timeSent).toString(),
                onRightSwipe: () {
                  // ref.read(messageReplyProvider.notifier).update((state) {
                  //   return MessageReply(
                  //     message: singleMessage.text,
                  //     isMe: false,
                  //     messageEnum: singleMessage.repliedMessageType,
                  //   );
                  // });
                },
                repliedMessageType: singleMessage.repliedMessageType,
                repliedText: singleMessage.text,
                userName: singleMessage.repliedTo,
              );
            }
          }),
        );
      },
    )
  :StreamBuilder(
      stream: ref
          .watch(chatControllerProvider)
          .getMessagesList(widget.otherUserUid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Loader();
        }
        SchedulerBinding.instance.addPostFrameCallback((_) {
          messageController.jumpTo(messageController.position.maxScrollExtent);
        });
        List<Message> messages = snapshot.data!;
        return ListView.builder(
          controller: messageController,
          itemCount: messages.length,
          itemBuilder: ((context, index) {
            Message singleMessage = messages[index];
            if (!singleMessage.isSeen &&
                singleMessage.receiverId ==
                    FirebaseAuth.instance.currentUser!.uid) {
              ref.read(chatControllerProvider).setChatMessageSeen(
                    context,
                    singleMessage.messageId,
                    widget.otherUserUid,
                  );
            }
            if (singleMessage.senderId != widget.otherUserUid) {
              return MyMessageCard(
                isSeen: singleMessage.isSeen,
                message: singleMessage.text,
                time: DateFormat.Hm().format(singleMessage.timeSent),
                messageEnum: singleMessage.type,
                onLeftSwipe: () {
                  ref.watch(messageReplyProvider.notifier).update(
                    (state) {
                      return MessageReply(
                        message: singleMessage.text,
                        isMe: true,
                        messageEnum: singleMessage.type,
                      );
                    },
                  );
                  const MessageReplyPreview();
                },
                repliedText: singleMessage.repliedMessage,
                userName: singleMessage.repliedTo,
                repliedMessageType: singleMessage.repliedMessageType,
              );
            } else {
              return OtherPersonMessageCard(
                messageEnum: singleMessage.type,
                message: singleMessage.text,
                time: DateFormat.Hm().format(singleMessage.timeSent),
                onRightSwipe: () {
                  ref.read(messageReplyProvider.notifier).update((state) {
                    return MessageReply(
                      message: singleMessage.text,
                      isMe: false,
                      messageEnum: singleMessage.repliedMessageType,
                    );
                  });
                },
                repliedMessageType: singleMessage.repliedMessageType,
                repliedText: singleMessage.text,
                userName: singleMessage.repliedTo,
              );
            }
          }),
        );
      },
    );
  }
}
