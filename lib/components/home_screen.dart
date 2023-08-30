import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokedex_app/models/pokemon.dart';
import '../providers/theme_provider.dart';
import '../utilities/shared_pref.dart';
import 'favorite_screen.dart';
import 'pokemon_grid.dart';
import 'package:pokedex_app/utilities/poke_api.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<Pokemon> filteredPokeList = [];
  late List<Pokemon> pokemon = [];

  void getPokemonFromPokeApi() async {
    // Get the list of Pokemon from the PokeAPI, then for each Pokemon, get the necessary details
    PokeAPI.getPokemon().then((response) async {
      List<Map<String, dynamic>> data =
          List.from(json.decode(response.body)['results']);
      List<Future<Pokemon>> futurePokemonList =
          data.asMap().entries.map<Future<Pokemon>>((element) async {
        // Get the details for each Pokemon
        Map<String, dynamic>? localData;
        dynamic response = await PokeAPI.getPokemonDetails(element.key + 1);
        localData = json.decode(response.body);
        return Pokemon(
          id: element.key + 1,
          name: element.value['name'],
          img: localData!['sprites']['front_default'],
          type: localData['types'][0]['type']['name'],
          weight: localData['weight'],
        );
      }).toList();

      // Wait for all the Futures to complete
      pokemon = await Future.wait(futurePokemonList);
      // sort the list by Pokemon name - accending
      pokemon.sort((a, b) => a.name.compareTo(b.name));
    });
  }

  @override
  void initState() {
    super.initState();
    getPokemonFromPokeApi();
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  void filterPokemon() {
    filteredPokeList.clear();
    filteredPokeList.addAll(pokemon.where((element) => element.name
        .toLowerCase()
        .contains(_searchController.text.toLowerCase())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // To see the favorite screen
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const FavoriteScreen(),
            ),
          );
        },
        child: const Icon(Icons.favorite),
      ),
      appBar: AppBar(
        title: const Text('Pokedex'),
        leading: AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child: ref.watch(themeProviderNotifier).isDarkMode()
              ? IconButton(
                  icon: const Icon(Icons.brightness_4, color: Colors.white),
                  onPressed: () {
                    ref.read(themeProviderNotifier).toggleTheme(false);
                    SharedPrefs.setBool('isDarkMode', false);
                  },
                )
              : IconButton(
                  icon: const Icon(Icons.brightness_7, color: Colors.black),
                  onPressed: () {
                    ref.read(themeProviderNotifier).toggleTheme(true);
                    SharedPrefs.setBool('isDarkMode', true);
                  },
                ),
        ),
      ),
      body: FutureBuilder(
        future: PokeAPI.getPokemon(),
        builder: (context, snapshot) => snapshot.hasData
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Autocomplete<String>(
                        optionsBuilder: (TextEditingValue textEditingValue) {
                          if (textEditingValue.text == '') {
                            return const Iterable<String>.empty();
                          }
                          return pokemon
                              .where((element) => element.name
                                  .toLowerCase()
                                  .contains(
                                      textEditingValue.text.toLowerCase()))
                              .map((e) => e.name)
                              .toList();
                        },
                        onSelected: (String selection) {
                          setState(() {
                            _searchController.text = selection;
                            filterPokemon();
                          });
                        },
                        fieldViewBuilder: (context, controller, focusNode,
                            onEditingComplete) {
                          return TextField(
                            controller: controller,
                            focusNode: focusNode,
                            onEditingComplete: onEditingComplete,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Search Pokemon',
                              contentPadding: EdgeInsets.all(20),
                            ),
                            onChanged: (value) {
                              setState(() {
                                _searchController.text = value;
                                filterPokemon();
                              });
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    PokemonGrid(filteredPokeList: filteredPokeList),
                  ],
                ),
              )
            : const Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}
