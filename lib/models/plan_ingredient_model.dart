import 'package:cloud_firestore/cloud_firestore.dart';

class PlanIngredient {
  final String id;
  final String title;
  final String description;
  final List<String> photos;
  final String status;
  final Map recipes;
  final List<String> amount;
  final List<String> recipeTitles;

  PlanIngredient(this.id, this.title, this.description, this.photos,
      this.status, this.recipes, this.amount, this.recipeTitles);

  static PlanIngredient fromSnapshot(DocumentSnapshot snap) {
    List photoJson = snap.data['photos'] ?? [""];
    final photoArray = photoJson.map((f) => f.toString()).toList();

    var recipes = {};
    List<String> amount = [];
    List<String> recipeTitles = [];
    List recipeIdJson = snap.data['recipeIDs'] ?? [];
    List recipeJson = snap.data['recipes'] ?? [];
    recipeJson.forEach((f) {
      Map x = f as Map;
      String key = x.keys.toList()[0];
      recipeIdJson.forEach((element) {
        if (element == key) {
          recipes[x[key]['title']] = x[key]['amount'];
          amount.add(x[key]['amount'].toString());
          recipeTitles.add(x[key]['title'].toString());
          //printT('done::::::' + recipes.toString());
        }
      });
    });

    return PlanIngredient(
      snap.documentID,
      snap.data['title'] ?? '-',
      snap.data['description'] ?? '-',
      photoArray ?? [],
      snap.data['status'] ?? 'PENDING',
      recipes,
      amount,
      recipeTitles,
    );
  }
}
