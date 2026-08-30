import 'package:betto_movie_app/constants.dart';
import 'package:betto_movie_app/controllers/movie_controller.dart';
import 'package:betto_movie_app/models/movie.dart';
import 'package:betto_movie_app/views/movie_page.dart';
import 'package:flutter/material.dart';

class WatchlistPage extends StatefulWidget {
  const WatchlistPage({super.key});

  @override
  State<WatchlistPage> createState() => _WatchlistPageState();
}

class _WatchlistPageState extends State<WatchlistPage> {
  final MovieController _movieController = MovieController();
  //Inseriamo il late per definire che movies non potrà essere più nullable dopo la chiamata
  late Future<List<Movie>> _movies;
  
  @override
  void initState() {
    super.initState();
    _loadFavourites();
  }

  void _loadFavourites () async {
    setState(() {
      _movies = _movieController.getAllFavourites();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Watchlist Page'
        ),
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
          );
        }
      )
    );
  }
}