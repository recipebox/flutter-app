import 'package:flutter/material.dart';
import 'package:recipe_box/models/plan_ingredient_model.dart';
import 'package:recipe_box/models/recipe_detail_model.dart';
import 'package:recipe_box/services/firestore/plan_ingredient_service.dart';
import 'package:recipe_box/services/firestore/plan_recipe_service.dart';
import 'package:recipe_box/services/firestore/plan_service.dart';
import 'package:recipe_box/utilities/styles.dart';
import 'package:provider/provider.dart';

class RecipeIngredientTile extends StatelessWidget {
  final Ingredient ingredient;
  final RecipeDetailModel recipeDetail;

  RecipeIngredientTile({@required this.ingredient, this.recipeDetail});

  @override
  Widget build(BuildContext context) {
    final planIngredientService =
        Provider.of<PlanIngredientService>(context, listen: false);
    final planService = Provider.of<PlanService>(context, listen: false);
    final planRecipeService =
        Provider.of<PlanRecipeService>(context, listen: false);

    return StreamBuilder<List<PlanIngredient>>(
        stream: planIngredientService.streamIngredients(planService.current.id),
        builder: (BuildContext context,
            AsyncSnapshot<List<PlanIngredient>> snapshot) {
          if (!snapshot.hasData) return new Text('...');
          var data = snapshot.data;
          bool matched = false;
          bool done = false;
          data.forEach((element) {
            if (element.title == ingredient.title) {
              matched = true;
              print('match for ${element.title}, status = ${element.status}');
              if (element.status == 'DONE') {
                done = true;
              }
            }
          });
          if (matched && done) {
            return _buildColumn(planRecipeService, ingredient, bcDone,
                planService.current.id, false, false, recipeDetail);
          } else if (matched) {
            return _buildColumn(planRecipeService, ingredient, bcNeeded,
                planService.current.id, true, false, recipeDetail);
          } else {
            return _buildColumn(planRecipeService, ingredient, bcEmpty,
                planService.current.id, false, true, recipeDetail);
          }
        });
  }
}

Widget _buildContent(Ingredient ingredient) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(15.0),
    child: Column(
      children: <Widget>[
        SizedBox(height: 5.0),
        Text(ingredient.title,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold)),
        Text(ingredient.amount,
            overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 10.0)),
        SizedBox(height: 5.0),
      ],
    ),
  );
}

final bcEmpty = BoxDecoration(
  color: sColorBody4,
  borderRadius: BorderRadius.circular(15.0),
);

final bcDone = BoxDecoration(
  color: sColorBody4,
  borderRadius: BorderRadius.circular(15.0),
  border: Border.all(
    color: Colors.greenAccent, //                   <--- border color
    width: 1.0,
  ),
);

final bcNeeded = BoxDecoration(
  color: sColorBody4,
  borderRadius: BorderRadius.circular(15.0),
  border: Border.all(
    color: Colors.red, //                   <--- border color
    width: 1.0,
  ),
);

Widget _buildColumn(
    PlanRecipeService planRecipeService,
    Ingredient ingredient,
    BoxDecoration bc,
    String planID,
    bool removable,
    bool addable,
    RecipeDetailModel recipeDetail) {
  return GestureDetector(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              width: 60.0,
              decoration: bc,
              margin: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
              child: _buildContent(ingredient),
            ),
          ],
        ),
      ],
    ),
    onTap: () {
      if (removable == true) {
        print('remove it');
        planRecipeService.removeIngredient(planID, ingredient.title);
      }
      if (addable == true) {
        print('add it');
        planRecipeService.addIngredient(planID, recipeDetail, ingredient.title);
      }
    },
  );
}
