import 'dart:async';

import 'package:flutter/material.dart';

int count = 0;

main() {
  Timer.periodic(const Duration(seconds: 1), _callback);
}

void _callback(Timer timer) {
  count++;
  debugPrint("------${DateTime.now().toIso8601String()}---------");
  if (count >= 10) {
    timer.cancel();
  }
}
