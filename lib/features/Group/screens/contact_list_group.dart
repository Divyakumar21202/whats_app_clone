import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_app/Screens/error_screen.dart';
import 'package:whats_app/common/widgets/loader.dart';
import 'package:whats_app/features/select_contacts/controller/select_contact_controller.dart';
import 'package:whats_app/features/select_contacts/repository/select_contact_repository.dart';

final contactGroupListProvider = StateProvider<List<Contact>>((ref) => []);

class ContactScreenGroup extends ConsumerStatefulWidget {
  const ContactScreenGroup({super.key});

  @override
  ConsumerState<ContactScreenGroup> createState() => _ContactScreenGroupState();
}

class _ContactScreenGroupState extends ConsumerState<ContactScreenGroup> {
  List<int> selectedContactIndexList = [];
  void onSelect(int index, Contact contact) {
    if (selectedContactIndexList.contains(index)) {
      selectedContactIndexList.remove(index);
    } else {
      selectedContactIndexList.add(index);
    }
    setState(() {
      ref
          .read(contactGroupListProvider.notifier)
          .update((state) => [...state,contact]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(getContactProvider).when(
          data: (data) {
            return Expanded(
              child: ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  Contact contact = data[index];
                  return ListTile(
                    leading: IconButton(
                      onPressed: () {
                        onSelect(index, contact);
                      },
                      color: Colors.white,
                      icon: Icon(
                        selectedContactIndexList.contains(index)
                            ? Icons.check_box_outlined
                            : Icons.check_box_outline_blank_rounded,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(
                      contact.displayName,
                    ),
                    titleTextStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                  );
                },
              ),
            );
          },
          error: (error, st) => const ErrorScreen(),
          loading: () => const Loader(),
        );
  }
}
