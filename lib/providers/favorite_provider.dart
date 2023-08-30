import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokedex_app/models/pokemon.dart';

//// I tried here to import the shared preferences package, but it didn't work so I commented it out
// for shared preferences
import 'package:pokedex_app/utilities/shared_pref.dart';
import 'dart:convert';

const String _kFavoriteKey = 'favorites';

class FavoriteProvider extends ChangeNotifier {
  final List<Pokemon> _favoriteList =
      (SharedPrefs.getStringList(_kFavoriteKey)?.map((e) {
                print(e.runtimeType);
                print(json.decode(e).runtimeType);
                return Pokemon.fromJson(json.decode(e));
              }) ??
              [])
          .toList();

  List<Pokemon> get favoriteList => _favoriteList;

  void addPokemon(Pokemon pokemon) {
    _favoriteList.add(pokemon);
    notifyListeners();

    // Save to shared preferences
    SharedPrefs.setStringList(
      _kFavoriteKey,
      _favoriteList.map((e) => json.encode(e.toString())).toList(),
    );
  }

  void removePokemon(Pokemon pokemon) {
    _favoriteList.remove(pokemon);
    notifyListeners();

    // Save to shared preferences
    SharedPrefs.setStringList(
      _kFavoriteKey,
      _favoriteList.map((e) => json.encode(e.toString())).toList(),
    );
  }

  bool isPokemonFavorite(Pokemon pokemon) {
    return _favoriteList.contains(pokemon);
  }
}

final favoriteProvider = ChangeNotifierProvider((ref) => FavoriteProvider());
