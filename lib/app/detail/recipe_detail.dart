import 'package:flutter/material.dart';
import 'package:recipe_box/app/detail/recipe_ingredient_tile.dart';
import 'package:recipe_box/models/recipe_detail_model.dart';
import 'package:recipe_box/services/firestore/detail_recipe_service.dart';
import 'package:recipe_box/services/firestore/plan_recipe_service.dart';
import 'package:recipe_box/services/navigation_bar_service.dart';
import 'package:provider/provider.dart';
import 'package:recipe_box/utilities/log.dart';
import 'package:recipe_box/utilities/styles.dart';

class RecipeDetailNewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final navigatorBar = Provider.of<BottomNavigationBarService>(context);
    final planRecipeService =
        Provider.of<PlanRecipeService>(context, listen: false);
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Consumer<DetailRecipeService>(
        builder: (context, ds, child) {
          var recipeDetail = ds.currentDetail;
          return Scaffold(
            backgroundColor: sColorBody3,
            floatingActionButton: Padding(
              padding: const EdgeInsets.only(top: 80.0, left: 0.0),
              child: FloatingActionButton(
                  backgroundColor: Colors.brown,
                  mini: true,
                  onPressed: () {
                    navigatorBar.showDetail = false;
                  },
                  child: Icon(
                    Icons.arrow_back_ios,
                    size: 20.0,
                  )),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.miniStartTop,
            body: Container(
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Container(
                          height: 300.0,
                          alignment: Alignment(0.0, 0.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20.0),
                            child: Image.network(
                              recipeDetail.photos[0],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0.0,
                          right: 30.0,
                          child: recipeDetail.status != ''
                              ? RawMaterialButton(
                                  shape: CircleBorder(),
                                  elevation: 0.1,
                                  // fillColor: Colors.green,
                                  child: Icon(
                                    Icons.bookmark,
                                    color: Colors.green,
                                    size: 40.0,
                                  ),
                                  onPressed: () async {
                                    printT('remove recipe');
                                    await planRecipeService.removeRecipe(
                                        ds.planID, ds.recipeID);
                                    ds.updateCurrentDetail('');
                                  })
                              : RawMaterialButton(
                                  shape: CircleBorder(),
                                  elevation: 0.1,
                                  child: Icon(
                                    Icons.bookmark_border,
                                    color: Colors.black54,
                                    size: 40.0,
                                  ),
                                  onPressed: () async {
                                    printT('add recipe');
                                    await planRecipeService.addRecipe(
                                        ds.planID, recipeDetail);
                                    ds.updateCurrentDetail('ADDED');
                                  },
                                ),
                        )
                      ],
                    ),
                    // SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width - 60,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                recipeDetail.title,
                                style: TextStyle(
                                  color: sColorTextTitle1,
                                  fontSize: 25.0,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                recipeDetail.description,
                                style: TextStyle(
                                  color: sColorTextDesc1,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w400,
                                ),
                                overflow: TextOverflow.clip,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.0),
                    _buildTitle('Ingredients'),
                    SizedBox(height: 15.0),
                    _buildIngredientPanel(
                      context,
                      recipeDetail,
                      ds.planID,
                      planRecipeService,
                    ),
                    SizedBox(height: 15.0),
                    _buildTitle('Instructions'),
                    SizedBox(height: 15.0),
                    _buildInstructionPanel(context, recipeDetail),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTitle(String title) {
    return Row(
      children: <Widget>[
        Text(title,
            style: TextStyle(
              color: sColorTextTitle1,
              fontSize: 22.0,
              fontWeight: FontWeight.bold,
            ))
      ],
    );
  }

  Widget _buildIngredientPanel(
      BuildContext context,
      RecipeDetailModel recipeDetail,
      String planID,
      PlanRecipeService planRecipeService) {
    return Row(
      children: <Widget>[
        Container(
          height: 60.0,
          width: MediaQuery.of(context).size.width - 60,
          child: ListView.builder(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: recipeDetail.ingredients.length,
            itemBuilder: (context, index) {
              return RecipeIngredientTile(
                recipeDetail: recipeDetail,
                ingredient: recipeDetail.ingredients[index],
              );
            },
          ),
        )
      ],
    );
  }

  Widget _buildInstructionPanel(
      BuildContext context, RecipeDetailModel recipeDetail) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      scrollDirection: Axis.vertical,
      itemCount: recipeDetail.instructions.length,
      itemBuilder: (context, index) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              recipeDetail.instructions[index].seq.toString() + '. ',
              style: TextStyle(
                color: sColorTextDetail1,
                fontSize: 15.0,
                fontWeight: FontWeight.w900,
              ),
              overflow: TextOverflow.clip,
            ),
            Container(
              width: MediaQuery.of(context).size.width - 100,
              child: Text(
                recipeDetail.instructions[index].detail ?? '',
                style: TextStyle(
                  color: sColorTextDesc1,
                  fontSize: 15.0,
                  fontWeight: FontWeight.w400,
                ),
                overflow: TextOverflow.clip,
              ),
            ),
          ],
        );
      },
    );
  }
}
