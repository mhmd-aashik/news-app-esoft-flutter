import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/news_viewmodel.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NewsViewModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false, // Hides the debug banner
        title: 'News App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const SplashScreen(), // Wraps HomeScreen in a MaterialApp
      ),
    );
  }
}
