import 'package:flutter/material.dart';
import 'package:recipe_box/app/plan/widget_ingredient_list_tile.dart';
import 'package:recipe_box/models/plan_ingredient_model.dart';
import 'package:recipe_box/services/firestore/plan_ingredient_service.dart';
import 'package:recipe_box/services/firestore/plan_service.dart';
import 'package:provider/provider.dart';

class PlanIngredientPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final planIngredientService =
        Provider.of<PlanIngredientService>(context, listen: false);
    final planService = Provider.of<PlanService>(context, listen: false);
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          _buildListedTitle(),
          _buildListedIngredient(planIngredientService, planService),
        ],
      ),
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
              padding: const EdgeInsets.only(top: 20.0, bottom: 15.0),
              child: Text(
                "Shopping List",
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

  Widget _buildListedIngredient(
      PlanIngredientService service, PlanService planService) {
    return Column(
      children: <Widget>[
        StreamBuilder<List<PlanIngredient>>(
          stream: service.streamIngredients(planService.current.id),
          builder: (BuildContext context,
              AsyncSnapshot<List<PlanIngredient>> snapshot) {
            if (snapshot.hasError)
              return new Text('Error......: ${snapshot.error}');
            if (!snapshot.hasData) return new Text('Loading....');

            return new ListView(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              scrollDirection: Axis.vertical,
              children: snapshot.data.map((PlanIngredient doc) {
                return PlanIngredientTile(
                  id: doc.id,
                  title: doc.title,
                  status: doc.status,
                  amount: doc.amount,
                  recipeID: null,
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }
}
