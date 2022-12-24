import 'package:news/src/models/item_model.dart';
import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:news/src/resources/news_api_provider.dart';

void main() {
  test('FetchTopIds returns a list of ids', (() async {
    final newsApi = NewsApiProvider();
    newsApi.client = MockClient((request) async {
      return Response(json.encode([1, 2, 3, 4]), 200);
    });

    final ids = await newsApi.fetchTopIds();

    expect(ids, [1, 2, 3, 4]);
  }));

  test('FetchItem returns a item model', () async {
    final newsApi = NewsApiProvider();
    newsApi.client = MockClient((request) async {
      final jsonMap = {
        'id': 123,
        'deleted': false,
        'type': 'typedata',
        'by': 'bydata',
        'time': 0,
        'text': 'textdata',
        'dead': false,
        'parent': 0,
        'kids': [1, 2, 3],
        'url': 'urldata',
        'score': 0,
        'title': 'titledata',
        'descendants': 0
      };
      return Response(json.encode(jsonMap), 200);
    });

    final item = await newsApi.fetchItem(999);

    expect(item.id, 123);
  });
}
