import 'package:flutter/material.dart';

abstract class AppCategoryColors {
  static const Color subscription = Color(0xFF7C5CBF); // softer indigo-violet
  static const Color groceries    = Color(0xFFD4860A); // warm amber
  static const Color transport    = Color(0xFF2E82AE); // slate teal
  static const Color shopping     = Color(0xFFC2697B); // rose-mauve

  static Color forCategory(String category) {
    switch (category) {
      case 'subscription': return subscription;
      case 'groceries':    return groceries;
      case 'transport':    return transport;
      case 'shopping':     return shopping;
      default:             return const Color(0xFF757575);
    }
  }
}

abstract class AppStatusColors {
  static const Color completed = Color(0xFF2E7D55); // forest green
  static const Color pending   = Color(0xFFB8760A); // amber-ochre
  static const Color failed    = Color(0xFFB83232); // deep crimson (NOT AEON red)

  static Color forStatus(String status) {
    switch (status) {
      case 'completed': return completed;
      case 'pending':   return pending;
      case 'failed':    return failed;
      default:          return const Color(0xFF757575);
    }
  }
}
