import 'package:flutter/material.dart';
import 'package:pokedex_app/components/pokemon_tile.dart';

import '../models/pokemon.dart';

class PokemonGrid extends StatelessWidget {
  const PokemonGrid({
    super.key,
    required this.filteredPokeList,
  });

  final List<Pokemon> filteredPokeList;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GridView.builder(
          itemCount: filteredPokeList.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5),
          itemBuilder: (context, index) {
            return PokeTile(pokemon: filteredPokeList[index]);
          }),
    );
  }
}
