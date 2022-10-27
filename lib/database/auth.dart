import 'package:cloud_firestore/cloud_firestore.dart';

Future userSetup(String _custEmail, String _custFirstName, String _custLastName,
    String _custId, String password) async {
  await FirebaseFirestore.instance.collection('customer').add({
    'custemail': _custEmail,
    'custfirstname': _custFirstName,
    'custlastname': _custLastName,
    'custid': _custId,
    'password': password,
  });
}
