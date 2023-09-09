import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/responsive/mobileScreenLayout.dart';
import 'package:instagram_clone/responsive/responsive_layoutscreen.dart';
import 'package:instagram_clone/responsive/webScreenLayout.dart';
import 'package:instagram_clone/screens/login_screen.dart';
import 'package:instagram_clone/screens/sign_up_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:provider/provider.dart';
import 'dart:html' as html;
void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
      apiKey: "AIzaSyBfzmGFuMxt5dmmZuQMCiFHssxSSTJoMqA",
      appId: "1:321885962237:web:3a89b2a067dce9b44f6394",
      messagingSenderId: "321885962237",
      projectId: "instagramclone-11af9",
      storageBucket: "instagramclone-11af9.appspot.com",
    ));
  } else {
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => UserProvider())],
      child: MaterialApp(
        title: 'Instagrame Clone',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: mobileBackgroundColor,
        ),
        debugShowCheckedModeBanner: false,
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.none) {
              // Afficher un indicateur de progression circulaire pendant la connexion
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Afficher un indicateur de progression circulaire pendant la connexion
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.connectionState == ConnectionState.active) {
              // Checking if the snapshot has any data or not
              if (snapshot.hasData) {
                // if snapshot has data which means user is logged in then we check the width of screen and accordingly display the screen layout
                return const ResponsiveLayout(
                  mobileScreenLayout: MobileScreenLayout(),
                  webScreenLayout: WebScreenLayout(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('${snapshot.error}'),
                );
              }
            }

            // means connection to future hasnt been made yet
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return const LoginScreen();
          },
        ),
      ),
    );
  }
}
