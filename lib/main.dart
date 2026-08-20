import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
Future<void> main() async{
  await dotenv.load(fileName: '.env');
  runApp(const MovieApp());
}

class MovieApp extends StatelessWidget {
  const MovieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie App',
      theme: ThemeData(
        useMaterial3: true,

      ),
    );
  }
}