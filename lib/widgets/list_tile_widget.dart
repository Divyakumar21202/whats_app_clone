import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:whats_app/const/colors.dart';

class MyListTileChat extends StatelessWidget {
  final String name;
  final String message;
  final String image;
  final DateTime time;
  const MyListTileChat(
      {super.key,
      required this.name,
      required this.message,
      required this.image,
      required this.time});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 30,
        backgroundImage: NetworkImage(image),
      ),
      title: Text(
        name,
        style: const TextStyle(
            fontSize: 18, fontWeight: FontWeight.w400, color: title),
      ),
      subtitle: Text(
        message,
        style: const TextStyle(color: subtitle),
      ),
      trailing: Text(
        DateFormat.Hm().format(time),
        style: TextStyle(color: Colors.amber[400], fontSize: 13),
      ),
    );
  }
}
