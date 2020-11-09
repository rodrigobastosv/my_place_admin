import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_place/theme/light_theme.dart';
import 'package:my_place/page/sign_in/sign_in_page.dart';
import 'package:oktoast/oktoast.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OKToast(
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        home: SignInPage(),
      ),
    );
  }
}
