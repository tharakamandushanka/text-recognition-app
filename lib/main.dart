import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_firebase/constants/colors.dart';
import 'package:flutter_firebase/firebase_options.dart';
import 'package:flutter_firebase/main_screen.dart';
import 'package:flutter_firebase/provider/premium_provider.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  //Load the env 
  await dotenv.load(fileName:".env");
  Stripe.publishableKey= dotenv.env["STRIPE_PUBLISHABLE_KEY"] ?? "";
 

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(
    MultiProvider(providers:[
      ChangeNotifierProvider(
        create: (context) => PremiumProvider(),
        ),
    ],
    child:const MyApp(),
    )
    
    );
}

 class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override 
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "ML Text Recognition",
      debugShowCheckedModeBanner: false,  
      theme:ThemeData(
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: mainColor,
        ),
        fontFamily: GoogleFonts.poppins().fontFamily,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          color: mainColor,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            padding: const EdgeInsets.symmetric(
              vertical: 5,
              horizontal: 20,
            ),
            shape: RoundedRectangleBorder(
              borderRadius:BorderRadius.circular(20), 
              side: const BorderSide(color: mainColor),
              ),
              backgroundColor: mainColor,
          ),
        ),

      ),
      home: MainScreen(),
    );
  }
}