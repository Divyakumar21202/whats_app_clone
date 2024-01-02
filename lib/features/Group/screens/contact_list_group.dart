import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_app/Screens/error_screen.dart';
import 'package:whats_app/common/widgets/loader.dart';
import 'package:whats_app/features/select_contacts/controller/select_contact_controller.dart';
import 'package:whats_app/features/select_contacts/repository/select_contact_repository.dart';

class ContactScreenGroup extends ConsumerWidget {
  const ContactScreenGroup({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(getContactProvider).when(
          data: (data) {
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                Contact contact = data[index];
               return Text(
                  contact.displayName,
                );
              },
            );
          },
          error: (error, st) => const ErrorScreen(),
          loading: () => const Loader(),
        );
  }
}
