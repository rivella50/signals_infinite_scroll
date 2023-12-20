import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';
import 'package:signals_infinite_scroll/main.dart';
import 'package:signals_infinite_scroll/ui/ui.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Watch((context) => getIt<Controller>().postsSignal.value.isLoading
      ? const CircularProgressIndicator()
      : const SizedBox.shrink()
    );
  }
}
