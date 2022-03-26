import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:tetris_mobile_app/view/singlePlay.dart';
import 'package:tetris_mobile_app/view/top.dart';
import '../domain/state/tetrisData.dart';

//main.dartはルーティングのみ実装
void main() => runApp(
  ChangeNotifierProvider(
    create: (context) => Data(),
    child: MyApp(),
  ),
);

// MyApp： 自分で作成したWidget
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //常に画面を縦向きにする
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MaterialApp(
      home: top(),
      routes: <String, WidgetBuilder>{
        '/top': (BuildContext context) => top(), // 最初のページ
        '/singlePlay': (BuildContext context) => singlePlay() // 次のページ
      }
    );
  }
}
//
// class MainPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Mainページ"),
//       ),
//       body: Container(
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               Text("Main"),
//               RaisedButton( // 立体的なボタン
//                 onPressed: () => Navigator.of(context).pushNamed("/singlePlay"),  // 次の画面を乗せる
//                 child: Text("singlePlay"),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//tooyama
