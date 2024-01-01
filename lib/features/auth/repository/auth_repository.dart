import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_app/Screens/home_screen.dart';
import 'package:whats_app/common/repository/common_firebase_storage_repository.dart';
import 'package:whats_app/common/utils/utils.dart';
import 'package:whats_app/features/auth/screens/otp_screen.dart';
import 'package:whats_app/features/auth/screens/user_info_screen.dart';
import 'package:whats_app/models/user_model.dart';

/// Provider is for provide the required data or class without involving the business logic into it .
final AuthRepositoryProvier = Provider(
  (ref) => AuthRepository(
      firestore: FirebaseFirestore.instance, auth: FirebaseAuth.instance),
);

class AuthRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  AuthRepository({required this.firestore, required this.auth});

  Future<UserModel?> GetCurrentUser() async {
    UserModel? user;
    var userData =
        await firestore.collection('users').doc(auth.currentUser?.uid).get();
    if (userData.data() != null) {
      user = UserModel.fromMap(userData.data()!);
    }
    return user;
  }

  void signInWithPhone(BuildContext context, String phoneNumber) async {
    try {
      await auth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted: (PhoneAuthCredential credential) async {
            await auth.signInWithCredential(credential);
          },
          verificationFailed: (e) {
            throw Exception(e.message);
          },
          codeSent: (String identificationID, int? code) async {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => OtpScreen(
                  identificationId: identificationID,
                ),
              ),
            );
          },
          codeAutoRetrievalTimeout: (String s) {});
    } on FirebaseAuthException catch (e) {
      ShowSnackBar(context: context, content: e.message!);
    }
  }

  void verifyOtp({
    required BuildContext context,
    required String verificationId,
    required String UserOtp,
  }) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: UserOtp);
      await auth.signInWithCredential(credential);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) => const UserInformationScreen()),
          (route) => false);
    } on FirebaseAuthException catch (e) {
      ShowSnackBar(context: context, content: e.message!);
    }
  }

  void saveUserDataToFirebase({
    required File? profPic,
    required String name,
    required BuildContext context,
    required ProviderRef ref,
  }) async {
    try {
      String uid = auth.currentUser!.uid;
      String imageUrl =
          'https://t4.ftcdn.net/jpg/01/18/03/35/240_F_118033506_uMrhnrjBWBxVE9sYGTgBht8S5liVnIeY.jpg';
      if (profPic != null) {
        imageUrl = await ref
            .read(commonFirebaseStorageRepositoryProvider)
            .storeToFirebase('/profPic$uid', profPic);

        final userModel = UserModel(
          name: name,
          uid: uid,
          profilePic: imageUrl,
          isOnline: true,
          phoneNumber: auth.currentUser!.phoneNumber!,
          groupId: [],
        );

        await firestore.collection('users').doc(uid).set(userModel.toMap());
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
            (route) => false);
      }
    } catch (e) {
      ShowSnackBar(context: context, content: e.toString());
    }
  }

  Stream<UserModel> userData(String userId) {
    return firestore.collection('users').doc(userId).snapshots().map(
          (event) => UserModel.fromMap(event.data()!),
        );
  }

  void setUserState(bool isOnline) async {
    await firestore.collection('users').doc(auth.currentUser!.uid).update(
      {
        'isOnline': isOnline,
      },
    );
  }
}
