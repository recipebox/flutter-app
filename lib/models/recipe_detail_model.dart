import 'recipe_preview_model.dart';

class RecipeDetailModel extends RecipePreviewModel {
  final List<Ingredient> ingredients;
  final List<Instruction> instructions;
  RecipeDetailModel(
      String id,
      String title,
      String description,
      List<String> photos,
      List<String> ingredientIDs,
      String status,
      this.ingredients,
      this.instructions)
      : super(id, title, description, photos, ingredientIDs, status);

  factory RecipeDetailModel.fromSnapshot(String id, Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }
    List photoJson = data['photos'] ?? [];
    final photoArray = photoJson.map((f) => f.toString()).toList();

    List ingredientJson = data['ingredientIDs'] ?? [];
    final ingredientArray = ingredientJson.map((f) => f.toString()).toList();

    final String title = data['title'] ?? '';
    final String description = data['description'] ?? '';
    final List<String> photos = photoArray ?? [];
    final List<String> ingredientIDs = ingredientArray ?? [];
    final String status = data['status'] ?? '';

    final List<Ingredient> ingredients = [];
    final List<Instruction> instructions = [];
    if (data['ingredients'] != null) {
      List ingredientJson = data['ingredients'];
      ingredientJson.forEach((e) {
        ingredients.add(new Ingredient(
            e['ingredientName'],
            "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSDsgw4IdTwfd6DVqNX31enKvTpwKKwU-7yvEf_ehbGXA0aC05b&usqp=CAU",
            e['amount'],
            e['seq']));
      });
    }

    if (data['instructions'] != null) {
      List instructionJson = data['instructions'];
      instructionJson.forEach((e) {
        instructions.add(new Instruction(
            e['seq'], e['detail'], e['tips'], null //e['photo']['smallUrl'],
            ));
      });
    }

    return RecipeDetailModel(id, title, description, photos, ingredientIDs,
        status, ingredients, instructions);
  }
}

class Ingredient {
  final String title;
  final String photo;
  final String amount;
  final int seq;
  Ingredient(this.title, this.photo, this.amount, this.seq);
}

class Instruction {
  final int seq;
  final String detail;
  final String tip;
  final String photo;
  Instruction(this.seq, this.detail, this.tip, this.photo);
}
