import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:oktoast/oktoast.dart';
import 'package:traveltranslation/ocr/components/vip/vip_bottom_component.dart';
import 'package:traveltranslation/ocr/config/app_color.dart';
import 'package:traveltranslation/ocr/config/application.dart';
import 'package:traveltranslation/ocr/config/routes.dart';
import 'package:traveltranslation/ocr/helpers/service_helpers.dart';
import 'package:traveltranslation/ocr/util/ipa_utils.dart';
import 'package:traveltranslation/ocr/util/navo_kv_utils.dart';
import 'package:traveltranslation/ocr/util/shared_preference.dart';
import 'package:traveltranslation/ocr/util/umeng_event_util.dart';
import 'package:traveltranslation/ocr/util/user_utils.dart';

import 'consumablestore.dart';
//IOS支付界面
const bool kAutoConsume = true;
const String _kConsumableId = 'jiangji.op.Subscription.1month';
const List<String> _kProductIds = <String>[
  _kConsumableId,
  'jiangji.op.Subscription.3month',
  'jiangji.op.Subscription.12month'
];

class IosBottomPayItem {
  bool isChecked = false;
  ProductDetails data;

  IosBottomPayItem(this.data, this.isChecked);
}

class VipIosComponent extends StatefulWidget {
  @override
  _VipIosComponentState createState() => _VipIosComponentState();
}

class _VipIosComponentState extends State<VipIosComponent> {
  final InAppPurchaseConnection _connection = InAppPurchaseConnection.instance;

  StreamSubscription<List<PurchaseDetails>> _subscription;
  List<String> _notFoundIds = [];
  List<ProductDetails> _products = [];
  List<PurchaseDetails> _purchases = [];
  List<String> _consumables = [];
  bool _isAvailable = false;
  bool _purchasePending = false;
  bool _loading = true;
  String _queryProductError;
  var bottomList = <IosBottomPayItem>[];
  var normalUser = [];
  var vipUser = [];

  Future _testInitNormalUser() async {
    normalUser.clear();
    vipUser.clear();

    var userEntityInfo = await SpUtils.getUserMap();
    var batchMax = await OnlineConfigUtils.getInstance()
        .getConfigParams(OnlineConfigUtils.batchPerNum);

    normalUser.add("每天${userEntityInfo.analysis.ocrMaxNum}次拍照识字");
    normalUser.add("每天${userEntityInfo.analysis.batchMaxNum}次批量处理");

    normalUser.add("每次不超过$batchMax张");
    normalUser.add("精准翻译每天${userEntityInfo.analysis.translateMaxNum}次");

    vipUser.add("不限制");
    vipUser.add("不限制");
    vipUser.add("不限制");
    vipUser.add("不限制");

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    Stream purchaseUpdated =
        InAppPurchaseConnection.instance.purchaseUpdatedStream;
    _subscription = purchaseUpdated.listen((purchaseDetailsList) {
      print("支付updated回掉");
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      _subscription.cancel();
    }, onError: (error) {
      // handle error here.
    });

    if (IpaUtils.bottomList.isNotEmpty) {
      _loading = false;
      if (mounted) {
        setState(() {
          bottomList.clear();
          bottomList.addAll(IpaUtils.bottomList);
          bottomList[0].isChecked = true;
        });
      }
    } else {
      initStoreInfo();
    }
    _testInitNormalUser();
  }

  void showPendingUI() {
    setState(() {
      _purchasePending = true;
    });
  }

