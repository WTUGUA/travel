import 'package:flutter/material.dart';
import 'package:traveltranslation/ocr/components/vip/vip_bottom_component.dart';
import 'package:traveltranslation/ocr/components/vip/vip_bottomsheet_component.dart';
import 'package:traveltranslation/ocr/config/app_color.dart';
import 'package:traveltranslation/ocr/entity/ali_order_entity.dart';
import 'package:traveltranslation/ocr/entity/get_user_info_entity.dart';
import 'package:traveltranslation/ocr/entity/user_info_entity.dart';
import 'package:traveltranslation/ocr/entity/vipprice_entity.dart';
import 'package:traveltranslation/ocr/entity/wechat_order_entity.dart';
import 'package:traveltranslation/ocr/helpers/service_helpers.dart';
import 'package:traveltranslation/ocr/util/constans.dart';
import 'package:traveltranslation/ocr/util/navo_kv_utils.dart';
import 'package:traveltranslation/ocr/util/shared_preference.dart';
import 'package:traveltranslation/ocr/util/time_util.dart';
import 'package:traveltranslation/ocr/util/umeng_event_util.dart';
import 'package:traveltranslation/ocr/util/user_utils.dart';
import 'package:traveltranslation/ocr/widget/dialog/pay_success_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluwx/fluwx.dart' as fluwx;
import 'package:oktoast/oktoast.dart';
import 'package:tobias/tobias.dart' as tobias;

///安卓端vip界面
class VipAndroidComponent extends StatefulWidget {
  @override
  _VipAndroidComponentState createState() => _VipAndroidComponentState();
}

class BottomPayItem {
  bool isChecked = false;
  VipPriceData data;

  BottomPayItem(this.data, this.isChecked);
}

class _VipAndroidComponentState extends State<VipAndroidComponent> {
  var normalUser = [];
  var vipUser = [];

  Future _testInitNormalUser() async {
    normalUser.clear();
    vipUser.clear();

    var userEntityInfo = await SpUtils.getUserMap();
    var batchMax = await OnlineConfigUtils.getInstance()
        .getConfigParams(OnlineConfigUtils.batchPerNum);

    normalUser.add("每天${userEntityInfo.analysis.ocrMaxNum}次拍照翻译");
    normalUser.add("精准翻译每天${userEntityInfo.analysis.translateMaxNum}次");

    vipUser.add("不限制");
    vipUser.add("不限制");

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    EventUtil.beginPageView("vip_android");
    _initFluwx();
    _getVipPrices();
    _testInitNormalUser();
  }


  @override
  void dispose() {
    super.dispose();
    EventUtil.endPageView("vip_android");
  }

  var bottomList = <BottomPayItem>[];

  Future _getVipPrices() async {
    print("_getVipPrices（）");
    VipPriceEntity priceEntity = await ServiceApi.getVipPrices();
    print(priceEntity.data[0].type);
    //如果VIP内部价格有值
    if (priceEntity != null && priceEntity.data.isNotEmpty) {
      for (var item in priceEntity.data) {
        bottomList.add(new BottomPayItem(item, false));
      }
    }
    if (bottomList.length > 0) {
      bottomList[0].isChecked = true;
    }
    setState(() {});
  }

  Future _aliPay(VipPriceData data) async {
    if (data == null) return;
    var result = await tobias.isAliPayInstalled();
    if (!result) {
      showToast("支付宝客户端未安装", position: ToastPosition.center);
      return;
    }
    UserEntityInfo userInfo = await SpUtils.getUserMap();
    AliOrderEntity aliOrderEntity =
        await ServiceApi.getAliOrder(data.id, userInfo.sId);
    Map payResult = await tobias.pay(aliOrderEntity.data);
    if (int.parse(payResult["resultStatus"]) == 9000) {
      //如果支付成功则获取VIP信息
      showToast("支付成功code=${payResult["resultStatus"]}${payResult["memo"]}",
          duration: Duration(seconds: 50));
      String token = await SpUtils.getUserToken();
      GetUserInfoEntity userInfoEntity = await ServiceApi.getUserInfo(token);
      showDialog<Null>(
          context: context, //BuildContext对象
          barrierDismissible: false,
          builder: (BuildContext context) {
            return new PaySuccessDialog(
                TimeUtils.transUnixTime(userInfoEntity.res.viptime.toInt()));
          });
      UserDelegate.userStatus = UserStatus.VIP;
    } else {
      showToast("支付失败code=${payResult["resultStatus"]}${payResult["memo"]}",
          duration: Duration(seconds: 50));
    }
  }

