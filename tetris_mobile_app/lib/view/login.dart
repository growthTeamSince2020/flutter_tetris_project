import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tetris_mobile_app/view/top.dart';

// StatefulWidgetはbuildメソッドを持たず、createStateメソッドを持ち、これがStateクラスを返す
class login extends StatefulWidget {
  //　createState()ビルド後に呼ばれるメソッドで必須
  // 　型はState
  @override
  State createState() => _LoginState();
}

// 「_」をつけるとプライベートになる
class _LoginState extends State<login> {
  // メッセージ表示用
  String infoText = '';
  // 入力したメールアドレス
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField( /* --- 省略 --- */ ),
              TextFormField( /* --- 省略 --- */ ),
              Container( /* --- 省略 --- */ ),
              Container( /* --- 省略 --- */ ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                // ログイン登録ボタン
                child: OutlinedButton(
                  child: Text('ログイン'),
                  onPressed: () async {
                    try {
                      // メール/パスワードでログイン
                      final FirebaseAuth auth = FirebaseAuth.instance;
                      await auth.signInWithEmailAndPassword(
                        email: email,
                        password: password,
                      );
                      // ログインに成功した場合
                      // チャット画面に遷移＋ログイン画面を破棄
                      await Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) {
                          return top();
                        }),
                      );
                    } catch (e) {
                      // ログインに失敗した場合
                      setState(() {
                        infoText = "ログインに失敗しました：${e.toString()}";
                      });
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
