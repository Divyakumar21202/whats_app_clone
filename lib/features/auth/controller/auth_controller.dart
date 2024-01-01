import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_app/features/auth/repository/auth_repository.dart';
import 'package:whats_app/models/user_model.dart';

final authControllerProvider = Provider((ref) {
  final authRepository = ref.watch(AuthRepositoryProvier);
  return AuthController(authRepository: authRepository, ref: ref);
});

final userDataprovider = FutureProvider((ref) {
  final authController = ref.watch(authControllerProvider);
  return authController.getUserData();
});

class AuthController {
  final AuthRepository authRepository;
  final ProviderRef ref;
  AuthController({required this.authRepository, required this.ref});

  Future<UserModel?> getUserData() async {
    UserModel? user = await authRepository.GetCurrentUser();
    return user;
  }

  Stream<UserModel> userData(String userId) {
    return authRepository.userData(userId);
  }

  void signInWithPhone(BuildContext context, String phoneNumber) {
    authRepository.signInWithPhone(context, phoneNumber);
  }

  void verifyOtp(BuildContext context, String verificationId, String UserOtp) {
    authRepository.verifyOtp(
        context: context, verificationId: verificationId, UserOtp: UserOtp);
  }

  void saveUserDataToFirebase(
    File? profPic,
    String name,
    BuildContext context,
  ) {
    authRepository.saveUserDataToFirebase(
        profPic: profPic, name: name, context: context, ref: ref);
  }

  void setUserState(bool isOnline) {
    authRepository.setUserState(isOnline);
  }
}
