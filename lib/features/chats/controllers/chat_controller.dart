// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_app/common/enums/message_enum.dart';
import 'package:whats_app/common/providers/message_reply_provider.dart';
import 'package:whats_app/features/auth/controller/auth_controller.dart';

import 'package:whats_app/features/chats/repository/chat_repository.dart';
import 'package:whats_app/models/chat_contact.dart';
import 'package:whats_app/models/group_model.dart';
import 'package:whats_app/models/message.dart';

final chatControllerProvider = Provider(
  (ref) => ChatController(
      chatRepository: ref.read(chatRepositoryProvider), ref: ref),
);

class ChatController {
  final ChatRepository chatRepository;
  final ProviderRef ref;
  ChatController({
    required this.chatRepository,
    required this.ref,
  });

  void sendTextMessage(
    BuildContext context,
    String text,
    String receiverUserId,
  ) {
    MessageReply? messageReply = ref.watch(messageReplyProvider);

    ref.read(userDataprovider).whenData(
          (value) => chatRepository.sendTextMessage(
              messageReply: messageReply,
              context: context,
              text: text,
              receiverUserId: receiverUserId,
              senderUser: value!),
        );
  }

  void sendGroupTextMessage(
      {required BuildContext context,
      required String text,
      required String groupId}) {
    ref.read(userDataprovider).whenData((value) {
      chatRepository.sendGroupTextMessage(
        context: context,
        text: text,
        groupId: groupId,
        senderUser: value!,
      );
    });
  }

  void sendFileMessage(
      {required BuildContext context,
      required MessageEnum messageEnum,
      required String receiverUserId,
      required File file}) {
    MessageReply? messageReply = ref.watch(messageReplyProvider);

    ref.read(userDataprovider).whenData(
      (value) {
        chatRepository.sentFileMessage(
            context: context,
            messageReply: messageReply,
            file: file,
            ref: ref,
            receiverUid: receiverUserId,
            senderUser: value!,
            messageEnum: messageEnum);
      },
    );
  }

  Stream<List<Message>> getMessagesList(String OtherUserId) {
    return chatRepository.getChatMessages(OtherUserId);
  }

  Stream<List<Message>> getGroupChatMessages(String groupId) {
    return chatRepository.getGroupChatMessages(groupId);
  }

  Stream<List<ChatContact>> getChatContactList() {
    return chatRepository.getChatContacts();
  }

  Stream<List<GroupModel>> getGroupList() {
    return chatRepository.getGroupList();
  }

  void setChatMessageSeen(
    BuildContext context,
    String messageId,
    String receiverUserId,
  ) {
    chatRepository.setChatMessageSeen(
      context: context,
      receiverUserId: receiverUserId,
      messageId: messageId,
    );
  }
}
