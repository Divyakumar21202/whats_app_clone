import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_app/common/utils/utils.dart';
import 'package:whats_app/features/Group/screens/create_group_screen.dart';
import 'package:whats_app/features/Status/Status_screen/statusScreen.dart';
import 'package:whats_app/features/Status/Status_screen/status_conformationScreen.dart';
import 'package:whats_app/features/auth/controller/auth_controller.dart';
import 'package:whats_app/features/chats/screens/chat_screen.dart';
import 'package:whats_app/const/colors.dart';
import 'package:whats_app/features/select_contacts/screen/contact_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
    _tabController.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        ref.read(authControllerProvider).setUserState(true);
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.paused:
      case AppLifecycleState.hidden:
        ref.read(authControllerProvider).setUserState(false);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: const Text(
          "My WhatsApp",
          style: TextStyle(
              fontWeight: FontWeight.w400, fontSize: 22, color: Colors.white),
        ),
        actions: [
          const Icon(Icons.camera_enhance_rounded),
          const SizedBox(
            width: 15,
          ),
          const Icon(Icons.search),
          const SizedBox(
            width: 15,
          ),
          PopupMenuButton(itemBuilder: (context) {
            return [
              PopupMenuItem(
                child: const Text('Create Group'),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: ((context) => CreateGroupScreen()),
                    ),
                  );
                },
              ),
            ];
          }),
          const SizedBox(
            width: 15,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Text('Chats'),
            Text('Status'),
            Text('Calls'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Container(
            color: backgroundColor,
            child: const ChatScreen(),
          ),
          Container(
            color: backgroundColor,
            child: const StatusScreen(),
          ),
          const Center(
            child: Text('Calls Screen'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (_tabController.index == 1) {
            File? file = await pickImageFomGallery(context);
            if (file != null) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => StatusConformation(file: file),
                ),
              );
            }
          } else {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const ContactScreen(),
              ),
            );
          }
        },
        child: Icon(
          _tabController.index == 1 ? Icons.add : Icons.message_rounded,
          size: 23,
        ),
      ),
    );
  }
}
