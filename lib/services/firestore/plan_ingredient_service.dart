import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:recipe_box/models/plan_ingredient_model.dart';
import 'package:recipe_box/utilities/log.dart';

class PlanIngredientService {
  PlanIngredientService({@required this.uid}) : assert(uid != null);
  final String uid;

  Stream<List<PlanIngredient>> streamIngredients(String planID) {
    final planCollection = Firestore.instance
        .collection('profiles/$uid/plans/$planID/ingredients');

    return planCollection.snapshots().map((snapshot) {
      return snapshot.documents.map((doc) {
        return PlanIngredient.fromSnapshot(doc);
      }).toList();
    }).asBroadcastStream();
  }

  Future<void> updateIngredientStatus(
      String uid, planID, ingredientID, status) {
    printT(
        'updateIngredientStatus with uid:$uid, planID:$planID, ingredientID:$ingredientID ==> status:$status');
    return Firestore.instance
        .collection('profiles/$uid/plans/$planID/ingredients')
        .document(ingredientID)
        .updateData({
      "status": status,
    });
  }
}
