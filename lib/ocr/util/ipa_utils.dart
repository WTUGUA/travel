//import 'package:flutter_ocr/components/vip/consumablestore.dart';
//import 'package:flutter_ocr/components/vip/vip_ios_component.dart';
//import 'package:in_app_purchase/in_app_purchase.dart';
//
//
//const bool kAutoConsume = true;
//const List<String> _kProductIds = <String>[
//  'jiangji.op.Subscription.1month',
//  'jiangji.op.Subscription.3month',
//  'jiangji.op.Subscription.12month',
//];
//
//
//class IpaUtils{
//
//
//  static var bottomList = <IosBottomPayItem>[];
//
//  static Future<void> initStoreInfo() async {
//    var  _products=[];
//    InAppPurchaseConnection _connection = InAppPurchaseConnection.instance;
//    final bool isAvailable = await _connection.isAvailable();
//    if (!isAvailable) {
//      return;
//    }
//    ProductDetailsResponse productDetailResponse =
//    await _connection.queryProductDetails(_kProductIds.toSet());
//    _products = productDetailResponse.productDetails;
//    for (var item in _products) {
//      bottomList.add(new IosBottomPayItem(item, false));
//    }
//  }
//}