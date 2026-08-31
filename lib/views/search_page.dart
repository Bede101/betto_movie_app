import 'package:betto_movie_app/constants.dart';
import 'package:betto_movie_app/controllers/movie_controller.dart';
import 'package:betto_movie_app/models/movie.dart';
import 'package:betto_movie_app/views/movie_page.dart';
import 'package:betto_movie_app/views/watchlist_page.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  final MovieController _movieController = MovieController();
  final TextEditingController _searchController = TextEditingController();
  //Inseriamo il late per definire che movies non potrà essere più nullable dopo la chiamata
  Future<List<Movie>>? _resultMovies;
  //Inizializziamo movieController.
  @override
  void initState() {
    super.initState();
  }

  void runSearch(String query) {
    setState(() {
      if (query.isNotEmpty) {
        _resultMovies = _movieController.searchMovies(query);
      }
    });
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
          icon: Icon(Icons.home),
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
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  autofocus: true,
                  decoration: InputDecoration(hintText: 'Type to search...'),
                  textInputAction: TextInputAction.search,
                  onSubmitted: runSearch
                )
              ),
              IconButton(
                onPressed: () => runSearch(_searchController.text), 
                icon: Icon(Icons.search)
              )
            ]
          ),
          _resultMovies == null ? Text('Type a title...') : 
          Expanded( 
            child: FutureBuilder<List<Movie>>(
            future: _resultMovies, 
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting){
                return const Center(
                  child: CircularProgressIndicator()
                );
              }
              else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              else if (!snapshot.hasData || snapshot.data!.isEmpty)
              {
                return Text('No results.');
              }
              final List<Movie> movies = snapshot.data ?? [];
              return ListView.builder(
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
              );
            }
            )
          ),
        ],
      ),
    );
  }
}