  Future _wechatPay( VipPriceData data) async {
    if (data == null) return;
    var wxIsInstalled = await fluwx.isWeChatInstalled();
    if (!wxIsInstalled) {
      showToast("微信客户端未安装", position: ToastPosition.center);
      return;
    }
    //后台拉取微信支付
    UserEntityInfo userInfo = await SpUtils.getUserMap();
    WechatOrderEntity wechatOrderEntity =
        await ServiceApi.getWeChatOrder(data.id,userInfo.sId);
    if (wechatOrderEntity.code == 0) {
      WechatOrderData wxdata = wechatOrderEntity.data;
      print("微信支付数据：${wxdata.appid}");
      print("微信sign:"+wxdata.sign+" 微信partnerId:"+wxdata.partnerid+" 微信prepayid:"+wxdata.prepayid+" 微信package:"+wxdata.package);
      print(" 微信noncestr:"+wxdata.noncestr+" 微信timeStamp:"+wxdata.timestamp.toString());
      var result = await fluwx
          .payWithWeChat(
              appId: wxdata.appid,
              partnerId: wxdata.partnerid,
              prepayId: wxdata.prepayid,
              packageValue: wxdata.package,
              nonceStr: wxdata.noncestr,
              timeStamp: wxdata.timestamp,
              sign: wxdata.sign).then((data){
      });
      print("fluwx支付返回码："+result.toString());
    } else {
      showToast(wechatOrderEntity.msg);
    }
  }

