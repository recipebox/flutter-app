import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:recipe_box/models/plan_recipe_model.dart';
import 'package:recipe_box/models/recipe_detail_model.dart';
import 'package:recipe_box/models/recipe_preview_model.dart';
import 'package:recipe_box/utilities/log.dart';

class PlanRecipeService {
  PlanRecipeService({@required this.uid}) : assert(uid != null);
  final String uid;

  Stream<List<PlanRecipe>> streamRecipes(String planID) {
    final planCollection =
        Firestore.instance.collection('profiles/$uid/plans/$planID/recipes');

    return planCollection.snapshots().map((snapshot) {
      return snapshot.documents.map((doc) {
        return PlanRecipe.fromSnapshot(doc);
      }).toList();
    }).asBroadcastStream();
  }

  Future<void> addRecipe(String planID, RecipePreviewModel recipe) async {
    printT('Adding $planID, ${recipe.id}');
    var rawRecipe =
        Firestore.instance.collection('recipes').document(recipe.id);
    // List ingredientList = [];
    await rawRecipe.get().then((doc) {
      Firestore.instance
          .collection('profiles/$uid/plans/$planID/recipes')
          .document(recipe.id)
          .setData(doc.data);
      // ingredientList = doc.data['ingredients'] as List;
    }).catchError((onError) {
      printT(onError);
    });

    // ingredientList.forEach((ingredient) async {
    //   Map ingredientMap = ingredient as Map;
    //   var title = ingredientMap['ingredientName'];
    //   var amount = ingredientMap['amount'];

    //   var planIngredient = await Firestore.instance
    //       .collection('profiles/$uid/plans/$planID/ingredients')
    //       .document(title)
    //       .get();

    //   if (planIngredient.exists) {
    //     var recipeMap = {
    //       recipe.id: {"title": recipe.title, "amount": amount}
    //     };
    //     Firestore.instance
    //         .collection('profiles/$uid/plans/$planID/ingredients')
    //         .document(title)
    //         .updateData({
    //       "recipes": FieldValue.arrayUnion([recipeMap]),
    //       "recipeIDs": FieldValue.arrayUnion([recipe.id]),
    //     });
    //   } else {
    //     var raw = await Firestore.instance
    //         .collection('ingredients')
    //         .document(title)
    //         .get();
    //     var obj = raw.data;
    //     var recipeMap = {
    //       recipe.id: {"title": recipe.title, "amount": amount}
    //     };
    //     if (obj == null) {
    //       printE('Please add this ingredient to its collection: $title');
    //       return;
    //     }

    //     obj.addAll({
    //       "recipes": [recipeMap],
    //       "recipeIDs": [recipe.id],
    //     });
    //     Firestore.instance
    //         .collection('profiles/$uid/plans/$planID/ingredients')
    //         .document(title)
    //         .setData(obj);
    //   }
    // });
  }

  Future<void> removeRecipe(String planID, String recipeID) async {
    //print("UID: $uid, PlanID: $planID, planRecipeID:$planRecipeID");
    printT('Adding $planID, $recipeID');
    await Firestore.instance
        .collection('profiles/$uid/plans/$planID/recipes')
        .document(recipeID)
        .delete();
    var recipes = await Firestore.instance
        .collection('profiles/$uid/plans/$planID/ingredients')
        .where("recipeIDs", arrayContains: recipeID)
        .getDocuments();
    recipes.documents.forEach((element) {
      List recipes = element.data['recipeIDs'];
      if (recipes.length <= 1) {
        Firestore.instance
            .collection('profiles/$uid/plans/$planID/ingredients')
            .document(element.documentID)
            .delete();
      } else {
        Firestore.instance
            .collection('profiles/$uid/plans/$planID/ingredients')
            .document(element.documentID)
            .updateData({
          "recipeIDs": FieldValue.arrayRemove([recipeID])
        });
      }
    });
  }

  Future<RecipeDetailModel> getRecipeDetail(
      String recipeID, String uid, String planID) async {
    printT('getRecipeDetail with recipeID:$recipeID, uid:$uid, planID:$planID');
    final recipeDoc =
        await Firestore.instance.collection('recipes').document(recipeID).get();
    var detail =
        RecipeDetailModel.fromSnapshot(recipeDoc.documentID, recipeDoc.data);

    final planRecipe = await Firestore.instance
        .collection('profiles/$uid/plans/$planID/recipes')
        .where("id", isEqualTo: recipeID)
        .getDocuments();
    printT('result search in plan:' + planRecipe.documents.length.toString());
    if (planRecipe.documents.length == 0) {
      detail.status = "";
    } else {
      detail.status = planRecipe.documents[0]['status'] ?? 'ADDED';
    }
    printT('status for this detail' + detail.status);
    return detail;
  }

  Future<void> addIngredient(
      String planID, RecipePreviewModel recipe, String ingredientID) async {
    printT('addIngredient $planID, ${recipe.id}, $ingredientID');
    var rawRecipe =
        Firestore.instance.collection('recipes').document(recipe.id);
    List ingredientList = [];
    await rawRecipe.get().then((doc) {
      ingredientList = doc.data['ingredients'] as List;
    }).catchError((onError) {
      printT(onError);
    });

    ingredientList.forEach((ingredient) async {
      Map ingredientMap = ingredient as Map;
      var title = ingredientMap['ingredientName'];
      var amount = ingredientMap['amount'];

      if (title != ingredientID) {
        return;
      }

      var planIngredient = await Firestore.instance
          .collection('profiles/$uid/plans/$planID/ingredients')
          .document(title)
          .get();

      if (planIngredient.exists) {
        var recipeMap = {
          recipe.id: {"title": recipe.title, "amount": amount}
        };
        Firestore.instance
            .collection('profiles/$uid/plans/$planID/ingredients')
            .document(title)
            .updateData({
          "recipes": FieldValue.arrayUnion([recipeMap]),
          "recipeIDs": FieldValue.arrayUnion([recipe.id]),
        });
      } else {
        var raw = await Firestore.instance
            .collection('ingredients')
            .document(title)
            .get();
        var obj = raw.data;
        var recipeMap = {
          recipe.id: {"title": recipe.title, "amount": amount}
        };
        if (obj == null) {
          printE('Please add this ingredient to its collection: $title');
          return;
        }

        obj.addAll({
          "recipes": [recipeMap],
          "recipeIDs": [recipe.id],
          "status": "NEEDED"
        });
        Firestore.instance
            .collection('profiles/$uid/plans/$planID/ingredients')
            .document(title)
            .setData(obj);
      }
    });
  }
}
