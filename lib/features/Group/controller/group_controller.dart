// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_app/features/Group/repository/group_repository.dart';

final groupControllerProvider = Provider((ref) {
  return GroupController(
    groupRepository: ref.read(groupRepositoryProvider),
  );
});

class GroupController {
  final GroupRepository groupRepository;
  GroupController({
    required this.groupRepository,
  });
  void createGroup(
    BuildContext context,
    String groupName,
    File groupPic,
    List<Contact> contacts,
  ) {
    groupRepository.createGroup(
      context,
      groupName,
      groupPic,
      contacts,
    );
  }
}
