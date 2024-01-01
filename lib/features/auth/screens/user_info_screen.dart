import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_app/common/utils/utils.dart';
import 'package:whats_app/const/colors.dart';
import 'dart:io';

import 'package:whats_app/features/auth/controller/auth_controller.dart';

class UserInformationScreen extends ConsumerStatefulWidget {
  const UserInformationScreen({super.key});

  @override
  ConsumerState<UserInformationScreen> createState() =>
      _UserInformationScreenState();
}

class _UserInformationScreenState extends ConsumerState<UserInformationScreen> {
  final TextEditingController nameController = TextEditingController();
  File? image;
  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
  }

  void selectImage() async {
    image = await pickImageFomGallery(context);
    setState(() {});
  }

  void storeUserData() async {
    String name = nameController.text.trim();
    if (name.isNotEmpty) {
      ref
          .read(authControllerProvider)
          .saveUserDataToFirebase(image, name, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Stack(
                children: [
                  SizedBox(
                    height: size.height * 0.4,
                    width: size.width * 0.5,
                    child: image == null
                        ? const CircleAvatar(
                            backgroundImage: NetworkImage(
                                'https://t4.ftcdn.net/jpg/01/18/03/35/240_F_118033506_uMrhnrjBWBxVE9sYGTgBht8S5liVnIeY.jpg'),
                          )
                        : CircleAvatar(
                            radius: 60,
                            backgroundImage: FileImage(image!),
                          ),
                  ),
                  Positioned(
                    right: 15,
                    bottom: 45,
                    child: IconButton(
                      onPressed: () {
                        selectImage();
                      },
                      icon: const Icon(
                        Icons.add_a_photo_rounded,
                        color: title,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: size.width * 0.7,
                child: TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintStyle: const TextStyle(color: title),
                    hintText: 'Enter your name',
                    suffixIcon: InkWell(
                      onTap: storeUserData,
                      child: const Icon(
                        Icons.done,
                        color: title,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
