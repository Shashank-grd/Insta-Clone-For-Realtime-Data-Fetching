import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/providers/userprovider.dart';
import 'package:insta_clone/responsive/mobile.dart';
import 'package:insta_clone/responsive/responsive_layout.dart';
import 'package:insta_clone/responsive/web.dart';
import 'package:insta_clone/screens/login-screen.dart';
import 'package:insta_clone/utils/color.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb){
    await Firebase.initializeApp(
      options:const FirebaseOptions(
          apiKey: "AIzaSyC8df28XUxk_q02cEA_xvWR67QdiVOHwNc",
          appId: "1:57866702984:web:5d2acfcc3036b28ee70f3d",
          messagingSenderId: "57866702984",
          projectId: "instagram-clone-926b7",
          storageBucket: "instagram-clone-926b7.appspot.com"
      )
    );
  }else {
    Platform.isAndroid ? await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: "AIzaSyAz0Ba1WHUcYAbGT4ExYR7w3Fi3K59akAk",
          appId: "1:57866702984:android:2353ef8a9597cf63e70f3d",
          messagingSenderId: "57866702984",
          projectId: "instagram-clone-926b7",
          storageBucket: "instagram-clone-926b7.appspot.com",
        )) : await Firebase.initializeApp();
  }
  //await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider(),)
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Insta Demo',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: mobileBackgroundColor
        ),
        //home:const Responsive_layout(mobileScreenLayout: MobileScreenLayout(),webScreenLayout: WebScreenLayout(),)
      home:StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context,snapshot){
          if(snapshot.connectionState== ConnectionState.active){
            if(snapshot.hasData){
              return const Responsive_layout(webScreenLayout: WebScreenLayout(), mobileScreenLayout: MobileScreenLayout());
            }else if(snapshot.hasError){
              return Center(
                child: Text("${snapshot.error}"),
              );
            }
          }
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            );
          }
          return const LoginScreen();
        },
      )
      ),
    );
  }
}
