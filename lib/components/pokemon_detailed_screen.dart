import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokedex_app/models/pokemon.dart';

import '../providers/favorite_provider.dart';
import '../utilities/poke_api.dart';

class DetailedScreen extends ConsumerStatefulWidget {
  const DetailedScreen({super.key, required this.pokemon});

  final Pokemon pokemon;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _DetailedScreenState();
  }
}

class _DetailedScreenState extends ConsumerState<DetailedScreen> {
  // get the specific details of the pokemon from the PokeAPI
  Map<String, dynamic>? data;
  void getPokemonDetailsFromPokeApi() async {
    await PokeAPI.getPokemonDetails(widget.pokemon.id).then((response) {
      data = json.decode(response.body);
      // print(data);
    });
  }

  @override
  void initState() {
    super.initState();
    getPokemonDetailsFromPokeApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
      future: PokeAPI.getPokemonDetails(widget.pokemon.id),
      builder: (context, snapshot) => snapshot.hasData
          // if the data is available, display the details of the pokemon, else display a loading indicator
          ? Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 10,
              ),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.lightBlue.shade50,
                borderRadius: BorderRadius.circular(50),
                border: Border.all(color: Colors.black),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  Text(
                    widget.pokemon.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Image.network(
                    data!['sprites']['front_default'],
                    height: 100,
                    width: 100,
                  ),
                  Text(
                    data!['weight'].toString(),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Weight: ${data!['weight'].toString()}",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Hieght: ${data!['height'].toString()}",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Type: ${data!['types'][0]['type']['name']}",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Abilities: ${data!['abilities'][0]['ability']['name']}",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ref
                                  .read(favoriteProvider)
                                  .isPokemonFavorite(widget.pokemon) ==
                              true
                          ? ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  ref
                                      .read(favoriteProvider)
                                      .removePokemon(widget.pokemon);
                                });
                              },
                              child: const Text('Remove from favorite'))
                          : ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  ref
                                      .read(favoriteProvider)
                                      .addPokemon(widget.pokemon);
                                });
                              },
                              child: const Text('Add to favorite')),
                      const SizedBox(width: 40),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('back')),
                    ],
                  )
                ],
              ),
            )
          : const Center(child: CircularProgressIndicator()),
    ));
  }
}
