import 'package:flutter/material.dart';
import 'package:recipe_box/models/recipe_detail_model.dart';

class DetailRecipeService with ChangeNotifier {
  DetailRecipeService(
      {@required this.uid,
      @required this.planID,
      this.recipeID,
      this.currentDetail})
      : assert(uid != null),
        assert(planID != null) {}
  final String uid;
  String planID;
  String recipeID;
  RecipeDetailModel currentDetail;

  Future<void> updateCurrentDetail(String status) {
    currentDetail.status = status;
    notifyListeners();
    return null;
  }

  Future<void> setCurrentDetail(String recipeID, RecipeDetailModel detail) {
    this.recipeID = recipeID;
    this.currentDetail = detail;
    notifyListeners();
    return null;
  }
}
