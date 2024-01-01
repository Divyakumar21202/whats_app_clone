import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_app/features/chats/screens/single_chat_screen.dart';
import 'package:whats_app/common/utils/utils.dart';
import 'package:whats_app/models/user_model.dart';

final selectContactRepositoryProvider = Provider(
  (ref) => SelectContactRepository(
    firestore: FirebaseFirestore.instance,
  ),
);

class SelectContactRepository {
  final FirebaseFirestore firestore;
  SelectContactRepository({
    required this.firestore,
  });

  Future<List<Contact>> getContact() async {
    List<Contact> contact = [];
    try {
      if (await FlutterContacts.requestPermission()) {
        contact = await FlutterContacts.getContacts(withProperties: true);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return contact;
  }

  void selectContact(Contact SelectedNumber, BuildContext context) async {
    try {
      var userCollection = await firestore.collection('users').get();
      bool isFound = false;
      for (var document in userCollection.docs) {
        var userData = UserModel.fromMap(document.data());
        String selectedPhoneNum =
            SelectedNumber.phones[0].number.replaceAll(' ', '');
        if (selectedPhoneNum == userData.phoneNumber) {
          isFound = true;
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => SingleChatScreen(
                name: userData.name,
                uid: userData.uid,
              ),
            ),
          );
        }
      }
      if (isFound == false) {
        ShowSnackBar(context: context, content: "User not Exist on this App");
      }
    } catch (e) {
      ShowSnackBar(context: context, content: e.toString());
    }
  }
}
