import 'package:flutter/material.dart';
import 'package:if_then_app/controllers/login_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:if_then_app/controllers/random_ifthen_controller.dart';
import 'package:if_then_app/views/account_page/login_page.dart';
import 'package:if_then_app/views/gacha_page/present_page.dart';

class IfThenMixerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('\u{1F973}  イフゼンガチャ  \u{1F973}'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () async {
              await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return SimpleDialog(
                    children: <Widget>[
                      Center(
                        child: SimpleDialogOption(
                          child: const Text('ログアウト'),
                          onPressed: () async {
                            await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Consumer(
                                    builder: (context, watch, child) {
                                  final logOutController = watch(LogInProvider);
                                  return AlertDialog(
                                    title: Text('ログアウトしますか？'),
                                    actions: <Widget>[
                                      ElevatedButton(
                                        child: Text('OK'),
                                        onPressed: () async {
                                          //Googleアカウントのログアウトができた。メールログインの状態でこのメソッド呼んだらエラー出ちゃうかも
                                          logOutController.logout();
                                          await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => LoginPage(),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  );
                                });
                              },
                            );
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          )
        ],
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('images/gachagacha.png'),
            Consumer(builder: (context, watch, child) {
              final randomController = watch(randomProvider);
              return ElevatedButton(
                child: Text('回す'),
                onPressed: () async {
                  await randomController.checkTodayTurnGachaTimes();
                  final canTurn = watch(randomProvider).canTurn;
                  if (canTurn) {
                    print('まだ回せるよ');
                    randomController.countTurningGacha();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PresentPage(),
                        fullscreenDialog: true,
                      ),
                    );
                  } else {
                    print('もう回せないよ');
                    print(canTurn);
                    await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(
                              'ガチャを回せるのは\n1日5回までだよ\u{1F60C}\nまた明日回してね\u{1F365}'),
                          actions: <Widget>[
                            ElevatedButton(
                              child: Text('うん'),
                              onPressed: () async {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
              );
            })
          ],
        ),
      ),
      // floatingActionButton: Consumer(builder: (context, watch, child) {
      //   final testGachaCheck = watch(randomProvider);
      //   return FloatingActionButton(
      //     onPressed: () {
      //       print(testGachaCheck.checkTodayTurnGachaTimes());
      //     },
      //   );
      // }),
    );
  }
}