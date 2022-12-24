import 'package:flutter/material.dart';
import 'package:news/src/blocs/comment_provider.dart';
import 'package:news/src/screens/news_details.dart';
import 'screens/news_list.dart';
import 'blocs/stories_provider.dart';

class App extends StatelessWidget {
  Widget build(context) {
    return CommentProvider(
        child: StoriesProvider(
            child: MaterialApp(
      title: 'News',
      onGenerateRoute: routes,
    )));
  }

  Route routes(RouteSettings settings) {
    if (settings.name == '/') {
      return MaterialPageRoute(
        builder: (context) {
          final storiesBloc = StoriesProvider.of(context);
          storiesBloc.fetchTopIds();

          return NewsList();
        },
      );
    } else {
      return MaterialPageRoute(
        builder: (context) {
          final commentBloc = CommentProvider.of(context);
          final itemId = int.parse(settings.name!.replaceFirst('/', ''));

          commentBloc.fetchItemWithComments(itemId);

          return NewsDetails(itemId);
        },
      );
    }
  }
}
