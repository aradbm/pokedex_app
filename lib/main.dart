import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokedex_app/components/home_screen.dart';
import 'package:pokedex_app/providers/theme_provider.dart';
import 'package:pokedex_app/utilities/shared_pref.dart';
import 'package:pokedex_app/utilities/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefs.init();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context, ref) {
    return MaterialApp(
      title: 'Flutter Test',
      theme: theme,
      darkTheme: darkTheme,
      themeMode: ref.watch(themeProviderNotifier).themeMode,
      home: const HomeScreen(),
    );
  }
}
