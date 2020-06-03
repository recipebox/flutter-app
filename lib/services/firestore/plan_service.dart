import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:recipe_box/models/plan_model.dart';
import 'package:recipe_box/utilities/log.dart';

class PlanService {
  PlanService({@required this.uid}) : assert(uid != null);
  final String uid;
  Plan current;

  Stream<Plan> planStream() {
    final plan = Firestore.instance
        .collection('profiles')
        .document(uid)
        .snapshots()
        .map((snapshot) async {
      if (snapshot.data == null || snapshot.data['active_plan'] == null) {
        printT('not ready : first time create plan');
        return null;
      }
      var activePlan = snapshot.data['active_plan'];
      await Firestore.instance
          .document('profiles/$uid/plans/$activePlan')
          .get()
          .then((doc) {
        this.current = Plan.fromSnapshot(doc, uid);
        return this.current;
      });
      return this.current;
    });
    return plan.asyncMap((a) {
      return a.then((value) => value);
    });
  }

  Stream<List<Plan>> planListStream() {
    final planCollection = Firestore.instance
        .collection('profiles/$uid/plans')
        .orderBy("created_at", descending: true);

    return planCollection.snapshots().map((snapshot) {
      // printT('planListStream...........>plan has updated');
      return snapshot.documents.map((doc) {
        return Plan.fromSnapshot(doc, uid);
      }).toList();
    }).asBroadcastStream();
  }

  Future<void> createPlan(String title) async {
    var now = ((new DateTime.now()).millisecondsSinceEpoch / 1000).round();
    var plan = await Firestore.instance
        .collection('profiles')
        .document(uid)
        .collection('plans')
        .add({"active": true, "created_at": now, "title": title});
    // print('done for create plan: ' + plan.documentID);
    await Firestore.instance
        .collection('profiles')
        .document(uid)
        .updateData({'active_plan': plan.documentID});
  }
}