  void handleError(IAPError error) {
    setState(() {
      _purchasePending = false;
    });
  }

  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) {
    // IMPORTANT!! Always verify a purchase before delivering the product.
    // For the purpose of an example, we directly return true.
    return Future<bool>.value(true);
  }

  void _handleInvalidPurchase(PurchaseDetails purchaseDetails) {
    // handle invalid purchase here if  _verifyPurchase` failed.
  }

  void deliverProduct(PurchaseDetails purchaseDetails) async {
    // IMPORTANT!! Always verify a purchase purchase details before delivering the product.
    if (purchaseDetails.productID == _kConsumableId) {
      await ConsumableStore.save(purchaseDetails.purchaseID);
      List<String> consumables = await ConsumableStore.load();
      setState(() {
        _purchasePending = false;
        _consumables = consumables;
      });
    } else {
      setState(() {
        _purchases.add(purchaseDetails);
        _purchasePending = false;
      });
    }
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        print("pending");
        showPendingUI();
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          print("error");
          handleError(purchaseDetails.error);
        } else if (purchaseDetails.status == PurchaseStatus.purchased) {
          bool valid = await _verifyPurchase(purchaseDetails);
          var token = await SpUtils.getUserToken();
          //绑定初始商品id
          if (purchaseDetails.skPaymentTransaction != null) {
            if (purchaseDetails.skPaymentTransaction.originalTransaction !=
                null) {
              await ServiceApi.setOriginalTransactionId(
                  token,
                  purchaseDetails.skPaymentTransaction.originalTransaction
                      .transactionIdentifier);
            }
          }
          print("判断支付是否有效$valid");
          if (valid) {
            deliverProduct(purchaseDetails);
          } else {
            _handleInvalidPurchase(purchaseDetails);
          }
        }

        InAppPurchaseConnection.instance.completePurchase(purchaseDetails);
      }
    });
  }

  Future<void> initStoreInfo() async {
    print("initStoreInfo");
    final bool isAvailable = await _connection.isAvailable();
    if (!isAvailable) {
      setState(() {
        _isAvailable = isAvailable;
        _products = [];
        _purchases = [];
        _notFoundIds = [];
        _consumables = [];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    ProductDetailsResponse productDetailResponse =
    await _connection.queryProductDetails(_kProductIds.toSet());

    print(
        "productDetailResponse=${productDetailResponse.productDetails.length}");
    print("productDetailResponse=${productDetailResponse.error != null}");
    if (productDetailResponse.error != null) {
      print("diaoyong setstate");
      setState(() {
        _queryProductError = productDetailResponse.error.message;

        _isAvailable = isAvailable;
        _products = productDetailResponse.productDetails;

        _purchases = [];
        _notFoundIds = productDetailResponse.notFoundIDs;
        _consumables = [];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    if (productDetailResponse.productDetails.isEmpty) {
      setState(() {
        _queryProductError = null;
        _isAvailable = isAvailable;
        _products = productDetailResponse.productDetails;
        _purchases = [];
        _notFoundIds = productDetailResponse.notFoundIDs;
        _consumables = [];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    final QueryPurchaseDetailsResponse purchaseResponse =
    await _connection.queryPastPurchases();
    if (purchaseResponse.error != null) {
      // handle query past purchase error..
    }
    final List<PurchaseDetails> verifiedPurchases = [];
    for (PurchaseDetails purchase in purchaseResponse.pastPurchases) {
      if (await _verifyPurchase(purchase)) {
        verifiedPurchases.add(purchase);
      }
    }
    List<String> consumables = await ConsumableStore.load();
    if (mounted) {
      setState(() {
        _isAvailable = isAvailable;
        _products = productDetailResponse.productDetails;
        _purchases = verifiedPurchases;
        _notFoundIds = productDetailResponse.notFoundIDs;
        _consumables = consumables;
        _purchasePending = false;
        _loading = false;

        print("payItems = ${_products.length}");
        for (var item in _products) {
          bottomList.add(new IosBottomPayItem(item, false));
        }
        bottomList[0].isChecked = true;
      });
    }
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
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  _pay() {
    PurchaseParam purchaseParam = PurchaseParam(
        productDetails: getSelectedData(),
        applicationUserName: null,
        sandboxTesting: true);
    if (getSelectedData().id == _kConsumableId) {
      _connection.buyConsumable(
          purchaseParam: purchaseParam,
          autoConsume: kAutoConsume || Platform.isIOS);
    } else {
      _connection.buyNonConsumable(purchaseParam: purchaseParam);
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> stack = [];

    stack.add(Column(
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
        VipBottomWidget(onTapDelegate: () {
          EventUtil.onEvent(EventUtil.vipPayClick);

          //如果用户是游客
          if (UserDelegate.userStatus == UserStatus.GUEST) {
            Application.router
                .navigateTo(context, Routes.settingLogin)
                .then((value) {
              if (UserDelegate.userStatus != UserStatus.GUEST) {
                _pay();
              }
            });
          } else {
            _pay();
          }
        }),
      ],
    ));

    if (_loading) {
      stack.add(
        Stack(
          children: [
            new Opacity(
              opacity: 0.4,
              child: const ModalBarrier(dismissible: false, color: Colors.grey),
            ),
            Center(
              child: CupertinoActivityIndicator(
                radius: 20.0,
              ),
            ),
          ],
        ),
      );
    }

    if (_purchasePending) {
      stack.add(
        Stack(
          children: [
            new Opacity(
              opacity: 0.3,
              child: const ModalBarrier(dismissible: false, color: Colors.grey),
            ),
            Center(
              child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(12.0))),
                  constraints: BoxConstraints.expand(width: 170, height: 170),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CupertinoActivityIndicator(
                        radius: 20.0,
                      ),
                      Text("正在支付中，请稍后")
                    ],
                  )),
            ),
          ],
        ),
      );
    }

    return OKToast(
        child: Scaffold(
          backgroundColor: Color(0xFF606060),
          appBar: AppBar(
            title: Text("VIP会员"),
            centerTitle: true,
          ),
          body: Stack(
            children: stack,
          ),
        ));
  }

  ProductDetails getSelectedData() {
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

          switch (i) {
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
                    bottomList[i].data.title,
                    style: TextStyle(fontSize: 15, color: Color(0xFF3F3C2C)),
                  ),
                  SizedBox(
                    height: 13,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: <Widget>[
                      Text(
                        bottomList[i].data.price,
                        style: TextStyle(
                            fontSize: 40, color: AppColor.vipTextColor),
                      )
                    ],
                  ),
//                        bottomList[i].data.price,
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
