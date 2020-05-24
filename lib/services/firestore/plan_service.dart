import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:recipe_box/models/plan_model.dart';

class PlanService {
  PlanService({@required this.uid}) : assert(uid != null);
  final String uid;
  Plan current;

  Stream<Plan> planStream() {
    final ref = Firestore.instance
        .collection('profiles/$uid/plans')
        .where("active", isEqualTo: true)
        .orderBy("created_at", descending: true)
        .limit(1);

    final plan = ref.snapshots().map((snapshot) {
      return snapshot.documents
          .map((doc) {
            final plan = Plan.fromSnapshot(doc, uid);
            if (plan.active == true) {
              this.current = plan;
              return plan;
            }
            return null;
          })
          .toList()
          .first;
    });
    return plan;
  }

  Stream<List<Plan>> planListStream() {
    final planCollection = Firestore.instance
        .collection('profiles/$uid/plans')
        .orderBy("created_at", descending: true);

    return planCollection.snapshots().map((snapshot) {
      return snapshot.documents.map((doc) {
        return Plan.fromSnapshot(doc, uid);
      }).toList();
    }).asBroadcastStream();
  }

  Future<void> createPlan(String title) async {
    // Mark every plan else to active false
    var now = ((new DateTime.now()).millisecondsSinceEpoch / 1000).round();
    var plan = await Firestore.instance
        .collection('profiles')
        .document(uid)
        .collection('plans')
        .add({"active": true, "created_at": now, "title": title});
    print('done for create plan' + plan.documentID);
  }
}
