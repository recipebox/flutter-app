import 'package:flutter/material.dart';
import 'package:recipe_box/services/firestore/detail_recipe_service.dart';
import 'package:recipe_box/services/firestore/plan_recipe_service.dart';
import 'package:recipe_box/services/firestore/plan_service.dart';
import 'package:recipe_box/services/navigation_bar_service.dart';
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

  @override
  Widget build(BuildContext context) {
    final planRecipeService =
        Provider.of<PlanRecipeService>(context, listen: false);
    final planService = Provider.of<PlanService>(context, listen: false);
    final navigatorBar = Provider.of<BottomNavigationBarService>(context);
    final detailService = Provider.of<DetailRecipeService>(context);

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
                var detail = await planRecipeService.getRecipeDetail(
                    recipeID, planService.uid, planService.current.id);
                detailService.currentDetail = detail;
                detailService.recipeID = recipeID;
                detailService.planID = planService.current.id;
                navigatorBar.showDetail = true;
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
                var detail = await planRecipeService.getRecipeDetail(
                    recipeID, planService.uid, planService.current.id);
                detailService.currentDetail = detail;
                detailService.recipeID = recipeID;
                detailService.planID = planService.current.id;
                navigatorBar.showDetail = true;
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
                      planService.current.id, this.recipeID);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
