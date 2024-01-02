// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:whats_app/common/repository/common_firebase_storage_repository.dart';
import 'package:whats_app/common/utils/utils.dart';
import 'package:whats_app/features/Group/screens/contact_list_group.dart';
import 'package:whats_app/models/group_model.dart';

final groupRepositoryProvider = Provider(
  (ref) => GroupRepository(
    auth: FirebaseAuth.instance,
    firestore: FirebaseFirestore.instance,
    ref: ref,
  ),
);

class GroupRepository {
  final ProviderRef ref;
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  GroupRepository({
    required this.auth,
    required this.firestore,
    required this.ref,
  });

  void createGroup(BuildContext context, String groupName, File groupPic,
      List<Contact> contacts) async {
    try {
      List<String> Uuids = [];
      for (int i = 0; i < contacts.length; i++) {
        var userCollection = await firestore
            .collection('users')
            .where(
              'phoneNumber',
              isEqualTo:
                  contacts[i].phones[0].number.trim().replaceAll(' ', ''),
            )
            .get();
        if (userCollection.docs.isNotEmpty && userCollection.docs[0].exists) {
          Uuids.add(userCollection.docs[0].data()['uid']);
        }
      }
      ref.read(contactGroupListProvider.notifier).update(
            (state) => [],
          );

      Navigator.pop(context);
      String groupId = Uuid().v1();
      String groupPicUrl = await ref
          .watch(commonFirebaseStorageRepositoryProvider)
          .storeToFirebase(
            'groups/$groupId',
            groupPic,
          );

      GroupModel groupModel = GroupModel(
        name: groupName,
        groupId: groupId,
        groupPic: groupPicUrl,
        lastMessage: '',
        SenderUserId: auth.currentUser!.uid,
        membersUid: [auth.currentUser!.uid, ...Uuids],
      );

      await firestore.collection('groups').doc(groupId).set(
            groupModel.toMap(),
          );
    } catch (e) {
      ShowSnackBar(
        context: context,
        content: e.toString(),
      );
    }
  }
}
