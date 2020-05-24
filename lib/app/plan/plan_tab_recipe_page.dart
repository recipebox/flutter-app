import 'package:flutter/material.dart';
import 'package:recipe_box/app/plan/widget_plan_list_tile.dart';
import 'package:recipe_box/app/plan/widget_plan_search_tile.dart';
import 'package:recipe_box/models/plan_recipe_model.dart';
import 'package:recipe_box/services/elastic_search/search_recipe_service.dart';
import 'package:recipe_box/services/firestore/plan_recipe_service.dart';
import 'package:recipe_box/services/firestore/plan_service.dart';
import 'package:recipe_box/utilities/styles.dart';
import 'package:provider/provider.dart';

class PlanRecipePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final planRecipeService =
        Provider.of<PlanRecipeService>(context, listen: false);
    final planService = Provider.of<PlanService>(context, listen: false);
    final searchRecipeService =
        Provider.of<SearchRecipeService>(context, listen: false);
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          _buildSearchBar(searchRecipeService),
          _buildSearchResult(searchRecipeService),
          _buildListedTitle(),
          _buildListedRecipe(planRecipeService, planService),
        ],
      ),
    );
  }

  Widget _buildSearchBar(SearchRecipeService service) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24),
      height: 50,
      decoration: BoxDecoration(
          color: sColorBody4, borderRadius: BorderRadius.circular(14)),
      child: Row(
        children: <Widget>[
          Icon(Icons.search),
          SizedBox(
            width: 10,
          ),
          Container(
            height: 50.0,
            width: 220.0,
            child: TextField(
              onSubmitted: (value) {
                service.searchElastic(value);
              },
              style: TextStyle(
                color: Colors.black45,
                fontFamily: 'OpenSans',
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Search your ingredient',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResult(SearchRecipeService service) {
    return Consumer<SearchRecipeService>(
      builder: (context, service, child) {
        var result = service.recipePreviewResult;
        return Container(
          height: result.length == 0 ? 0.0 : 220.0,
          child: ListView.builder(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: service.recipePreviewResult.length,
            itemBuilder: (context, index) {
              return PlanSearchTile(
                recipe: result[index],
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildListedTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: Text(
                "Queue",
                style: TextStyle(
                    color: Colors.black54.withOpacity(0.8),
                    fontSize: 20,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildListedRecipe(
      PlanRecipeService service, PlanService planService) {
    return StreamBuilder<List<PlanRecipe>>(
      stream: service.streamRecipes(planService.current.id),
      builder:
          (BuildContext context, AsyncSnapshot<List<PlanRecipe>> snapshot) {
        if (snapshot.hasError)
          return new Text('Error......: ${snapshot.error}');
        if (!snapshot.hasData) return new Text('Loading....');

        return new ListView(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          scrollDirection: Axis.vertical,
          children: snapshot.data.map((PlanRecipe doc) {
            //change name here
            return PlanReceipeTile(
              id: doc.id,
              recipeID: doc.recipeID,
              title: doc.title,
              description: doc.description,
              imgAssetPath: doc.photos,
            );
          }).toList(),
        );
      },
    );
  }
}
