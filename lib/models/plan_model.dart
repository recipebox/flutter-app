import 'package:cloud_firestore/cloud_firestore.dart';

class Plan {
  final String id;
  final String uid;
  final String title;
  final int createdAt;
  final bool active;

  Plan(this.id, this.uid, this.title, this.createdAt, this.active);

  static Plan fromSnapshot(DocumentSnapshot snap, String uid) {
    return Plan(
      snap.documentID,
      uid,
      snap.data['title'],
      snap.data['created_at'] ?? '',
      snap.data['active'] ?? false,
    );
  }
}
