import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:vmblog/src/features/home/presentation/HomeScreen.dart';
import 'package:vmblog/src/shared/utils/colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VMBlog',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: brown),
        useMaterial3: true,
      ),
      home: HomeScreen(),
    );
  }
}

