import 'package:flutter/material.dart';
import 'package:news/src/blocs/comment_provider.dart';
import 'dart:async';

import 'package:news/src/models/item_model.dart';
import 'package:news/src/widgets/comment.dart';

class NewsDetails extends StatelessWidget {
  final int itemId;

  NewsDetails(this.itemId);

  Widget build(context) {
    final bloc = CommentProvider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Details'),
      ),
      body: buildBody(bloc),
    );
  }

  Widget buildBody(CommentsBloc bloc) {
    return StreamBuilder(
      stream: bloc.itemWithComments,
      builder: (context, AsyncSnapshot<Map<int, Future<ItemModel?>>> snapshot) {
        if (!snapshot.hasData) {
          return Text('loading');
        }

        final itemFuture = snapshot.data?[itemId];

        return FutureBuilder(
          future: itemFuture,
          builder: (context, itemSnapshot) {
            if (!itemSnapshot.hasData) {
              return Text('Loading');
            }

            return buildList(itemSnapshot.data, snapshot.data!);
          },
        );
      },
    );
  }

  Widget buildList(ItemModel? item, Map<int, Future<ItemModel?>> itemMap) {
    final children = <Widget>[];
    children.add(buildTitle(item));

    final commentList = item!.kids!.map((kidId) {
      return Comment(itemId: kidId, itemMap: itemMap,depth: 0,);
    });
    children.addAll(commentList);

    return ListView(children: children);
  }

  Widget buildTitle(ItemModel? item) {
    return Container(
      margin: EdgeInsets.all(10.0),
      alignment: Alignment.topCenter,
      child: Text(
        item!.title.toString(),
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
      ),
    );
  }
}
