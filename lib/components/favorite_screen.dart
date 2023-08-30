import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokedex_app/providers/favorite_provider.dart';

import 'pokemon_detailed_screen.dart';

class FavoriteScreen extends ConsumerStatefulWidget {
  const FavoriteScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends ConsumerState<FavoriteScreen> {
  @override
  Widget build(BuildContext context) {
    final favoriteListProvider = ref.watch(favoriteProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Pokemon'),
      ),
      body: ListView.builder(
        itemCount: favoriteListProvider.favoriteList.length,
        itemBuilder: (context, index) {
          final pokemon = favoriteListProvider.favoriteList[index];
          return ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailedScreen(pokemon: pokemon),
                ),
              );
            },
            title: Text(pokemon.name),
            leading: Image.network(pokemon.img),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                favoriteListProvider.removePokemon(pokemon);
              },
            ),
          );
        },
      ),
    );
  }
}
