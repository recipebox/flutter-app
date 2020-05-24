import 'package:flutter/material.dart';
import 'package:recipe_box/services/firestore/plan_ingredient_service.dart';
import 'package:recipe_box/services/firestore/plan_service.dart';
import 'package:recipe_box/utilities/styles.dart';
import 'package:provider/provider.dart';

class PlanIngredientTile extends StatelessWidget {
  final String id;
  final String recipeID;
  final String title;
  final String status;
  final List<String> amount;
  PlanIngredientTile(
      {@required this.id,
      @required this.recipeID,
      @required this.title,
      @required this.status,
      @required this.amount});

  String amountString(List<String> amount) {
    var result = amount.fold("", (previousValue, element) {
      if (previousValue == "") {
        return element;
      }
      return previousValue + ", " + element;
    });
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final planIngredientService =
        Provider.of<PlanIngredientService>(context, listen: false);
    final planService = Provider.of<PlanService>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Container(
        decoration: BoxDecoration(
            color: sColorBody4, borderRadius: BorderRadius.circular(15)),
        // padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Row(
          children: <Widget>[
            SizedBox(
              width: 17,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 170.0,
                  child: Text(title,
                      style: TextStyle(color: sColorText1, fontSize: 14),
                      overflow: TextOverflow.ellipsis),
                ),
                SizedBox(
                  height: 2,
                ),
                Container(
                  width: 170.0,
                  child: Text(
                    amountString(amount),
                    style: TextStyle(fontSize: 11),
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              ],
            ),
            Spacer(),
            Container(
              child: status == 'ADDED'
                  ? IconButton(
                      icon: Icon(Icons.check_box),
                      color: Colors.green[400],
                      onPressed: () {
                        print('remove!');
                        planIngredientService.updateIngredientStatus(
                            planService.uid,
                            planService.current.id,
                            id,
                            "PENDING");
                      },
                    )
                  : IconButton(
                      icon: Icon(Icons.check_box),
                      color: Colors.grey,
                      onPressed: () {
                        planIngredientService.updateIngredientStatus(
                            planService.uid,
                            planService.current.id,
                            id,
                            "ADDED");
                      },
                    ),
            )
          ],
        ),
      ),
    );
  }
}
