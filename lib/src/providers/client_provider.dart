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
}
