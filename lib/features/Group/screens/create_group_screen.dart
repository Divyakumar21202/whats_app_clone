import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_app/common/utils/utils.dart';
import 'package:whats_app/const/colors.dart';

class CreateGroupScreen extends ConsumerStatefulWidget {
  const CreateGroupScreen({super.key});

  @override
  ConsumerState<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends ConsumerState<CreateGroupScreen> {
  late TextEditingController _controller = TextEditingController();
  File? image;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void selectImage() async {
    File? pic = await pickImageFomGallery(context);
    if (pic != null) {
      image = pic;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Padding(
        padding: const EdgeInsets.only(
          left: 12,
          right: 12,
          bottom: 6,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    image == null
                        ? const CircleAvatar(
                            radius: 64,
                            backgroundImage: NetworkImage(
                                'https://img.freepik.com/free-vector/online-community_24877-50878.jpg?size=626&ext=jpg&uid=R107090669&ga=GA1.2.1948187877.1675699674&semt=ais'),
                          )
                        : CircleAvatar(
                            backgroundImage: FileImage(image!), radius: 64),
                    Positioned(
                      left: 93,
                      top: 93,
                      child: IconButton(
                        color: Colors.purple,
                        onPressed: () {
                          selectImage();
                        },
                        icon: const Icon(Icons.camera),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintStyle: TextStyle(color: Colors.blue),
                hintText: 'Enter Group Name',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        foregroundColor: title,
        backgroundColor: backgroundColor,
        title: const Text(
          'Create Group',
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
      ),
    );
  }
}
