import 'package:flutter/material.dart';

class top extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(229,204,255,30),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,

            children: <Widget>[
        //   Image(
        //     width: 200,
        //     image:AssetImage("images/karititle.png"),
        //   color: Color(0xFF3A5A98),
        // ),
              ElevatedButton(
                // 立体的なボタン
                onPressed: () =>
                    Navigator.of(context).pushNamed("/singlePlay"), // 次の画面を乗せる
                child: Text("singlePlay"),
              ),
              ElevatedButton(
                // 立体的なボタン
                onPressed: () =>
                    Navigator.of(context).pushNamed("/"), // 次の画面を乗せる
                child: Text("VS NPC"),
              ),
              ElevatedButton(
                // 立体的なボタン
                onPressed: () =>
                    Navigator.of(context).pushNamed("/"), // 次の画面を乗せる
                child: Text("login"),
              ),
              ElevatedButton(
                // 立体的なボタン
                onPressed: () =>
                    Navigator.of(context).pushNamed("/"), // 次の画面を乗せる
                child: Text("Member registration"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
