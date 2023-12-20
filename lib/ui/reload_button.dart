import 'package:flutter/material.dart';
import 'package:signals_infinite_scroll/main.dart';
import 'package:signals_infinite_scroll/ui/ui.dart';

class ReloadButton extends StatelessWidget {
  const ReloadButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => getIt<Controller>().resetAndFetchData(),
      icon: const Icon(Icons.refresh, size: 40,),
    );
  }
}
