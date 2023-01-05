import 'package:freelance_maid_phase_1/DataHandler/appData.dart';
import 'package:freelance_maid_phase_1/Models/address.dart';
import 'package:freelance_maid_phase_1/geolocation/requestAssistant.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class AsistantsMethods {
  static Future<String> searchCoordinateAddress(
      Position position, context) async {
    String placeAddress = "";
    String st1, st2, st3, st4;
    String url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=AIzaSyAeTdgjlC47FKjicCxlBU10CIogCR3HrBA";

    var response = await RequestAssistant.getRequest(url);

    if (response != "failed") {
      st1 = response["results"][0]["formatted_address"][3]["long_name"];
      st2 = response["results"][0]["formatted_address"][4]["long_name"];
      st3 = response["results"][0]["formatted_address"][5]["long_name"];
      st4 = response["results"][0]["formatted_address"][6]["long_name"];
      placeAddress = st1 + ", " + st2 + ", " + st3 + ", " + st4;

      Address userPickupAddress = new Address(
          placeFormattedAddress: '',
          placeName: '',
          placeId: '',
          latitude: 0,
          longitude: 0);
      userPickupAddress.longitude = position.longitude;
      userPickupAddress.latitude = position.latitude;
      userPickupAddress.placeName = placeAddress;

      Provider.of<AppData>(context, listen: false)
          .updatePickupLocationAddress(userPickupAddress);
    }

    return placeAddress;
  }
}
