import 'package:recipe_box/app/home/new_drawer.dart';
import 'package:recipe_box/app/plan/plan_page.dart';
import 'package:recipe_box/models/plan_model.dart';
import 'package:recipe_box/services/elastic_search/search_recipe_service.dart';
import 'package:recipe_box/services/firestore/plan_ingredient_service.dart';
import 'package:recipe_box/services/firestore/plan_recipe_service.dart';
import 'package:recipe_box/services/firestore/plan_service.dart';
import 'package:recipe_box/services/navigation_bar_service.dart';
import 'package:flutter/material.dart';
import 'package:recipe_box/utilities/styles.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: NewDrawer(),
      backgroundColor: sColorBody3,
      body: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 60.0, left: 20.0),
                child: GestureDetector(
                  child: Container(
                    child: Icon(
                      Icons.menu,
                      color: Colors.black,
                    ),
                  ),
                  onTap: () => _scaffoldKey.currentState.openDrawer(),
                ),
              ),
            ],
          ),
          //_buildPlanList(context: context),
          _buildPlan(context: context),
        ],
      ),
    );
  }
}

// Widget _buildPlanList({BuildContext context}) {
//   final planService = Provider.of<PlanService>(context, listen: false);
//   return StreamBuilder<List<Plan>>(
//     stream: planService.planListStream(),
//     builder: (BuildContext context, AsyncSnapshot<List<Plan>> plan) {
//       if (plan.hasError) return new Text('Error......: ${plan.error}');
//       if (!plan.hasData) return new Text('Loading....');
//       return new ListView(
//         shrinkWrap: true,
//         children: plan.data.map((Plan doc) {
//           return new ListTile(
//             title: new Text(doc.title),
//             subtitle: new Text(doc.description),
//           );
//         }).toList(),
//       );
//     },
//   );
// }

Widget _buildPlan({BuildContext context}) {
  final planService = Provider.of<PlanService>(context, listen: false);
  return StreamBuilder<Plan>(
    stream: planService.planStream(),
    builder: (BuildContext context, AsyncSnapshot<Plan> plan) {
      if (plan.hasError) return new Text('Error.....: ${plan.error}');
      if (!plan.hasData) return new Text('Loading....');
      print('..rebuild plan!');

      return Expanded(
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider<SearchRecipeService>(
                create: (_) => new SearchRecipeService(null)),
            Provider<PlanIngredientService>(
                create: (BuildContext context) =>
                    PlanIngredientService(uid: plan.data.uid)),
            Provider<PlanRecipeService>(
                create: (_) => PlanRecipeService(uid: plan.data.uid)),
            ChangeNotifierProvider<BottomNavigationBarService>(
                create: (BuildContext context) => BottomNavigationBarService()),
          ],
          child: PlanHomePage(
            plan: plan.data,
          ),
        ),
      );
    },
  );
}
