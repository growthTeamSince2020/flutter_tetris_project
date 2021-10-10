import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../domain/service/common/tetrisLogic/next_block.dart';
import '../domain/service/common/tetrisLogic/score_bar.dart';
import '../domain/service/singlePlay/game.dart';
import '../domain/state/tetrisData.dart';

// StatefulWidgetはbuildメソッドを持たず、createStateメソッドを持ち、これがStateクラスを返す
class singlePlay extends StatefulWidget {
  //　createState()ビルド後に呼ばれるメソッドで必須
  // 　型はState
  @override
  State createState() => _TetrisState();
}

// 「_」をつけるとプライベートになる
class _TetrisState extends State {
  // Gameエリアのウィジェットにアクセスするためグローバルキーを使う
  // ※GameStateをパブリッククラスにし、keyを受け入れるコンストラクタを作っておくこと。
  GlobalKey<GameState> _keyGame = GlobalKey();
  // build()：MaterialAppで画面のテーマ等を設定できる
  @override
  Widget build(BuildContext context) {
    // Scaffold： マテリアルデザイン用Widget
    return Scaffold(
      //AppBar： アプリケーションバー用Widget
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            if (Provider.of<Data>(context, listen: false).isPlaying) {
              _keyGame.currentState.endGame();
              Navigator.of(context).pop();
            } else {
              Navigator.of(context).pop();
            }
          },
        ),
        //上タイトル
        title: Text('Single Play'),
        // 左側のアイコン
        centerTitle: true,
        backgroundColor: Colors.purple,
      ),
      body: SafeArea(
        //SafeArea を使用すると OS に関わらず適切な領域にウィジェットを収めてくれます
        //ボディ部の画面
        child: Column(
          children: [
            ScoreBar(), //スコア表示
            Expanded(
              //残りの部分
              child: Center(
                //垂直水平方向に中央寄せ
                child: Row(
                  //縦に分割したいときはRowを使う
                  crossAxisAlignment: CrossAxisAlignment.start,
                  //垂直方法の開始位置にそろえる 水平ならmainAxisAlignment
                  children: [
                    //残りの部分を分割するので、Flexibleを使う
                    Flexible(
                      //左画面
                      flex: 3,
                      child: Padding(
                          padding: EdgeInsets.fromLTRB(10.0, 10.0, 5.0, 10.0),
                          child: Game(
                              key:
                                  _keyGame)), //ゲームwidgetに置き換える。グローバルキーをゲームのコンストラクターに渡す。
                    ),
                    Flexible(
                      //右画面
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(5.0, 10.0, 10.0, 10.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            NextBlock(),
                            SizedBox(
                              height: 30,
                            ), //余白
                            ElevatedButton(
                              //RaisedButtonが非推奨なのでElevatedButton
                              child: Text(
                                Provider.of<Data>(context).isPlaying
                                    ? 'Retry'
                                    : 'Start',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey[200],
                                ),
                              ),
                              onPressed: () {
                                Provider.of<Data>(context, listen: false)
                                        .isPlaying
                                    ? _keyGame.currentState.endGame()
                                    : _keyGame.currentState.startGame();
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.deepPurpleAccent, //枠というか全体の背景色
    );
  }
}
