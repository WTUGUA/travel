import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:traveltranslation/db/database_word.dart';
import 'package:traveltranslation/model/history.dart';
import 'package:traveltranslation/model/word.dart';
import 'package:traveltranslation/ocr/config/app_color.dart';
import 'package:traveltranslation/page/detail_page.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sqflite/sqflite.dart';

class SavePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SavePageState();
  }
}

class SavePageState extends State<SavePage> {
  DatabaseHelper_word databaseHelper = DatabaseHelper_word();
  List<Word> WordList;
  int count = 2;
  bool isnull = true;

  @override
  void initState() {
    updateListView();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width:375 , height: 667)..init(context);
    if (WordList == null) {
      WordList = List<Word>();
      updateListView();
     // isnull = false;
    }
    return new FutureBuilder<List<Word>>(
      future: updateListView(),
      builder: (BuildContext context, AsyncSnapshot<List<Word>> list) {
        if (list.hasData == false) {
          return Scaffold(
              appBar: AppBar(
                title: Text(
                  '已保存',
                  style: TextStyle(
                      color: AppColor.privacyText1Color, fontSize: 20.0),
                ),
              ),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Image(
                      image: AssetImage("images/img_empty_save.png"),
                    ),
                    Text(
                      '点击保存图标的',
                      style: TextStyle(
                          color: AppColor.LoginTextColor, fontSize: 13.0),
                    ),
                    Text(
                      '翻译内容会保存在这里',
                      style: TextStyle(
                          color: AppColor.LoginTextColor, fontSize: 13.0),
                    )
                  ],
                ),
              ));
        } else {
          return Scaffold(
              appBar: AppBar(
                title: Text(
                  '已保存',
                  style: TextStyle(
                      color: AppColor.privacyText1Color, fontSize: 20.0),
                ),
              ),
              body: isnull?Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Image(
                      width:ScreenUtil.instance.setWidth(160),
                      height:ScreenUtil.instance.setHeight(160),
                      image: AssetImage("images/img_empty_save.png"),
                    ),
                    Text(
                      '点击保存图标的',
                      style: TextStyle(
                          color: AppColor.LoginTextColor, fontSize: 13.0),
                    ),
                    Text(
                      '翻译内容会保存在这里',
                      style: TextStyle(
                          color: AppColor.LoginTextColor, fontSize: 13.0),
                    )
                  ],
                ),
              ):getWordListView());
        }
      },
    );
  }

  ListView getWordListView() {
    //TextStyle titleStyle = Theme.of(context).textTheme.subhead;
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Slidable(
          actionPane: SlidableDrawerActionPane(),
          actionExtentRatio: 0.25,
          child: GestureDetector(
              onTap: () {
                History his=new History(WordList[position].sourceWord, WordList[position].targetWord, 1);
                //跳转到翻译详情页
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => new DetailPage(
                          word: his,
                        )));
              },
              child: Container(
                  height: ScreenUtil.instance.setHeight(90.0),
                  color: AppColor.white,
                  padding: EdgeInsets.only(left: 15.0, top: 15.0, bottom: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: ScreenUtil.instance.setWidth(270),
                            child:Text(
                                WordList[position].sourceWord,
                                style: TextStyle(
                                    color: AppColor.privacyText1Color,
                                    fontSize: 20.0),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                            ),
                          ),
                          Container(
                            width: ScreenUtil.instance.setWidth(270),
                            child:Text(WordList[position].targetWord,
                                style: TextStyle(
                                    color: AppColor.LoginTextColor,
                                    fontSize: 20.0),
                                overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ) ,
                          )
                        ],
                      ),
                      IconButton(
                        // padding: EdgeInsets.only(left: 5.0),
                        onPressed: () {
                        },
                        icon: Image(
                          image: AssetImage("images/translate_icon_save_s.png"),
                        ),
                      ),
                    ],
                  ))),
          secondaryActions: <Widget>[
            IconSlideAction(
              caption: '删除',
              color: Colors.red,
              icon: Icons.delete,
              onTap: () {
                _delete(context, WordList[position]);
                updateListView();
              },
            ),
          ],
        );
      },
    );
  }

  // Returns the priority icon
  Icon getPriorityIcon(int priority) {
    switch (priority) {
      case 1:
        return Icon(Icons.play_arrow);
        break;
      case 2:
        return Icon(Icons.keyboard_arrow_right);
        break;

      default:
        return Icon(Icons.keyboard_arrow_right);
    }
  }

  void _delete(BuildContext context, Word Word) async {
    int result = await databaseHelper.deleteWord(Word.id);
    if (result != 0) {
      _showSnackBar(context, 'Word Deleted Successfully');
      updateListView();
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void navigateToDetail(Word Word, String title) async {
    History history1 = new History(Word.sourceWord, Word.targetWord, 1);
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return DetailPage(word: history1);
    }));

    if (result == true) {
      updateListView();
    }
  }

  Future<List<Word>> updateListView() async {
    List<Word> WordList = await databaseHelper.getWordList();
    if(WordList.length==0){
      setState(() {
        isnull = true;
        this.WordList = WordList;
        this.count = WordList.length;
      });
    }else {
      setState(() {
        isnull = false;
        this.WordList = WordList;
        this.count = WordList.length;
      });
    }
    return WordList;
  }
}
