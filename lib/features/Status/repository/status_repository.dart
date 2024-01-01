// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_app/common/repository/common_firebase_storage_repository.dart';

import 'package:whats_app/common/utils/utils.dart';

final statusRepositoryProvider = Provider(
  (ref) => StatusRepository(
    ref: ref,
    auth: FirebaseAuth.instance,
    firestore: FirebaseFirestore.instance,
  ),
);

class StatusRepository {
  final ProviderRef ref;
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  StatusRepository({
    required this.ref,
    required this.auth,
    required this.firestore,
  });

  void uploadStatus(
      BuildContext context, File file, String statusMessage) async {
    try {
      String uid = auth.currentUser!.uid;

      String FileUrl = await ref
          .read(commonFirebaseStorageRepositoryProvider)
          .storeToFirebase('/status/$uid', file);

      await firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('chats')
          .doc('status')
          .set(
        {
          'FileUrl': FileUrl,
          'Message': statusMessage,
        },
      );
    } catch (e) {
      ShowSnackBar(
        context: context,
        content: e.toString(),
      );
    }
  }
}
