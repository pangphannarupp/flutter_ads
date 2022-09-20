// import 'package:adcolony/adcolony.dart';
// import 'package:adcolony/banner.dart';
// import 'package:flutter/cupertino.dart';
//
// Widget AdcolonyBanner({required String zone, required Function onLoaded, required Function onFailed}) {
//   return BannerView((AdColonyAdListener event) {
//     if(event == AdColonyAdListener.onRequestFilled ||
//       event == AdColonyAdListener.onOpened) {
//       onLoaded();
//     } else if(event == AdColonyAdListener.onRequestNotFilled) {
//       onFailed();
//     }
//   }, BannerSizes.banner, zone);
// }