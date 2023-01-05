import 'package:flutter/cupertino.dart';
import 'package:freelance_maid_phase_1/Models/address.dart';

class AppData extends ChangeNotifier {
  Address? pickupLocation;

  void updatePickupLocationAddress(Address pickupAddress) {
    pickupLocation = pickupAddress;
    notifyListeners();
  }
}
