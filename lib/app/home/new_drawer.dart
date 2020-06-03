import 'package:flutter/material.dart';
import 'package:recipe_box/app/home/about_page.dart';
import 'package:recipe_box/app/home/setting_page.dart';
import 'package:recipe_box/services/auth/firebase_auth_service.dart';
import 'package:recipe_box/services/firebase_storage/firestore_service.dart';
import 'package:recipe_box/services/firestore/plan_service.dart';
import 'package:recipe_box/utilities/styles.dart';
import 'package:recipe_box/widgets/avatar.dart';
import 'package:recipe_box/models/avatar_reference.dart';
import 'package:provider/provider.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:toast/toast.dart';

class NewDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final planService = Provider.of<PlanService>(context, listen: false);
    return Container(
      width: 200.0,
      decoration: BoxDecoration(color: sColorBody1),
      child: Column(
        children: <Widget>[
          Expanded(flex: 3, child: _createHeader(context)),
          Expanded(
              flex: 5,
              child: ListView(
                children: <Widget>[
                  _createDrawerItem(
                    icon: Icons.home,
                    text: 'Home',
                    context: context,
                    onTap: () {
                      Navigator.pop(context);
                      Toast.show('Coming soon..', context,
                          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                    },
                  ),
                  _createDrawerItem(
                    icon: Icons.queue_play_next,
                    text: 'New plan',
                    context: context,
                    onTap: () async {
                      Navigator.of(context).pop();
                      final text = await showTextInputDialog(
                        context: context,
                        title: 'What\' the plan name?',
                        // message: 'Input you plan',
                        textFields: const [
                          DialogTextField(
                            hintText: 'Define you plan name',
                            initialText: '',
                          ),
                        ],
                      );
                      if (text != null && text.length > 0 && text[0] != "") {
                        planService.createPlan(text[0]);
                      }
                    },
                  ),
                  _createDrawerItem(
                    icon: Icons.archive,
                    text: 'Plan archive',
                    context: context,
                    onTap: () {
                      Navigator.pop(context);
                      Toast.show('Coming soon..', context,
                          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                    },
                  ),
                  Divider(
                    color: Colors.white38,
                  ),
                  _createDrawerItem(
                    icon: Icons.settings,
                    text: 'Setting',
                    context: context,
                    onTap: () {
                      Navigator.of(context).pop();
                      // Toast.show('Coming soon..', context,
                      //     duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);

                      Navigator.of(context).push(
                        MaterialPageRoute(
                          fullscreenDialog: true,
                          builder: (_) => SettingPage(),
                        ),
                      );
                    },
                  ),
                  _createDrawerItem(
                    icon: Icons.info,
                    text: 'About',
                    context: context,
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          fullscreenDialog: true,
                          builder: (_) => AboutPage(),
                        ),
                      );
                    },
                  ),
                ],
              )),
          Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  _createDrawerItem(
                    icon: Icons.exit_to_app,
                    text: 'Logout',
                    context: context,
                    onTap: () => _signOut(context),
                  ),
                  SizedBox(
                    height: 20.0,
                  )
                ],
              )),
        ],
      ),
    );
  }

  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<FirebaseAuthService>(context, listen: false);
      await auth.signOut();
    } catch (e) {
      print(e);
    }
  }
}

Widget _createHeader(BuildContext context) {
  return DrawerHeader(
    child: Column(
      children: <Widget>[
        Text(
          'Welcome',
          style: TextStyle(
            color: sColorTextHeader1,
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 10.0,
        ),
        _buildUserInfo(context: context),
      ],
    ),
  );
}

Widget _createDrawerItem(
    {IconData icon,
    String text,
    GestureTapCallback onTap,
    BuildContext context}) {
  return ListTile(
    title: Row(
      children: <Widget>[
        Icon(
          icon,
          color: sColorTextHeader1,
        ),
        Padding(
          padding: EdgeInsets.only(left: 12.0),
          child: Text(
            text,
            style: TextStyle(
              color: sColorTextHeader1,
              fontSize: 15.0,
            ),
          ),
        )
      ],
    ),
    onTap: onTap,
  );
}

Widget _buildUserInfo({BuildContext context}) {
  final database = Provider.of<FirestoreService>(context, listen: false);
  return StreamBuilder<AvatarReference>(
    stream: database.avatarReferenceStream(),
    builder: (context, snapshot) {
      final avatarReference = snapshot.data;
      return Avatar(
        photoUrl: avatarReference?.photoUrl,
        radius: 50,
        borderColor: Colors.black54,
        borderWidth: 2.0,
      );
    },
  );
}
