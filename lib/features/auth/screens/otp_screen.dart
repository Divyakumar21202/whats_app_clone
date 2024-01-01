import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_app/common/utils/utils.dart';
import 'package:whats_app/const/colors.dart';
import 'package:whats_app/features/auth/controller/auth_controller.dart';

class OtpScreen extends ConsumerWidget {
  final String identificationId;
  const OtpScreen({super.key, required this.identificationId});
  final hintText = '- - - - - -';
  void verifyOtp(WidgetRef ref, BuildContext context, String UserOtp) {
    ref
        .watch(authControllerProvider)
        .verifyOtp(context, identificationId, UserOtp);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: const Icon(
          Icons.arrow_back,
          color: title,
        ),
        title: const Text(
          'Verifying Your Number',
          style: TextStyle(color: title),
          textAlign: TextAlign.center,
        ),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            const Text(
              'We have Sent SMS with Code',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: title,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: size.width * 0.5,
              child: TextField(
                textAlign: TextAlign.center,
                onChanged: (val) {
                  if (val.length == 6) {
                    verifyOtp(ref, context, val.trim());
                  } else {
                    ShowSnackBar(context: context, content: 'Enter Full Otp');
                  }
                },
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: AutofillHints.oneTimeCode,
                  hintText: hintText,
                  hintStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
