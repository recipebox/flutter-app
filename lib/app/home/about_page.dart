import 'package:recipe_box/services/firebase_storage/firestore_service.dart';
import 'package:recipe_box/utilities/styles.dart';
import 'package:recipe_box/widgets/avatar.dart';
import 'package:recipe_box/models/avatar_reference.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: sColorBody3,
      appBar: AppBar(
        title: Text('About'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(130.0),
          child: Column(
            children: <Widget>[
              _buildUserInfo(context: context),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(
              image: AssetImage('assets/logo/logo_black.png'),
              width: 140.0,
            ),
            SizedBox(
              height: 90,
            ),
            Text(
              'Recepe Box',
              style: Theme.of(context).textTheme.headline1,
            ),
            SizedBox(height: 12),
            Text(
              'Enjoy planning your next recipe',
              style: Theme.of(context).textTheme.headline3,
            ),
          ],
        ),
      ),
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
}
