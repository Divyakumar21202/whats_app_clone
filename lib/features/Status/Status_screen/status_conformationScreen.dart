import 'dart:io';

import 'package:flutter/material.dart';
import 'package:whats_app/const/colors.dart';

class StatusConformation extends StatefulWidget {
  final File file;
  const StatusConformation({
    super.key,
    required this.file,
  });

  @override
  State<StatusConformation> createState() => _StatusConformationState();
}

class _StatusConformationState extends State<StatusConformation> {
  late TextEditingController _controller;
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: AspectRatio(
          aspectRatio: 9 / 16,
          child: Image(
            image: FileImage(widget.file),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(
          left: 9,
          right: 9,
          bottom: 6,
        ),
        child: TextField(
          controller: _controller,
          keyboardType: TextInputType.text,
          style: const TextStyle(
            color: Colors.blue,
          ),
          decoration: InputDecoration(
            filled: true,
            focusColor: Colors.white,
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: 0,
                style: BorderStyle.none,
              ),
              borderRadius: BorderRadius.circular(
                12,
              ),
            ),
            suffixIcon: Icon(
              Icons.send_rounded,
              color: Colors.white10,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                12,
              ),
            ),
            hintText: 'Write Message',
            hintStyle: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
