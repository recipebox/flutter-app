import 'package:ff_navigation_bar/ff_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:recipe_box/app/detail/recipe_detail.dart';
import 'package:recipe_box/app/plan/plan_tab_ingredient_page.dart';
import 'package:recipe_box/app/plan/plan_tab_recipe_page.dart';
import 'package:recipe_box/models/plan_model.dart';
import 'package:recipe_box/services/firestore/detail_recipe_service.dart';
import 'package:recipe_box/services/navigation_bar_service.dart';
import 'package:recipe_box/utilities/styles.dart';
import 'package:provider/provider.dart';

class PlanHomePage extends StatelessWidget {
  PlanHomePage({Key key, this.plan}) : super(key: key);
  final Plan plan;

  @override
  Widget build(BuildContext context) {
    // Won't set listen to false since rebuild is needed
    final navigatorBar = Provider.of<BottomNavigationBarService>(context);

    return ChangeNotifierProvider<DetailRecipeService>(
      create: (BuildContext context) =>
          DetailRecipeService(planID: plan.id, uid: plan.uid),
      builder: (_, __) => Scaffold(
        backgroundColor: sColorBody3,
        body: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 0.0),
          child: navigatorBar.showDetail && navigatorBar.currentIndex == 0
              ? RecipeDetailNewPage()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Find Your next meal",
                              style: TextStyle(
                                  color: Colors.black54.withOpacity(0.8),
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              plan.title,
                              style: TextStyle(
                                  color: Colors.black26.withOpacity(0.8),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      ],
                    ),
                    navigatorBar.currentIndex == 1
                        ? Expanded(child: PlanIngredientPage())
                        : Text(''),
                    navigatorBar.currentIndex == 0
                        ? Expanded(child: PlanRecipePage())
                        : Text(''),
                  ],
                ),
        ),
        bottomNavigationBar: _buildBottomNavBar(navigatorBar),
      ),
    );
  }

  Widget _buildBottomNavBar(BottomNavigationBarService navigatorBar) {
    return FFNavigationBar(
      theme: FFNavigationBarTheme(
        barBackgroundColor: Colors.white,
        selectedItemBorderColor: Colors.transparent,
        selectedItemBackgroundColor: Colors.green,
        selectedItemIconColor: Colors.white,
        selectedItemLabelColor: Colors.black,
        showSelectedItemShadow: false,
        barHeight: 70,
      ),
      selectedIndex: navigatorBar.currentIndex,
      onSelectTab: (index) {
        navigatorBar.currentIndex = index;
      },
      items: [
        FFNavigationBarItem(
          iconData: Icons.book,
          label: 'Recipe',
        ),
        FFNavigationBarItem(
          iconData: Icons.shopping_cart,
          label: 'Cart',
          selectedBackgroundColor: Colors.red,
        ),
      ],
    );
  }
}
