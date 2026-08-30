import 'package:betto_movie_app/views/movies_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  runApp(const MovieApp());
}

class MovieApp extends StatelessWidget {
  const MovieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Betto Movie App',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Color.fromRGBO(230, 215, 255, 1),
        textTheme: Theme.of(context).textTheme.apply(
          bodyColor: const Color.fromARGB(255, 66, 82, 90), 
          displayColor: const Color.fromARGB(255, 66, 82, 90)
        )
      ),
      home: const MoviesPage(),
    );
  }
}