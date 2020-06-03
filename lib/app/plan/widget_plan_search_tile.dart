import 'package:flutter/material.dart';
import 'package:recipe_box/models/recipe_preview_model.dart';
import 'package:recipe_box/services/firestore/detail_recipe_service.dart';
import 'package:recipe_box/services/firestore/plan_recipe_service.dart';
import 'package:recipe_box/services/firestore/plan_service.dart';
import 'package:provider/provider.dart';
import 'package:recipe_box/services/navigation_bar_service.dart';

class PlanSearchTile extends StatelessWidget {
  final RecipePreviewModel recipe;
  PlanSearchTile({@required this.recipe});

  @override
  Widget build(BuildContext context) {
    final planRecipeService =
        Provider.of<PlanRecipeService>(context, listen: false);
    final planService = Provider.of<PlanService>(context, listen: false);
    final navigatorBar = Provider.of<BottomNavigationBarService>(context);
    final detailService = Provider.of<DetailRecipeService>(context);

    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(24)),
      padding: EdgeInsets.only(top: 5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Stack(
            alignment: Alignment.center,
            children: <Widget>[
              GestureDetector(
                onTap: () async {
                  var detail = await planRecipeService.getRecipeDetail(
                      recipe.id, planService.uid, planService.current.id);
                  detailService.currentDetail = detail;
                  detailService.recipeID = recipe.id;
                  detailService.planID = planService.current.id;
                  navigatorBar.showDetail = true;
                },
                child: Container(
                  width: 160.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 30.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: Stack(
                      children: <Widget>[
                        Center(
                          child: recipe.photos.length > 0
                              ? Image.network(
                                  recipe.photos[0],
                                  fit: BoxFit.fitHeight,
                                  height: 160.0,
                                  width: 160.0,
                                )
                              : Text('WAIT FOR IMAGE'),
                        ),
                        Positioned(
                          left: 10.0,
                          bottom: 10.0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                recipe.title,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w600,
                                  shadows: <Shadow>[
                                    Shadow(
                                      offset: Offset(2.0, 2.0),
                                      blurRadius: 4.0,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 3.0,
                right: 0.0,
                child: RawMaterialButton(
                  // padding: EdgeInsets.only(right: 5.0),
                  shape: CircleBorder(),
                  elevation: 0.1,
                  fillColor: Colors.black,
                  child: Icon(
                    Icons.bookmark_border,
                    color: Colors.white,
                    size: 20.0,
                  ),
                  onPressed: () {
                    planRecipeService.addRecipe(planService.current.id, recipe);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
