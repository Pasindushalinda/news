import 'package:flutter/material.dart';
import 'package:news/src/models/item_model.dart';
import 'package:news/src/widgets/loading_container.dart';

class Comment extends StatelessWidget {
  late final int? itemId;
  late final Map<int, Future<ItemModel?>>? itemMap;
  late final int? depth;

  Comment({this.itemId, this.itemMap, this.depth});

  Widget build(context) {
    return FutureBuilder(
      future: itemMap![itemId],
      builder: (context, AsyncSnapshot<ItemModel?> snapshot) {
        if (!snapshot.hasData) {
          return LoadingContainer();
        }

        final item = snapshot.data;

        final children = <Widget>[
          ListTile(
            title: item!.dead ? Text('Deleted') : buildText(item),
            subtitle: item.by == '' ? Text('') : Text(item.by!),
            contentPadding: EdgeInsets.only(
              right: 16.0,
              left: (depth! + 1) * 16.0,
            ),
          ),
          Divider()
        ];

        snapshot.data?.kids?.forEach((kidId) {
          children.add(
            Comment(itemId: kidId, itemMap: itemMap, depth: depth! + 1),
          );
        });

        return Column(
          children: children,
        );
      },
    );
  }

  Widget buildText(ItemModel? item) {
    final text = item!.text!
        .replaceAll('&#x27', "'")
        .replaceAll('&#x2F', "'")
        .replaceAll('<p>', '\n\n')
        .replaceAll('</p>', '');

    return Text(text);
  }
}
