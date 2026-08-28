import 'package:shared_preferences/shared_preferences.dart';

class FavouriteService {
  //Creiamo la string key per la lettura dei film preferiti, ovvero quelli che andremo ad aggiungere 
  //nella watchlist
  static const String _key = "favourite_movies";
  Future<List<int>> getAll() async {
    //Andiamo a creare preferences per prendere un instanza di SharedPreferences per andare a film in localmente 
    final preferences = await SharedPreferences.getInstance();
    //Andiamo a fare il nullability check di preferences. Se è nullo restituirà una stringa vuota, altrimenti
    //Va a prendere il value relativo alla key da ogni stringa nella lista
    final favourites = preferences.getStringList(_key) ?? [];
    //Andiamo a fare un int parse di ogni elemento in favorites e lo salviamo in una lista
    return favourites.map(int.parse).toList();
  }
  Future<void> _add(int id) async {
    final preferences = await SharedPreferences.getInstance();
    final favourites = await getAll();
    favourites.add(id);
    await preferences.setStringList(_key, favourites.map((id) => id.toString()).toList());
  }
  Future<void> _remove(int id) async {
    final preferences = await SharedPreferences.getInstance();
    final favourites = await getAll();
    favourites.remove(id);
    await preferences.setStringList(_key, favourites.map((id) => id.toString()).toList());
  }
  Future<bool> contains(int id) async {
    final favourites = await getAll();
    return favourites.contains(id);
  }
  Future<void> toggle(int id) async {
    if(await contains(id)){
      await _remove(id);
    }
    else{
      await _add(id);
    }
  }
}
