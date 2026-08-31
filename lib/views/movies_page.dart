import 'package:betto_movie_app/constants.dart';
import 'package:betto_movie_app/controllers/movie_controller.dart';
import 'package:betto_movie_app/models/movie.dart';
import 'package:betto_movie_app/views/movie_page.dart';
import 'package:betto_movie_app/views/search_page.dart';
import 'package:betto_movie_app/views/watchlist_page.dart';
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
  bool isSearching = false;
  //Inizializziamo movieController.
  @override
  void initState() {
    super.initState();
    loadMovies();
  }

  void loadMovies () async {
    _movies = _movieController.getMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Betto Movie App'),
        actions: [
        IconButton(
          onPressed: () => Navigator.push(
            context, 
            MaterialPageRoute(builder: (context) => const SearchPage())),
          icon: Icon(isSearching ? Icons.search : Icons.search_outlined),
        ),
         IconButton(
          icon: const Icon(Icons.favorite),
          onPressed: () => Navigator.push(
            context, 
            MaterialPageRoute(builder: (context) => const WatchlistPage()),
          ),
        ) 
        ],
      ),
      body: Column(
        children: [
          FutureBuilder<List<Movie>>(
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
              return Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: movies.length,
                  itemBuilder: (context, index) {
                    final movie = movies[index];
                    return ListTile(
                       leading: movie.posterPath != null
                      ? ClipRRect(
                        borderRadius: BorderRadiusGeometry.circular(5.0),
                        child: Image.network('${Constants.posterUrl}${movie.posterPath}', 
                          width: 75,
                          height: 75,
                          fit: BoxFit.fill,
                        ),
                      ) 
                      : const SizedBox(
                          height: 75,
                          width: 75
                      ), 
                      title: Text(movie.title, style: TextStyle(fontSize: 18)),
                      subtitle: Text(
                        movie.overview, 
                        overflow: TextOverflow.ellipsis, 
                        maxLines: 3,
                        style: TextStyle(fontSize: 16)
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('⭐ ${movie.voteAverage?.toStringAsFixed(1)}',
                            style: TextStyle(fontSize: 18)
                          ),
                          IconButton(
                            onPressed: ()async{
                              await _movieController.toggleFavorite(movie.id);
                              final updated = await _movieController.isFavourite(movie.id);
                              setState(() {
                                movie.isFavorite = updated;
                              });
                            }, 
                            icon: Icon(movie.isFavorite ? Icons.favorite : Icons.favorite_border)
                          )
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context, MaterialPageRoute(
                            builder:(context) => MoviePage(movie: movie)
                          )
                        );
                      },
                    );
                  },
                ),
              );
            }
          ),
        ],
      ),
    );
  }
}