  Future _getWexData() async{
    String token = await SpUtils.getUserToken();
    GetUserInfoEntity userInfoEntity = await ServiceApi.getUserInfo(token);
    showDialog<Null>(
        context: context, //BuildContext对象
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new PaySuccessDialog(
              TimeUtils.transUnixTime(userInfoEntity.res.viptime.toInt()));
        });
    UserDelegate.userStatus = UserStatus.VIP;
  }
  Future _initFluwx() async {
    await fluwx.registerWxApi(
        appId: "wx68e21543b9489301",
        doOnAndroid: true,
        doOnIOS: true,
//        enableMTA: false
    );
    var result = await fluwx.isWeChatInstalled();
    print("is installed $result");
    //监听支付回调
    fluwx.responseFromPayment.listen((data) {
      if(data.errCode == 0){
        _getWexData();
      }
      showToast("支付结果返回码=${data.errCode}");
    });
  }

  Widget _buildOcrTag(int index, String text, bool isVip) {
    return Container(
      color: index % 2 == 0 ? Colors.white : Color(0xFFFFFBF5),
      alignment: Alignment.center,
      height: ScreenUtil.instance.setHeight(82),
      width: ScreenUtil.instance.setWidth(172),
      child: Text(
        text,
        style: TextStyle(
            fontSize: 15, color: isVip ? Color(0xFFA87C2E) : Color(0xFF505050)),
      ),
    );
  }

  List<Widget> _buildGradTags() {
    var widgets = <Widget>[];
    for (int i = 0; i < normalUser.length; i++) {
      widgets.add(_buildOcrTag(i, normalUser[i], false));
      widgets.add(_buildOcrTag(i, vipUser[i], true));
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    return OKToast(
        child: Scaffold(
            backgroundColor: Color(0xFF606060),
            appBar: AppBar(
              title: Text("VIP会员"),
              centerTitle: true,
            ),
            body: Builder(
              builder: (context) => Column(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          Image.asset("images/icon_vip_banner.png"),
                          _buildTitle("尊贵会员"),
                          _buildBottomPay(),
                          _buildTitle("特权对比"),
                          _buildPrivateContent(),
                        ],
                      ),
                    ),
                  ),
                  VipBottomWidget(
                    onTapDelegate: () {
                      EventUtil.onEvent(EventUtil.vipPayClick);
                      showBottomSheet(
                          elevation: 12.0,
                          context: context,
                          builder: (context) => Container(
                              height: ScreenUtil.instance.setHeight(586),
                              padding: EdgeInsets.all(12.0),
                              child: PayChoose(
                                onPay: (int value) {
                                  switch (value) {
                                    case WechatPay:
                                      _wechatPay(getSelectedData());
                                      break;
                                    case AliPay:
                                      _aliPay(getSelectedData());
                                      break;
                                  }
                                },
                              )));
                    },
                  ),
                ],
              ),
            )));
  }

  VipPriceData getSelectedData() {
    for (var item in bottomList) {
      if (item.isChecked) {
        return item.data;
      }
    }
    return null;
  }

  Widget _buildBottomPay() {
    return Container(
      margin: EdgeInsets.only(bottom: 13.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[...getBottomItem()],
      ),
    );
  }

  List<Widget> getBottomItem() {
    var list = <Widget>[];
    if (bottomList != null) {
      for (int i = 0; i < bottomList.length; i++) {
        list.add(_buildBottomItem(i));
      }
    }
    return list;
  }

  Widget _buildBottomItem(int i) {
    return Container(
      width: ScreenUtil.instance.setWidth(210),
      child: GestureDetector(
        onTap: () {
          for (int j = 0; j < bottomList.length; j++) {
            bottomList[j].isChecked = false;
          }
          bottomList[i].isChecked = true;

          switch(i){
            case 0:
              EventUtil.onEvent(EventUtil.oneMonthClick);
              break;
            case 1:
              EventUtil.onEvent(EventUtil.threeMonthClick);
              break;
            case 2:
              EventUtil.onEvent(EventUtil.lifetimeClick);
              break;

          }

          setState(() {});
        },
        child: Stack(
          children: <Widget>[
            bottomList[i].isChecked
                ? Image.asset("images/icon_vip_month.png")
                : Image.asset("images/icon_vip_month_un.png"),
            Center(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    bottomList[i].data.type,
                    style: TextStyle(fontSize: 15, color: Color(0xFF3F3C2C)),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: <Widget>[
                      Text("￥", style: TextStyle(color: AppColor.vipTextColor)),
                      Text(
                        bottomList[i].data.price,
                        style: TextStyle(
                            fontSize: 40, color: AppColor.vipTextColor),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: <Widget>[
                      Text(
                        "￥" + bottomList[i].data.originPrice,
                        style: TextStyle(
                            fontSize: 15,
                            color: AppColor.deleteTextColor,
                            decoration: TextDecoration.lineThrough,
                            decorationColor: AppColor.deleteTextColor),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(String content) {
    return Container(
      margin: EdgeInsets.only(left: 15.0, top: 15.0, bottom: 15.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            "images/icon_vip_chip.png",
            width: 6,
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            content,
            style: TextStyle(fontSize: 19, color: Colors.white),
          )
        ],
      ),
    );
  }

  Widget _buildPrivateContent() {
    return Container(
      margin: EdgeInsets.only(bottom: 20.0),
      alignment: Alignment.center,

      width: ScreenUtil.instance.setWidth(690),
      height: ScreenUtil.instance.setHeight(600),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(12.0)),
      child: Column(
        children: <Widget>[
          Container(
            height: ScreenUtil.instance.setHeight(100),
            padding: EdgeInsets.only(top: 13.0, bottom: 13.0),
            decoration: BoxDecoration(
                color: Color(0xFFFFF4E5),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.0),
                    topRight: Radius.circular(12.0))),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text(
                  "普通用户",
                  style: TextStyle(color: Color(0xFF686868), fontSize: 17),
                ),
                Container(
                  child: Row(
                    children: <Widget>[
                      Text(
                        "VIP会员",
                        style:
                            TextStyle(color: Color(0xFFA87C2E), fontSize: 17),
                      ),
                      Image.asset(
                        "images/icon_vip2.png",
                        width: 25.0,
                        height: 25.0,
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: GridView(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 3.4,
                  crossAxisSpacing: 0.0,
                  mainAxisSpacing: 0.0,
                  crossAxisCount: 2),
              children: <Widget>[..._buildGradTags()],
            ),
            flex: 1,
          ),
          Container(
            height: ScreenUtil.instance.setHeight(100),
            padding: EdgeInsets.only(
              top: 13.0,
              bottom: 13.0,
            ),
            decoration: BoxDecoration(
                color: Color(0xFFFFF4E5),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(12.0),
                    bottomRight: Radius.circular(12.0))),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  child: Row(
                    children: <Widget>[
                      Text(
                        "后续新增功能仍开放",
                        style:
                            TextStyle(color: Color(0xFFA87C2E), fontSize: 15),
                      ),
                      SizedBox(
                        width: 19,
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
