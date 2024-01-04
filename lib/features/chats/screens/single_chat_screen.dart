// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:whats_app/common/widgets/loader.dart';
import 'package:whats_app/const/colors.dart';
import 'package:whats_app/features/auth/controller/auth_controller.dart';
import 'package:whats_app/features/chats/widgets/bottom_chat_textField.dart';
import 'package:whats_app/features/chats/widgets/chat_list.dart';
import 'package:whats_app/models/group_model.dart';
import 'package:whats_app/models/user_model.dart';

class SingleChatScreen extends ConsumerStatefulWidget {
  final String uid;
  final String name;
  final bool isGroup;
  const SingleChatScreen({
    super.key,
    required this.uid,
    required this.name,
    required this.isGroup,
  });

  @override
  ConsumerState<SingleChatScreen> createState() => _SingleChatScreenState();
}

class _SingleChatScreenState extends ConsumerState<SingleChatScreen> {
  Stream<UserModel> userData(WidgetRef ref) {
    return ref.watch(authControllerProvider).userData(widget.uid);
  }

  Stream<GroupModel> groupData(WidgetRef ref) {
    return ref.watch(authControllerProvider).groupData(widget.uid);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        leading: const Icon(
          Icons.arrow_back,
          color: title,
        ),
        title: widget.isGroup
            ? Text(
                widget.name,
                style: const TextStyle(color: title),
              )
            : StreamBuilder<UserModel>(
                stream: userData(ref),
                builder: (context, snapshot) {
                  debugPrint(snapshot.data.toString());
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Loader();
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.name,
                        style: const TextStyle(color: title),
                      ),
                      widget.isGroup
                          ? const SizedBox()
                          : Text(
                              snapshot.data!.isOnline ? 'online' : 'offline',
                              style:
                                  const TextStyle(color: title, fontSize: 12),
                            ),
                    ],
                  );
                }),
        actions: [
          IconButton(
            icon: const Icon(Icons.call),
            onPressed: () {},
            color: title,
          ),
          const SizedBox(
            width: 12,
          ),
          IconButton(
            icon: const Icon(Icons.video_call),
            onPressed: () {},
            color: title,
          ),
          const SizedBox(
            width: 12,
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
            color: title,
          ),
          const SizedBox(
            width: 12,
          ),
        ],
      ),
      body: Align(
        alignment: Alignment.bottomCenter,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: ChatList(
                otherUserUid: widget.uid,
                isGroup: widget.isGroup,
              ),
            ),
            BottomTextField(
              isGroup: widget.isGroup,
              size: size,
              receiverUserId: widget.uid,
            ),
          ],
        ),
      ),
    );
  }
}
