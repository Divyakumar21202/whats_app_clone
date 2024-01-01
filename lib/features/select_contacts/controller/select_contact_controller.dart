import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_app/features/select_contacts/repository/select_contact_repository.dart';

final getContactProvider = FutureProvider((ref) {
  final selectContactRepository = ref.watch(selectContactRepositoryProvider);
  return selectContactRepository.getContact();
});

final selectContactControllerProvider = Provider(
  (ref) => SelectContactController(
    ref: ref,
    selectContactRepository: ref.watch(selectContactRepositoryProvider),
  ),
);

class SelectContactController {
  final SelectContactRepository selectContactRepository;
  final ProviderRef ref;
  SelectContactController(
      {required this.ref, required this.selectContactRepository});

  void selectContact(BuildContext context, Contact selectedNumber) {
    selectContactRepository.selectContact(selectedNumber, context);
  }
}
