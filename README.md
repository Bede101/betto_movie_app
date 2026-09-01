# Betto Movie App

App mobile sviluppata in Flutter per il browsing di film, ispirata alle funzionalità di base dei servizi di streaming. Recupera i dati da TMDB e permette di sfogliare i film popolari, visualizzarne i dettagli, cercarli e salvarli in una watchlist personale persistente.

## Funzionalità incluse

- Lista dei film popolari, recuperata dinamicamente da TMDB. Vengono visualizzati poster, overview e rating. 
- Visualizzazione individuale per i film, permettendo di leggerne il poster intero e la descrizione completa.
- Watchlist integrata per salvare i film d'interesse.
- Sistema di ricerca dei film all'interno della database, con inclusa la ricerca vocale.

## Stack tecnico

- **Flutter/Dart**
- **TMDB API**: Dati sui film.
- **youtube_player_iframe**: Trailer dei film.
- **shared_preferences**: Memorizzazione persistente della watchlist nello storage.
- **speech_to_text**: Ricerca vocale all'interno della Search Bar.