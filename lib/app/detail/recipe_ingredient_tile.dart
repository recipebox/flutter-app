import 'package:flutter/material.dart';
import 'package:recipe_box/models/recipe_detail_model.dart';
import 'package:recipe_box/utilities/styles.dart';

class RecipeIngredientTile extends StatelessWidget {
  final Ingredient ingredient;

  RecipeIngredientTile({@required this.ingredient});

  @override
  Widget build(BuildContext context) {
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
            ],
          ),
        ],
      ),
    );
  }
}
