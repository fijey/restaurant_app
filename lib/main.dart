import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/data/provider/add_review_provider.dart';
import 'package:restaurant_app/data/provider/restaurant_search_provider.dart';
import 'package:restaurant_app/screen/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (BuildContext, Orientation, ScreenType) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider<RestaurantSearchProvider>(
              create: (context) =>
                  RestaurantSearchProvider(apiService: ApiService(), query: ""),
            ),
            ChangeNotifierProvider<AddReviewProvier>(
                create: (context) =>
                    AddReviewProvier(apiService: ApiService())),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: ThemeData(
              // This is the theme of your application.
              //
              // Try running your application with "flutter run". You'll see the
              // application has a blue toolbar. Then, without quitting the app, try
              // changing the primarySwatch below to Colors.green and then invoke
              // "hot reload" (press "r" in the console where you ran "flutter run",
              // or simply save your changes to "hot reload" in a Flutter IDE).
              // Notice that the counter didn't reset back to zero; the application
              // is not restarted.
              primarySwatch: Colors.blue,
            ),
            home: const SplashScreen(),
          ),
        );
      },
    );
  }
}
