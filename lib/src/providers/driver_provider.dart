import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uber_clone/src/models/driver.dart';

class DriverProvider {
  late CollectionReference _ref;

  Stream<DocumentSnapshot> getByIdStream(String id) {
    return _ref.doc(id).snapshots(includeMetadataChanges: true);
  }

  DriverProvider() {
    _ref = FirebaseFirestore.instance.collection('Drivers');
  }

  Future<void> create(Driver driver) async {
    try {
      await _ref.doc(driver.id).set(driver.toJson());
    } on FirebaseException catch (error) {
      return Future.error(error.code);
    }
  }

  Future<Driver?> getById(String id) async {
    DocumentSnapshot document = await _ref.doc(id).get();
    if (document.exists) {
      Driver driver = driverFromJson(json.encode(document.data()));
      return driver;
    }
    return null;
  }
}
