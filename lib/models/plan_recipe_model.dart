import 'package:cloud_firestore/cloud_firestore.dart';

class PlanRecipe {
  final String id;
  final String recipeID;
  final String title;
  final String description;
  final List<String> photos;
  final String status;

  PlanRecipe(this.id, this.recipeID, this.title, this.description, this.photos,
      this.status);

  static PlanRecipe fromSnapshot(DocumentSnapshot snap) {
    List photoJson = snap.data['photos'];
    final photoArray = photoJson.map((f) => f.toString()).toList();
    return PlanRecipe(
      snap.documentID,
      snap.data['id'],
      snap.data['title'],
      snap.data['description'],
      photoArray ?? [],
      snap.data['status'] ?? '',
    );
  }
}
