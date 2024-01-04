import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_app/features/chats/screens/single_chat_screen.dart';
import 'package:whats_app/common/widgets/loader.dart';
import 'package:whats_app/features/chats/controllers/chat_controller.dart';
import 'package:whats_app/models/chat_contact.dart';
import 'package:whats_app/widgets/list_tile_widget.dart';

class ChatScreen extends ConsumerWidget {
  const ChatScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder(
        stream: ref.watch(chatControllerProvider).getChatContactList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loader();
          }
          return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                ChatContact user = snapshot.data![index];
                String name = user.name;
                String image = user.profilePic;
                String message = user.lastMessage;
                var time = user.timeSent;
                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => SingleChatScreen(
                          uid: user.contactId,
                          name: user.name,
                          isGroup: false,
                        ),
                      ),
                    );
                  },
                  child: MyListTileChat(
                    name: name,
                    message: message,
                    image: image,
                    time: time,
                  ),
                );
              });
        });
  }
}
