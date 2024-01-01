import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_app/Screens/error_screen.dart';
import 'package:whats_app/Screens/home_screen.dart';
import 'package:whats_app/Screens/landing_screen.dart';
import 'package:whats_app/common/widgets/loader.dart';
import 'package:whats_app/features/auth/controller/auth_controller.dart';
import 'package:whats_app/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: ref.watch(userDataprovider).when(
            data: (user) {
              if (user == null) {
                return const LandingScreen();
              }
              return const HomeScreen();
            },
            error: (e, str) {
              debugPrint("this is the Error : ${e.toString()}");
              debugPrint(str.toString());
              return const ErrorScreen();
            },
            loading: () => const Loader(),
          ),
    );
  }
}
