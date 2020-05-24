import 'package:flutter/material.dart';
import 'package:recipe_box/app/detail/recipe_detail_page.dart';
import 'package:recipe_box/services/elastic_search/search_recipe_service.dart';
import 'package:recipe_box/services/firestore/plan_recipe_service.dart';
import 'package:recipe_box/services/firestore/plan_service.dart';
import 'package:recipe_box/utilities/styles.dart';
import 'package:provider/provider.dart';

class PlanReceipeTile extends StatelessWidget {
  final String id;
  final String recipeID;
  final String title;
  final String description;
  final List<String> imgAssetPath;
  PlanReceipeTile(
      {@required this.imgAssetPath,
      @required this.id,
      @required this.recipeID,
      @required this.title,
      @required this.description});

  void gotoDetailPage(SearchRecipeService service, PlanService planService,
      PlanRecipeService planRecipeService, BuildContext context) async {
    var detail = await service.getRecipeDetail(
        recipeID, planService.uid, planService.current.id);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => RecipeDetail(
                  recipeDetail: detail,
                  planID: planService.current.id,
                  planRecipeService: planRecipeService,
                )));
  }

  @override
  Widget build(BuildContext context) {
    final planRecipeService =
        Provider.of<PlanRecipeService>(context, listen: false);
    final planService = Provider.of<PlanService>(context, listen: false);

    final searchRecipeService =
        Provider.of<SearchRecipeService>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        decoration: BoxDecoration(
            color: sColorBody4, borderRadius: BorderRadius.circular(20)),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Row(
          children: <Widget>[
            GestureDetector(
              onTap: () async {
                gotoDetailPage(searchRecipeService, planService,
                    planRecipeService, context);
              },
              child: Container(
                child: imgAssetPath.length > 0
                    ? Image.network(
                        imgAssetPath[0],
                        fit: BoxFit.fitHeight,
                        height: 40.0,
                        width: 40.0,
                      )
                    : Text('WAIT FOR IMAGE'),
              ),
            ),
            SizedBox(
              width: 17,
            ),
            GestureDetector(
              onTap: () async {
                gotoDetailPage(searchRecipeService, planService,
                    planRecipeService, context);
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 180.0,
                    child: Text(title,
                        style: TextStyle(color: sColorText1, fontSize: 19),
                        overflow: TextOverflow.ellipsis),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Container(
                    width: 170.0,
                    child: Text(
                      description,
                      style: TextStyle(fontSize: 11),
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                ],
              ),
            ),
            Spacer(),
            Container(
              child: IconButton(
                icon: Icon(Icons.remove_circle),
                color: Colors.redAccent,
                onPressed: () {
                  print('try to delete');
                  planRecipeService.removeRecipe(
                      planService.current.id, this.id, this.recipeID);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
