import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_app/Screens/error_screen.dart';
import 'package:whats_app/common/widgets/loader.dart';
import 'package:whats_app/features/select_contacts/controller/select_contact_controller.dart';

class ContactScreen extends ConsumerWidget {
  const ContactScreen({super.key});
  void SelectContact(
      BuildContext context, Contact SelectedNumber, WidgetRef ref) {
    ref
        .read(selectContactControllerProvider)
        .selectContact(context, SelectedNumber);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Contact'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: ref.watch(getContactProvider).when(
            data: (contact) {
              int itemCount = contact.length;
              return ListView.builder(
                itemCount: itemCount,
                itemBuilder: ((context, index) {
                  return InkWell(
                    onTap: () => SelectContact(context, contact[index], ref),
                    child: ListTile(
                      title: Text(contact[index].displayName),
                      leading: contact[index].photo == null
                          ? null
                          : CircleAvatar(
                              backgroundImage:
                                  MemoryImage(contact[index].photo!),
                              radius: 30,
                            ),
                    ),
                  );
                }),
              );
            },
            error: ((error, stackTrace) {
              return const ErrorScreen();
            }),
            loading: () => const Loader(),
          ),
    );
  }
}
