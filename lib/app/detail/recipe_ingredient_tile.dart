import 'package:flutter/material.dart';
import 'package:recipe_box/models/plan_ingredient_model.dart';
import 'package:recipe_box/models/recipe_detail_model.dart';
import 'package:recipe_box/services/firestore/plan_ingredient_service.dart';
import 'package:recipe_box/services/firestore/plan_service.dart';
import 'package:recipe_box/utilities/styles.dart';
import 'package:provider/provider.dart';

class RecipeIngredientTile extends StatelessWidget {
  final Ingredient ingredient;

  RecipeIngredientTile({@required this.ingredient});

  @override
  Widget build(BuildContext context) {
    final planIngredientService =
        Provider.of<PlanIngredientService>(context, listen: false);
    final planService = Provider.of<PlanService>(context, listen: false);

    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      padding: EdgeInsets.only(top: 5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Container(
                width: 60.0,
                decoration: BoxDecoration(
                  color: sColorBody4,
                  borderRadius: BorderRadius.circular(15.0),
                ),
                margin: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 5.0),
                      Text(ingredient.title,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 12.0, fontWeight: FontWeight.bold)),
                      Text(ingredient.amount,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 10.0)),
                      SizedBox(height: 5.0),
                    ],
                  ),
                ),
              ),
              StreamBuilder<List<PlanIngredient>>(
                  stream: planIngredientService
                      .streamIngredients(planService.current.id),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<PlanIngredient>> snapshot) {
                    if (!snapshot.hasData) return new Text('...');
                    var data = snapshot.data;
                    bool matched = false;
                    bool done = false;
                    data.forEach((element) {
                      if (element.title == ingredient.title) {
                        matched = true;
                        print(
                            'match for ${element.title}, status = ${element.status}');
                        if (element.status == 'DONE') {
                          done = true;
                        }
                      }
                    });
                    if (matched) {
                      return Positioned(
                        child: Icon(
                          Icons.shopping_basket,
                          color: done ? sColorBody5 : Colors.redAccent,
                        ),
                        bottom: 0,
                        right: 0,
                      );
                    } else {
                      return Text('');
                    }
                  }),
            ],
          ),
        ],
      ),
    );
  }
}
