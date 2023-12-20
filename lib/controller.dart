import 'dart:convert';

import 'package:http/http.dart';
import 'package:signals/signals.dart';
import 'package:signals_infinite_scroll/lib.dart';

class Controller {
  //final postsSignal = FutureSignal<List<Post>>(initialValue: <Post>[]);
  late final postsSignal = futureSignal(() => fetchData(), initialValue: <Post>[]); //FutureSignal<List<Post>>(initialValue: <Post>[]);
  final pageNumberSignal = signal(1);
  final isLastPageSignal = signal(false);
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
    final posts = postsSignal.value.value!.toSet().toList()..addAll(postList);
    return posts;
  }

  void resetAndFetchData() {
    postsSignal.reset();
    pageNumberSignal.value = 0;
    isLastPageSignal.value = false;
    fetchData();
  }
}
