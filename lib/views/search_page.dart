import 'package:betto_movie_app/constants.dart';
import 'package:betto_movie_app/controllers/movie_controller.dart';
import 'package:betto_movie_app/models/movie.dart';
import 'package:betto_movie_app/views/movie_page.dart';
import 'package:betto_movie_app/views/watchlist_page.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt; 
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  final MovieController _movieController = MovieController();
  //Andiamo a creare una istanza di TextEditingController, così da controllare e 
  //leggere/modificare il TextField
  final TextEditingController _searchController = TextEditingController();
  Future<List<Movie>>? _resultMovies;
  //Creiamo anche una istanza di SpeechToText, necessario per far funzionare correttamente
  //il riconoscimento vocale del device
  final stt.SpeechToText _speechToText = stt.SpeechToText();
  bool _speechAvailable = false;
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }
  //Inizializziamo lo SpeechToText e assegniamo a _speechAvailable 
  //il risultato dell'inizializzazione
  Future<void> _initSpeech () async {
    _speechAvailable = await _speechToText.initialize();
    setState(() {
      
    });
  }

  //Definiamo toggleListening per avviare o interrompere il riconoscimento vocale 
  //e facciamo in modo che vada ad aggiornare lo stato _isListening.
  Future<void> _toggleListening () async {
    if (!_speechAvailable) return;
    //if per interrompere l'ascolto
    if (_isListening) {
      await _speechToText.stop();
      setState(() {
        _isListening = false;
      });
    }
    else {
      setState(() {
        _isListening = false;
      });
      await _speechToText.listen(
        listenOptions: stt.SpeechListenOptions(localeId: 'en_US'),
        onResult:(result) {
          final text = result.recognizedWords;
          //Inseriamo le parole riconoscute dalla voce dell'utente alla search bar
          _searchController.text = text;
          //Permettiamo all'utente la possibilità di aggiungere altre parole per la ricerca 
          //Mediante il TextSelection
          _searchController.selection = TextSelection.fromPosition(TextPosition(offset: text.length));
          runSearch(_searchController.text);
        },
      );
    }
    setState(() {
      _isListening = false;
    });
  }
  //Avviamo la ricerca con runSearch, facendogli chiamare searchMovies tramite il controller
  // e assegnando il Future risultante a _resultMovies
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
          onPressed: () => Navigator.pop(context),
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
              //Andiamo a dichiarare il widget Expanded così da permettere al TextField di
              //Riconoscere quanto spazio può effettivamente occupare
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  //Andiamo a creare il TextField, passandogli come controller 
                  //_searchController e facendogli chiamare runSearch al momento dell'invio 
                  child: TextField(
                    controller: _searchController,
                    autofocus: true,
                    decoration: InputDecoration(hintText: 'Type to search...'),
                    textInputAction: TextInputAction.search,
                    onSubmitted: runSearch
                  )
                )
              ),
              //Andiamo a fare in modo che se _speechAvailable è true, allora mostri
              //l'icona del microfono, permettendo dunque la ricerca  vocale
              _speechAvailable ? IconButton(
                onPressed: () => _toggleListening(), 
                icon: Icon(Icons.mic)
              ) : SizedBox(),
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