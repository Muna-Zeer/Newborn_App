import 'package:flutter/material.dart';

class NewbornProvider extends ChangeNotifier {
   String? _identityNumber;

  String? get identityNumber => _identityNumber;

  void setIdentityNumber(String identity) {
     print("Setting identity number: $identity"); 
    _identityNumber = identity;
    notifyListeners(); // Ensure UI updates
  }
}
