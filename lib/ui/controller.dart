import 'dart:convert';

import 'package:http/http.dart';
import 'package:signals/signals.dart';
import 'package:signals_infinite_scroll/domain/post.dart';

class Controller {
  late final postsSignal =
      futureSignal(() => fetchData(), fireImmediately: true);
  final pageNumberSignal = signal(1);
  final isLastPageSignal = signal(false);
  late final eligibleForFetchingData =
      computed(() => !postsSignal.value.isLoading && !isLastPageSignal.value);
  final int numberOfPostsPerRequest = 10;

  Future<List<Post>> fetchData() async {
    final response = await get(Uri.parse(
        "https://jsonplaceholder.typicode.com/posts?_page=${pageNumberSignal.value}&_limit=$numberOfPostsPerRequest"));
    List responseList = json.decode(response.body);
    List<Post> postList = responseList
        .map((data) => Post(
            body: data['body'],
            title: data['title'],
            id: data['id'],
            userId: data['userId']))
        .toList();
    isLastPageSignal.value = postList.length < numberOfPostsPerRequest;
    pageNumberSignal.value = pageNumberSignal.value + 1;
    if (postsSignal.value.hasValue) {
      return postsSignal.value.value!.toSet().toList()..addAll(postList);
    } else {
      return postList;
    }
  }

  void resetAndFetchData() {
    batch(() {
      pageNumberSignal.value = 1;
      isLastPageSignal.value = false;
    });
    postsSignal.reset();
  }
}
