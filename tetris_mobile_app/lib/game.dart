import 'dart:async';
// import 'dart:html';
import 'package:flutter/material.dart';
import 'block.dart';
import 'dart:math';
import 'sub_block.dart';

const BLOCKS_X = 10;// ゲームの幅

//LANDED:ブロックが地面にあたった時
//LANDED_BLOCK:ブロックが別のブロックに着地した時
//HIT_WALL:ブロックが壁にあたった時
//HIT_BLOCK:ブロックが別のブロックにあたった時
enum Collision { LANDED, LANDED_BLOCK, HIT_WALL, HIT_BLOCK, NONE}
const BLOCKS_Y = 20;// ゲームの高さ
const GAME_AREA_BORDER_WIDTH = 2.0; // ゲームエリアの枠線の幅
// const REFRESH_RATE = 1; //ゲーム速度
const REFRESH_RATE = 500; //ゲーム速度
const SUB_BLOCK_EDGE_WIDTH = 2.0;


//左ゲーム画面のフィールドを表示
class Game extends StatefulWidget{
  //キーを設定する。
  Game ({Key key}):super(key:key);

  @override
  State createState() => GameState();
}

class GameState extends State{
  double subBlockWidth;
  // Duration duration = Duration(seconds: REFRESH_RATE);//ゲームの速度
  Duration duration = Duration(milliseconds: REFRESH_RATE);//ゲームの速度
  GlobalKey _keyGameArea = GlobalKey();
  //入力操作の変数
  BlockMovement action;
  Block block;
  Timer timer;
  bool isPlaying = false;//ゲーム中のフラグ
  List<SubBlock> oldSubBlocks;//止まったブロックを保存

  //新しいテトリミノをランダムで作成
  Block getNewBlock(){
    print("新しいテトリミノをランダムで作成");
    int blockType = Random().nextInt(7);
    print(blockType);
    int orientationIndex = Random().nextInt(4);

    switch (blockType){
      case 0:
        return IBlock(orientationIndex);
      case 1:
        return JBlock(orientationIndex);
      case 2:
        return LBlock(orientationIndex);
      case 3:
        return OBlock(orientationIndex);
      case 4:
        return TBlock(orientationIndex);
      case 5:
        return SBlock(orientationIndex);
      case 6:
        return ZBlock(orientationIndex);
      default:
        return null;
    }
  }
  // ゲームスタート準備
  void startGame(){
    print("ゲーム開始");
    isPlaying = true;
    oldSubBlocks = <SubBlock>[];
    // GlobalKeyを使い、ゲームエリアの現在のcontextにアクセス
    // findRenderObjectでレンダリングされたゲームエリアのオブジェクトを取得できる
    RenderBox renderBoxGame = _keyGameArea.currentContext.findRenderObject();

    // 利用するゲームエリアは、ゲームエリアの枠線の幅を含まない
    subBlockWidth =(renderBoxGame.size.width -GAME_AREA_BORDER_WIDTH * 2) / BLOCKS_X;
    block = getNewBlock();
    //300ミリ秒毎にonPlay(コールバック)を呼び出す
    timer = Timer.periodic(duration, onPlay);
  }
  //ゲーム停止
  void endGame(){
    print("ゲーム終了");
    isPlaying = false;
    timer.cancel();
  }

  //timer引数は必須だが別に使わなくてもいい。
  void onPlay(Timer timer){
    var status = Collision.NONE;
    //flutterがブロックの位置と状態が変化したことを認識するため、setStateを呼び出す
    setState(() {
      //actionがnullでないときユーザの操作を実行
      if(action != null){
        if(!checkOnEdge(action)){
          block.move(action);
        }
      }
      //他のブロックに当たったらそのアクションを戻す。
      for(var oldSubBlock in oldSubBlocks){
        for(var subBlock in block.subBlocks){
          var x = block.x + subBlock.x;
          var y = block.y + subBlock.y;
          if(x == oldSubBlock.x && y == oldSubBlock.y){
            switch(action){
              case BlockMovement.LEFT:
                block.move(BlockMovement.RIGHT);
                break;
              case BlockMovement.RIGHT:
                block.move(BlockMovement.LEFT);
                break;
              case BlockMovement.ROTATE_CLOCKWISE:
                block.move(BlockMovement.ROTATE_COUNTER_CLOCKWISE);
                break;
              default:
                break;
            }
          }
        }
      }

      //ブロックが地面についたか判定
      if(!checkAtBottom()){
        if(!checkAboveBlock()){
          //ブロックを下に移動させる
          block.move(BlockMovement.DOWN);
        }else{
          status = Collision.LANDED_BLOCK;
        }
      } else{
        status = Collision.LANDED;
      }
      if(status == Collision.LANDED || status == Collision.LANDED_BLOCK){
        // 地面についたブロックを保存
        block.subBlocks.forEach((subBlock){
          subBlock.x += block.x;
          subBlock.y += block.y;
          oldSubBlocks.add(subBlock);
        });
        block = getNewBlock();
      }
      //実行されたユーザ操作を無効化（クリアする）
      action = null;

    });
  }
  
