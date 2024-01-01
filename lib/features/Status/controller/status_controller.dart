// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:whats_app/features/Status/repository/status_repository.dart';

final statusRepositoryControllerProvider = Provider(
  (ref) => StatusRepositoryController(
    statusRepository: ref.read(statusRepositoryProvider),
  ),
);

class StatusRepositoryController {
  final StatusRepository statusRepository;
  StatusRepositoryController({
    required this.statusRepository,
  });

  void uploadStatus(
    BuildContext context,
    File file,
    String statusMessage,
  ) {
    statusRepository.uploadStatus(
      context,
      file,
      statusMessage,
    );
  }
}
