import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:whats_app/common/enums/message_enum.dart';
import 'package:whats_app/common/providers/message_reply_provider.dart';
import 'package:whats_app/common/repository/common_firebase_storage_repository.dart';
import 'package:whats_app/common/utils/utils.dart';
import 'package:whats_app/models/chat_contact.dart';
import 'package:whats_app/models/group_model.dart';
import 'package:whats_app/models/message.dart';
import 'package:whats_app/models/user_model.dart';

final chatRepositoryProvider = Provider(
  (ref) => ChatRepository(
    auth: FirebaseAuth.instance,
    firestore: FirebaseFirestore.instance,
  ),
);

class ChatRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  ChatRepository({
    required this.auth,
    required this.firestore,
  });

  Stream<List<ChatContact>> getChatContacts() {
    // List<ChatContact> contacts = [];
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .snapshots()
        .asyncMap(
      (event) async {
        List<ChatContact> messages = [];
        for (var document in event.docs) {
          var singleContact = ChatContact.fromMap(document.data());
          messages.add(singleContact);
          //2nd Method
          // var userData = await firestore
          //     .collection('users')
          //     .doc(singleContact.contactId)
          //     .get();
          // var user = UserModel.fromMap(userData.data()!);
          // messages.add(
          //   ChatContact(
          //     profilePic: user.profilePic,
          //     name: user.name,
          //     contactId: user.uid,
          //     timeSent: singleContact.timeSent,
          //     lastMessage: singleContact.lastMessage,
          //   ),
          // );
        }
        return messages;
      },
    );
  }

  Stream<List<GroupModel>> getGroupList() {
    return firestore.collection('groups').snapshots().map(
      (event) {
        List<GroupModel> groupsList = [];
        for (var document in event.docs) {
          GroupModel SingleGroup = GroupModel.fromMap(document.data());
          if (SingleGroup.membersUid.contains(auth.currentUser!.uid)) {
            groupsList.add(SingleGroup);
          }
        }
        return groupsList;
      },
    );
  }

  Stream<List<Message>> getChatMessages(String otherUserUid) {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(otherUserUid)
        .collection('messages')
        .orderBy('timeSent') //for order according to sent time ..
        .snapshots()
        .map(
      (event) {
        List<Message> messages = [];
        for (var document in event.docs) {
          Message singleMessage = Message.fromMap(
            document.data(),
          );
          messages.add(singleMessage);
        }
        return messages;
      },
    );
  }

  void _saveDataToContactSubCollection(
    UserModel senderUSerData,
    UserModel receiverUserData,
    String text,
    DateTime timeSent,
    String receiverUserId,
  ) async {
    // users -> receiver user id -> chats -> sender user id -> set data
    var receiverChatContact = ChatContact(
      profilePic: senderUSerData.profilePic,
      name: senderUSerData.name,
      contactId: senderUSerData.uid,
      timeSent: timeSent,
      lastMessage: text,
    );
    await firestore
        .collection('users')
        .doc(receiverUserId)
        .collection('chats')
        .doc(senderUSerData.uid)
        .set(
          receiverChatContact.toMap(),
        );
    // users -> sender user id -> chats -> receiver user id -> set data
    var senderChatContact = ChatContact(
      profilePic: receiverUserData.profilePic,
      name: receiverUserData.name,
      contactId: receiverUserData.uid,
      timeSent: timeSent,
      lastMessage: text,
    );
    await firestore
        .collection('users')
        .doc(senderUSerData.uid)
        .collection('chats')
        .doc(receiverUserId)
        .set(
          senderChatContact.toMap(),
        );
  }

  void _saveMessageToMessageSubCollection({
    required String receiverUSerId,
    required String text,
    required DateTime timeSent,
    required String messageId,
    required String userName,
    required String receiverUserName,
    required MessageEnum messageType,
    required String senderUid,
    required MessageReply? messageReply,
    required String SenderUserName,
  }) async {
    final message = Message(
      senderId: senderUid,
      receiverId: receiverUSerId,
      text: text,
      type: messageType,
      timeSent: timeSent,
      messageId: messageId,
      isSeen: false,
      repliedMessage: messageReply == null ? '' : messageReply.message,
      repliedTo: messageReply == null
          ? ''
          : messageReply.isMe
              ? SenderUserName
              : receiverUserName,
      repliedMessageType:
          messageReply == null ? MessageEnum.text : messageReply.messageEnum,
    );
    // Users -> SenderUserId -> ReceiverUserId -> message -> messageId -> storeMessage .
    await firestore
        .collection('users')
        .doc(senderUid)
        .collection('chats')
        .doc(receiverUSerId)
        .collection('messages')
        .doc(messageId)
        .set(
          message.toMap(),
        );
    // Users -> ReceiverUserId -> SenderUserId  -> message -> messageId -> storeMessage .
    await firestore
        .collection('users')
        .doc(receiverUSerId)
        .collection('chats')
        .doc(senderUid)
        .collection('messages')
        .doc(messageId)
        .set(message.toMap());
  }

  void sendTextMessage({
    required BuildContext context,
    required String text,
    required String receiverUserId,
    required UserModel senderUser,
    required MessageReply? messageReply,
  }) async {
    try {
      UserModel receiverUser;
      var time = DateTime.now();
      var userDataMap =
          await firestore.collection('users').doc(receiverUserId).get();
      receiverUser = UserModel.fromMap(userDataMap.data()!);
      var messageId = const Uuid().v1();
      _saveDataToContactSubCollection(
        senderUser,
        receiverUser,
        text,
        time,
        receiverUser.uid,
      );
      _saveMessageToMessageSubCollection(
        receiverUSerId: receiverUser.uid,
        text: text,
        timeSent: time,
        messageId: messageId,
        userName: senderUser.name,
        receiverUserName: receiverUser.name,
        messageType: MessageEnum.text,
        senderUid: senderUser.uid,
        messageReply: messageReply,
        SenderUserName: senderUser.name,
      );
    } catch (e) {
      ShowSnackBar(context: context, content: e.toString());
    }
  }

  void sentFileMessage({
    required BuildContext context,
    required File file,
    required ProviderRef ref,
    required String receiverUid,
    required UserModel senderUser,
    required MessageEnum messageEnum,
    required MessageReply? messageReply,
  }) async {
    try {
      var timeSent = DateTime.now();
      var messageId = Uuid().v1();

      String fileUrl = await ref
          .read(commonFirebaseStorageRepositoryProvider)
          .storeToFirebase(
            'chat/${messageEnum.type}/${senderUser.uid}/$messageId',
            file,
          );
      var receiverUserData =
          await firestore.collection('users').doc(receiverUid).get();
      UserModel receiverModel = UserModel.fromMap(
        receiverUserData.data()!,
      );
      String messageType;

      switch (messageEnum) {
        case MessageEnum.image:
          messageType = '📸 Photo';
          break;
        case MessageEnum.video:
          messageType = '📽️ Video';
          break;
        case MessageEnum.audio:
          messageType = '🎵 Audio';
          break;
        default:
          messageType = 'GIF';
      }
      // users -> receiver -> chats -> sender -> update Data // last message
      _saveDataToContactSubCollection(
          senderUser, receiverModel, messageType, timeSent, receiverUid);
      _saveMessageToMessageSubCollection(
        receiverUSerId: receiverUid,
        text: fileUrl,
        timeSent: timeSent,
        messageId: messageId,
        userName: senderUser.name,
        receiverUserName: receiverModel.name,
        messageType: messageEnum,
        senderUid: senderUser.uid,
        messageReply: messageReply,
        SenderUserName: senderUser.name,
      );
    } catch (e) {
      ShowSnackBar(
        context: context,
        content: e.toString(),
      );
    }
  }

  void setChatMessageSeen({
    required BuildContext context,
    required String receiverUserId,
    required String messageId,
  }) async {
    try {
      await firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('chats')
          .doc(receiverUserId)
          .collection('messages')
          .doc(messageId)
          .update({'isSeen': true});
      // Users -> ReceiverUserId -> SenderUserId  -> message -> messageId -> storeMessage .
      await firestore
          .collection('users')
          .doc(receiverUserId)
          .collection('chats')
          .doc(auth.currentUser!.uid)
          .collection('messages')
          .doc(messageId)
          .update({'isSeen': true});
    } catch (e) {
      ShowSnackBar(
        context: context,
        content: e.toString(),
      );
    }
  }

  void sendGroupTextMessage({
    required BuildContext context,
    required String text,
    required String groupId,
    required UserModel senderUser,
  }) async {
    try {
      DateTime time = DateTime.now();
      var messageId = const Uuid().v1();
      final message = Message(
        senderId: senderUser.uid,
        receiverId: groupId,
        text: text,
        type: MessageEnum.text,
        timeSent: time,
        messageId: messageId,
        isSeen: false,
        repliedMessage: '',
        repliedTo: '',
        repliedMessageType: MessageEnum.text,
      );
      firestore.collection('groups').doc(groupId).collection('chats').add(
            message.toMap(),
          );
      firestore.collection('groups').doc(groupId).update(
        {
          'lastMessage': text,
          'timeSent': time.millisecondsSinceEpoch,
        },
      );
    } catch (e) {
      ShowSnackBar(context: context, content: e.toString());
    }
  }

  Stream<List<Message>> getGroupChatMessages(String groupId) {
    return firestore
        .collection('groups')
        .doc(groupId)
        .collection('chats')
        .orderBy('timeSent') //for order according to sent time ..
        .snapshots()
        .map(
      (event) {
        List<Message> messages = [];
        for (var document in event.docs) {
          Message singleMessage = Message.fromMap(
            document.data(),
          );
          messages.add(singleMessage);
        }
        return messages;
      },
    );
  }
}
