import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:signals_infinite_scroll/ui/reload_button.dart';
import 'package:signals_infinite_scroll/ui/ui.dart';

final getIt = GetIt.instance;

void main() {
  setup();
  runApp(const MainApp());
}

void setup() {
  getIt.registerLazySingleton<Controller>(
    () => Controller(),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme:
            const AppBarTheme(color: Color.fromRGBO(98, 218, 245, 1.0)),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Infinite Posts'),
          centerTitle: true,
          leading: const Padding(
            padding: EdgeInsets.only(left: 10),
            child: ReloadButton(),
          ),
          actions: const [
            Padding(
              padding: EdgeInsets.only(right: 25),
              child: LoadingIndicator(),
            ),
          ],
        ),
        body: const PostsScreen(),
      ),
    );
  }
}
