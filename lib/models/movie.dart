class Movie {
  int id;
  String title;
  String overview;
  double? voteAverage;
  String? posterPath;
  bool isFavorite;

  Movie({
    required this.id, 
    required this.title, 
    required this.overview,
    this.voteAverage, 
    this.posterPath,
    this.isFavorite = false,
  });

//Andiamo a utilizzare factory come costruttore secondario del json chiamato dall'API,
//passando al Movie.fromJson la Map ottenute

  factory Movie.fromJson(Map<String, dynamic> json, bool isFavourite) {
    return Movie(
      //Passiamo la chiave che deve andare a riferirsi per il contenuto
      id: json['id'], 
      title: json['title'], 
      overview: json['overview'],
      //Andiamo a convertire vote_average visto che è un double
      voteAverage: json['vote_average'].toDouble(),
      posterPath: json['poster_path'],
      isFavorite: isFavourite 
    );
  }
}