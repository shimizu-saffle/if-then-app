import 'package:flutter/material.dart';
import 'package:if_then_app/add_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:if_then_app/ifThen_list_controllers.dart';

class TimeLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('If Then Plans'),
      ),
      body: Consumer(
        builder: (context, watch, child) {
          final itList = watch(itListProvider).itList;
          return ListView(
            //意味を理解できてない記述箇所②
            children: itList
                .map(
                  (ifthen) => ListTile(
                    title: Text(ifthen.title!),
                  ),
                )
                .toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddPage(),
              fullscreenDialog: true,
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
