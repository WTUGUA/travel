
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rate_my_app/rate_my_app.dart';

/// Main rate my app instance.
RateMyApp _rateMyApp = RateMyApp(
  minDays: 7,
  minLaunches: 10,
  remindDays: 7,
  remindLaunches: 10,
);
class RateUtils{


  static void showRateDialog(BuildContext context){

    _rateMyApp.init().then((_) {


      _rateMyApp.showRateDialog(
        context,
        title: 'Rate this app',
        message: 'If you like this app, please take a little bit of your time to review it !\nIt really helps us and it shouldn\'t take you more than one minute.',
        rateButton: 'RATE',
        noButton: 'NO THANKS',
        laterButton: 'MAYBE LATER',
        ignoreIOS: false,
      );

//      _rateMyApp.showStarRateDialog(
//        context,
//        title: 'Rate this app',
//        message: 'You like this app ? Then take a little bit of your time to leave a rating :',
//        onRatingChanged: (stars) {
//          return [
//            FlatButton(
//              child: Text('OK'),
//              onPressed: () {
//                print('Thanks for the ' + (stars == null ? '0' : stars.round().toString()) + ' star(s) !');
//                // You can handle the result as you want (for instance if the user puts 1 star then open your contact page, if he puts more then open the store page, etc...).
//                _rateMyApp.doNotOpenAgain = true;
//                _rateMyApp.save().then((v) => Navigator.pop(context));
//              },
//            ),
//          ];
//        },
//        ignoreIOS: false,
//        starRatingOptions: StarRatingOptions(),
//      );


      if (_rateMyApp.shouldOpenDialog) {

        _rateMyApp.showRateDialog(
          context,
          title: 'Rate this app',
          message: 'If you like this app, please take a little bit of your time to review it !\nIt really helps us and it shouldn\'t take you more than one minute.',
          rateButton: 'RATE',
          noButton: 'NO THANKS',
          laterButton: 'MAYBE LATER',
          ignoreIOS: false,
        );

        // Or if you prefer to show a star rating bar :

        _rateMyApp.showStarRateDialog(
          context,
          title: 'Rate this app',
          message: 'You like this app ? Then take a little bit of your time to leave a rating :',
          onRatingChanged: (stars) {
            return [
              FlatButton(
                child: Text('OK'),
                onPressed: () {
                  print('Thanks for the ' + (stars == null ? '0' : stars.round().toString()) + ' star(s) !');
                  // You can handle the result as you want (for instance if the user puts 1 star then open your contact page, if he puts more then open the store page, etc...).
                  _rateMyApp.doNotOpenAgain = true;
                  _rateMyApp.save().then((v) => Navigator.pop(context));
                },
              ),
            ];
          },
          ignoreIOS: false,
          starRatingOptions: StarRatingOptions(),
        );
      }
    });

  }


}
