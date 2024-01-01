import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_app/common/utils/utils.dart';
import 'package:whats_app/const/colors.dart';
import 'package:whats_app/features/auth/controller/auth_controller.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});
  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final phoneCotroller = TextEditingController();
  Country? country;
  @override
  void dispose() {
    super.dispose();
    phoneCotroller.dispose();
  }

  void SelectCountry() {
    showCountryPicker(
        context: context,
        onSelect: (Country _country) {
          setState(() {
            country = _country;
          });
        });
  }

  void sendPhoneNumber() {
    String phoneNumber = phoneCotroller.text.trim();
    if (country != null && phoneNumber.isNotEmpty) {
      ref
          .read(authControllerProvider)
          .signInWithPhone(context, ('+${country!.phoneCode}$phoneNumber'));
    } else {
      ShowSnackBar(context: context, content: 'Fill out all the detail');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(
                height: size.height / 10,
              ),
              const Text(
                'Verify Mobile Number.',
                style: TextStyle(color: title),
              ),
              const SizedBox(
                height: 40,
              ),
              InkWell(
                onTap: () {
                  SelectCountry();
                },
                child: Text(
                  'Pick country',
                  style: TextStyle(
                    color: Colors.blue[900],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Row(
                  children: [
                    if (country != null)
                      Text(
                        '+${country!.phoneCode}',
                        style: const TextStyle(
                            color: title,
                            fontWeight: FontWeight.w500,
                            fontSize: 21),
                      ),
                    const SizedBox(
                      width: 20,
                    ),
                    SizedBox(
                      width: size.width * 0.7,
                      child: TextField(
                        style: const TextStyle(color: Colors.white),
                        keyboardType: TextInputType.phone,
                        controller: phoneCotroller,
                        decoration: const InputDecoration(
                          hintText: 'Phone Number',
                          hintStyle: TextStyle(
                            color: title,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(child: Container()),
              ElevatedButton(
                onPressed: sendPhoneNumber,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[400],
                ),
                child: const Text('NEXT'),
              ),
              SizedBox(
                height: size.height / 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
