import 'package:flutter/material.dart';
import 'package:recipe_box/app/auth_widget.dart';
import 'package:recipe_box/app/auth_widget_builder.dart';
import 'package:recipe_box/services/auth/firebase_auth_service.dart';
import 'package:recipe_box/services/image_picker_service.dart';
import 'package:recipe_box/utilities/styles.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<FirebaseAuthService>(
          create: (_) => FirebaseAuthService(),
        ),
        Provider<ImagePickerService>(
          create: (_) => ImagePickerService(),
        ),
      ],
      child: AuthWidgetBuilder(builder: (context, userSnapshot) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: sColorBody1,
          ),
          home: AuthWidget(userSnapshot: userSnapshot),
        );
      }),
    );
  }
}

// void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Login UI',
//       debugShowCheckedModeBanner: false,
//       home: LoginScreen(),
//     );
//   }
// }
