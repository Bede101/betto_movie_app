import 'package:betto_movie_app/constants.dart';
import 'package:betto_movie_app/controllers/movie_controller.dart';
import 'package:betto_movie_app/models/movie.dart';
import 'package:flutter/material.dart';

class MoviesPage extends StatefulWidget {
  const MoviesPage({super.key});

  @override
  State<MoviesPage> createState() => _MoviesPageState();
}

class _MoviesPageState extends State<MoviesPage> {

  final MovieController _movieController = MovieController();
  //Inseriamo il late per definire che movies non potrà essere più nullable dopo la chiamata
  late Future<List<Movie>> _movies;

  @override
  void initState() {
    super.initState();
    _movies = _movieController.getMovies();
    print(_movies);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Betto Movie App'),
      ),
      body: FutureBuilder<List<Movie>>(
        future: _movies, 
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting){
            return const Center(
              child: CircularProgressIndicator()
            );
          }
          else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          final List<Movie> movies = snapshot.data ?? [];
          return ListView.builder(
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];
              return ListTile(
                //TODO 
                 leading: movie.posterPath != null
                ? Image.network('${Constants.posterUrl}${movie.posterPath}', 
                  width: 60,
                  height: 60,
                  fit: BoxFit.fill
                ) 
                : const SizedBox(
                    height: 60,
                    width: 60
                ), 
                title: Text(movie.title),
                subtitle: Text(movie.overview),
                trailing: Text('⭐ ${movie.voteAverage}'),
              );
            },
          );
        }
      ),
    );
  }
}