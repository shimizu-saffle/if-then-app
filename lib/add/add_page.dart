import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:if_then_app/IfThen.dart';
import 'package:if_then_app/ifThen_list_controllers.dart';

class AddPage extends StatelessWidget {
  AddPage({this.ifThen});
  final IfThen? ifThen;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('add'),
      ),
      body: Consumer(
        builder: (context, watch, child) {
          final addController = watch(AddProvider);
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  decoration:
                      InputDecoration(labelText: "IF", hintText: "〇〇な時"),
                  onChanged: (text) {
                    addController.newIfText = text;
                  },
                ),
                TextField(
                  decoration:
                      InputDecoration(labelText: "THEN", hintText: "〇〇する"),
                  onChanged: (text) {
                    addController.newThenText = text;
                  },
                ),
                SizedBox(
                  height: 16,
                ),
                ElevatedButton(
                  onPressed: () async {
                    await addController.ifThenAdd();
                    Navigator.pop(context);
                  },
                  child: Text('追加する'),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
