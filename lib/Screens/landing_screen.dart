import 'package:flutter/material.dart';
import 'package:whats_app/const/colors.dart';
import 'package:whats_app/features/auth/screens/login_screen.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: size.height / 9,
              ),
              const Text(
                'Welcome To What\'s App',
                style: TextStyle(
                    fontSize: 29, fontWeight: FontWeight.w500, color: title),
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.contain,
                      image: NetworkImage(
                          "https://encrypted-tbn2.gstatic.com/images?q=tbn:ANd9GcQm_rsl3j6YhTe8EdiYaq6EiqF4K9I2CtQj9w0TUlEBjXDGiMu1"),
                    ),
                  ),
                ),
              ),
              const Text(
                'Read Our Privacy & Policy . Tap Agree & Continue to accept the Terms of Service',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white54,
                ),
              ),
              SizedBox(
                height: size.height / 9,
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.green[400],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  width: double.infinity,
                  child: const Center(
                    child: Text(
                      'AGREE & CONTINUE',
                      style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.w400,
                          color: title),
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
