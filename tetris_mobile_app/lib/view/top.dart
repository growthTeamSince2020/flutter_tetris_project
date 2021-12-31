import 'package:flutter/material.dart';

class top extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     // backgroundColor: Color.fromRGBO(229,204,255,30),
      body: Container(
      decoration: const BoxDecoration(
        image: DecorationImage(image: AssetImage('assets/images/white_wood.jpg'),fit: BoxFit.fill,)
      ),
        child: Center(
          
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,

            children: <Widget>[
              ElevatedButton(
                // 立体的なボタン
                onPressed: () =>
                    Navigator.of(context).pushNamed("/singlePlay"), // 次の画面を乗せる
                  style: ElevatedButton.styleFrom(
                    primary: Colors.transparent,
                    elevation: 0,
                    onPrimary: Colors.black,
                    side: BorderSide(
                      color: Colors.black, //枠線!
                      width: 3, //枠線！
                    ),
                ),
                child: Text("シングルプレイ",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
              ),
              ElevatedButton(
                // 立体的なボタン
                onPressed: () =>
                    Navigator.of(context).pushNamed("/"), // 次の画面を乗せる
                style: ElevatedButton.styleFrom(
                  primary: Colors.transparent,
                  elevation: 0,
                  onPrimary: Colors.black,
                  side: BorderSide(
                    color: Colors.black, //枠線!
                    width: 3, //枠線！
                  ),
                ),
                child: Text("ログイン",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
              ),
              ElevatedButton(
                // 立体的なボタン
                onPressed: () =>
                    Navigator.of(context).pushNamed("/"), // 次の画面を乗せる
                style: ElevatedButton.styleFrom(
                  primary: Colors.transparent,
                  elevation: 0,
                  onPrimary: Colors.black,
                  side: BorderSide(
                    color: Colors.black, //枠線!
                    width: 3, //枠線！
                  ),
                ),
                child: Text("会員登録",
                  style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