  //地面にブロックが着地したか判定
  bool checkAtBottom(){
    return  block.y + block.height == BLOCKS_Y;
  }
  
  //他のブロックに着地したか判定
  bool checkAboveBlock(){
    for(var oldSubBlock in oldSubBlocks){
      for(var subBlock in block.subBlocks){
        var x = block.x + subBlock.x;
        var y = block.y + subBlock.y;
        if(x == oldSubBlock.x && y + 1 == oldSubBlock.y){
          return true;
        }
      }
    }
    return false;
  }
  //左右の壁当たり判定
  bool checkOnEdge(BlockMovement action){
    return (action == BlockMovement.LEFT && block.x <= 0)||
        (action == BlockMovement.RIGHT && block.x + block.width >= BLOCKS_X);
  }

  Widget getPositionedSquareContainer(Color color, int x, int y){
    print("color: $color,x: $x,y: $y");

    return Positioned(
      left: x * subBlockWidth,
      top: y * subBlockWidth,
      width: subBlockWidth - SUB_BLOCK_EDGE_WIDTH,
      height: subBlockWidth - SUB_BLOCK_EDGE_WIDTH,
      child: Container(color: color,),
    );
  }
  // ブロックを描画する
  // ignore: missing_return
  Widget drawBlocks(){
    // 初期化
    if(block == null) return null;
    // サブブロックは、配置可能なWidgetのリストとして宣言する
    print("block : $block");
    List<Widget> subBlocks = [];
    // ブロックを作る＝各サブブロックをループし、それぞれをコンテナに変換する
    block.subBlocks.forEach((subBlock){
      subBlocks.add(
          getPositionedSquareContainer(
            //絶対座標にする（サブブロックの座標はブロックの相対位置なのでそれぞれ足す）
              subBlock.color, subBlock.x + block.x, subBlock.y + block.y));
      return Stack(children: subBlocks,);
    });
    oldSubBlocks?.forEach((oldSubBlock) {
      subBlocks.add(
          getPositionedSquareContainer(
            //絶対座標にする（サブブロックの座標はブロックの相対位置なのでそれぞれ足す）
              oldSubBlock.color, oldSubBlock.x, oldSubBlock.y));
      return Stack(children: subBlocks,);
    });
    return Stack(children: subBlocks,);
  }

  @override
  Widget build(BuildContext context){
    return GestureDetector(//GestureDetectorはタッチ/ボタン入力検出用途で利用するための関数
      onHorizontalDragUpdate: (details){
        if(details.delta.dx > 0){//delta 前回からの変化量
          action = BlockMovement.RIGHT;
        } else{
          action = BlockMovement.LEFT;
        }
      },
        onTap: (){
          action = BlockMovement.ROTATE_CLOCKWISE;
        },
      //AspectRatioを使うことでwidgetのアスペクト比を一定に保つことができる
       child: AspectRatio(
        aspectRatio: BLOCKS_X / BLOCKS_Y,//高さに対する幅の比率
      // child  単一のウィジットをとります。 Containerは子のサイズやpadding,marginなどの設定ができる。
        child: Container(
          key: _keyGameArea,// ゲームエリアの鍵
          //BoxDecorationのクラスには、ボックスを描画するためのさまざまな方法を提供します。
          decoration: BoxDecoration(
            color: Colors.indigo[800],
            border:  Border.all(
              width: GAME_AREA_BORDER_WIDTH,
              color: Colors.white
            ),
           //すべての範囲の border を作るクラス　radiusは半径の意 circularは円形の意
           borderRadius: BorderRadius.all(Radius.circular(10.0))//すべての範囲の border を作るクラス　radiusは半径の意
          ),
          child: drawBlocks(),
        ),
      )
    );
  }
}