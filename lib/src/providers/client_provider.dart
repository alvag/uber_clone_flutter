import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uber_clone/src/models/client.dart';

class ClientProvider {
  late CollectionReference _ref;

  ClientProvider() {
    _ref = FirebaseFirestore.instance.collection('Clients');
  }

  Future<void> create(Client client) async {
    try {
      await _ref.doc(client.id).set(client.toJson());
    } on FirebaseException catch (error) {
      return Future.error(error.code);
    }
  }

  Future<Client?> getById(String id) async {
    DocumentSnapshot document = await _ref.doc(id).get();
    if (document.exists) {
      Client client = clientFromJson(json.encode(document.data()));
      return client;
    }
    return null;
  }
}
