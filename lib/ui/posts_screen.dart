import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';
import 'package:signals_infinite_scroll/main.dart';
import 'package:signals_infinite_scroll/ui/ui.dart';

class PostsScreen extends StatelessWidget {
  const PostsScreen({super.key});

  final int _nextPageTrigger = 3;

  @override
  Widget build(BuildContext context) {
    final controller = getIt.get<Controller>();
    return Watch<Widget>((context) {
      final postsState = controller.postsSignal.value;
      final posts = postsState.value;
      if (posts!.isEmpty) {
        if (postsState.isLoading) {
          return const Center(
              child: Padding(
            padding: EdgeInsets.all(8),
            child: CircularProgressIndicator(),
          ));
        } else if (postsState.hasError) {
          return const Center(
              child: Text(
            'error',
          ));
        }
      }
      return ListView.builder(
          itemCount: posts.length + (controller.isLastPageSignal.value ? 0 : 1),
          itemBuilder: (context, index) {
            if (index == (posts.length - _nextPageTrigger) &&
                controller.eligibleForFetchingData.value) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                controller.postsSignal.refresh();
              });
            }
            if (index == posts.length) {
              if (postsState.hasError) {
                return const Center(
                    child: Text(
                  'error',
                ));
              } else {
                return const Center(
                    child: Padding(
                  padding: EdgeInsets.all(8),
                  child: CircularProgressIndicator(),
                ));
              }
            }
            final post = posts[index];
            return Padding(
                padding: const EdgeInsets.all(15.0),
                child: PostItem(
                  post.title,
                  post.body,
                  post.id,
                ));
          });
    });
  }
}
