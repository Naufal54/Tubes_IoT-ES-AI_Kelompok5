import 'package:flutter/material.dart';

// Notifier global untuk memicu update tampilan saat data user berubah
final ValueNotifier<int> userUpdateNotifier = ValueNotifier(0);

void notifyUserUpdates() {
  userUpdateNotifier.value++;
}