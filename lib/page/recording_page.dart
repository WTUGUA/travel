import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:traveltranslation/db/database_history.dart';
import 'package:traveltranslation/db/database_word.dart';
import 'package:traveltranslation/model/history.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:traveltranslation/model/word.dart';
import 'package:traveltranslation/ocr/config/app_color.dart';
import 'package:traveltranslation/page/detail_page.dart';
import 'package:traveltranslation/utils/event_bus.dart';

class RecordingPage extends StatefulWidget {
  RecordingPage(Key key) : super(key: key);
  @override
  RecordingPageState createState() => RecordingPageState();
}

class RecordingPageState extends State<RecordingPage> {
  static DatabaseHelper_history databaseHelper = DatabaseHelper_history();
  static DatabaseHelper_word databaseHelper_word = DatabaseHelper_word();
  List<History> items;
  int count = 0;
  bool isnull=true;
  var _eventBusOn;
  @override
  void initState() {
    updateListView();
    this._eventBusOn = eventBus.on<ListEvent>().listen((event){
      print(event);
      updateListView();
    });
    super.initState();
  }
  @override
  void dispose() {
    this._eventBusOn.cancel();//取消事件监听
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width:375 , height: 667)..init(context);
    if (items == null) {
      items = List<History>();
      updateListView();
    }
    return isnull? Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
           height: ScreenUtil.instance.setHeight(45),
          ),
          Image(
            width:ScreenUtil.instance.setHeight(160),
            height:ScreenUtil.instance.setHeight(160),
            image: AssetImage("images/img_empty_history.png"),
          ),
          Text(
            '翻译历史',
            style: TextStyle(
                color: AppColor.LoginTextColor, fontSize: 13.0),
          ),
          Text(
            '这里还是空的哦',
            style: TextStyle(
                color: AppColor.LoginTextColor, fontSize: 13.0),
          )
        ],
      ),
    ):Expanded(
      child:
      ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: count,
        itemBuilder: (context, index) {
          return Slidable(
            actionPane: SlidableDrawerActionPane(),
            actionExtentRatio: 0.25,
            child: _displayList(index),
            secondaryActions: <Widget>[
              IconSlideAction(
                caption: '删除',
                color: Colors.red,
                icon: Icons.delete,
                onTap: () {
                  _delete(context, items[index]);
                  updateListView();
                },
              ),
            ],
          );
        },
      ),
    );
  }

  void _delete(BuildContext context, History history) async {
    int result = await databaseHelper.deleteHistory(history.id);
    if (result != 0) {
      _showSnackBar(context, '翻译历史删除成功');
      updateListView();
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  Widget _displayList(int index) {
    return GestureDetector(
      onTap: () {
        //跳转到翻译详情页
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) => new DetailPage(
                      word: items[index],
                    )));
      },
      child: Container(
        height: ScreenUtil.instance.setHeight(80.0),
        color: AppColor.white,
        child: Container(
          padding: EdgeInsets.only(left: 15.0, top: 15.0, bottom: 15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[_Flexible(index), _collection(index)],
          ),
        ),
      ),
    );
  }

  Widget _Flexible(int index) {
    return Flexible(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Container(
            width:ScreenUtil.instance.setWidth(270),
            child: Text(
              items[index].hisSource,
              style:
                  TextStyle(color: AppColor.privacyText1Color, fontSize: 15.0),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Container(
            width: ScreenUtil.instance.setWidth(270),
            child: Text(
              items[index].hisTar,
              style: TextStyle(color: AppColor.LoginTextColor, fontSize: 15.0),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          )
        ],
      ),
    );
  }

  Widget _collection(int index) {
    return IconButton(
      onPressed: () {
        //是否加入收藏
        if (items[index].collection == 1) {
          final Future<Database> dbFuture =
              databaseHelper_word.initializeDatabase();
          Future<List<Word>> WordListFuture = databaseHelper_word.getWordList();
          //根据history值查询WordListFuture中出现的第一个数据
          dbFuture.then((database) {
            WordListFuture.then((wordList) {
              for (int i = 0; i < wordList.length; i++) {
                if (wordList[i].sourceWord == items[index].hisSource) {
                  databaseHelper_word.deleteWord(wordList[i].id);
                  setState(() {
                    items[index].collection = 0;
                  });
                  databaseHelper.updateHistory(items[index]);
                  print(items[index].collection);
                }
              }
            });
          });
        } else {
          //加入收藏
          SaveToWord(items[index].hisSource, items[index].hisTar);
          items[index].collection = 1;
          setState(() {
            items[index].collection = 1;
          });
          databaseHelper.updateHistory(items[index]);
          print(items[index].collection);
        }
      },
      icon: items[index].collection == 1
          ? Image.asset('images/translate_icon_save_s.png')
          : Image.asset('images/translate_icon_save_n.png'),
    );
  }

  Future<List<History>> updateListView() async{
    List<History> items = await databaseHelper.getHistoryList();
    if(items.length==0){
      setState(() {
        isnull = true;
        this.items = items;
        this.count = items.length;
      });
    }else {
      setState(() {
        isnull = false;
        this.items = items;
        this.count = items.length;
      });
    }
    return items;
  }

  void SaveToWord(String source, String traget) {
    Word word = new Word(source, traget);
    databaseHelper_word.insertWord(word);
  }
}
