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
        //Permettiamo all'utente di accedere alla Watchlist e alla pagina di ricerca
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
          //Usiamo FutureBuilder per andare a costruire la pagina usando la lista di film
          //passati
          FutureBuilder<List<Movie>>(
            future: _movies, 
            //CircularProgressIndicator verrà mostrato durante il caricamento della pagina
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting){
                return const Center(
                  child: CircularProgressIndicator()
                );
              }
              //In caso di errore, verrà mostrata la causa
              else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              //La lista movies sarà vuota se i dati non sono ancora caricati
              final List<Movie> movies = snapshot.data ?? [];
              //Andiamo a creare visualmente la lista di film popolari 
              //mediante ListView.builder
              return Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: movies.length,
                  itemBuilder: (context, index) {
                    final movie = movies[index];
                    //Utilizziamo ListTile per generare le righe della Lista, ognuna
                    //contenente un film
                    return ListTile(
                      //Assegnamo il poster prima del titolo
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
                      //Andiamo ad mostrare gli altri parametri, ovverosia il titolo,
                      //il rating e la sinossi
                      title: Text(movie.title, style: TextStyle(fontSize: 18)),
                      subtitle: Text(
                        movie.overview, 
                        overflow: TextOverflow.ellipsis, 
                        maxLines: 3,
                        style: TextStyle(fontSize: 16)
                      ),
                      //Utilizziamo il trailing per impostare il rating all'estremità destra
                      //della riga
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
                      //Cliccando sulla riga del film generata di ListTile, verrà mostrata
                      //La pagina dettagli del film specifico
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