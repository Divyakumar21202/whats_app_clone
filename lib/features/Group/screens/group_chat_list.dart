import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_app/common/widgets/loader.dart';
import 'package:whats_app/features/chats/controllers/chat_controller.dart';
import 'package:whats_app/features/chats/screens/single_chat_screen.dart';
import 'package:whats_app/models/group_model.dart';
import 'package:whats_app/widgets/list_tile_widget.dart';

class GroupChatList extends ConsumerStatefulWidget {
  const GroupChatList({super.key});

  @override
  ConsumerState<GroupChatList> createState() => _GroupChatListState();
}

class _GroupChatListState extends ConsumerState<GroupChatList> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: ref.watch(chatControllerProvider).getGroupList(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Loader();
        }
        return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              GroupModel SingleGroup = snapshot.data![index];
              return InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => SingleChatScreen(
                        name: SingleGroup.name,
                        uid: SingleGroup.groupId,
                        isGroup: true,
                      ),
                    ),
                  );
                },
                child: MyListTileChat(
                  name: SingleGroup.name,
                  message: SingleGroup.lastMessage,
                  image: SingleGroup.groupPic,
                  time: SingleGroup.timeSent,
                ),
              );
            });
      },
    );
  }
}
