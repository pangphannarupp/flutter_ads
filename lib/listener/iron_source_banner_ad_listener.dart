import 'package:flutter_ironsource_x/banner.dart';

class IronSourceBannerAdListener extends IronSourceBannerListener {
  @override
  void onBannerAdClicked() {
    print("onBannerAdClicked");
  }

  @override
  void onBannerAdLeftApplication() {
    print("onBannerAdLeftApplication");
  }

  @override
  void onBannerAdLoadFailed(Map<String, dynamic> error) {
    print("onBannerAdLoadFailed");
  }

  @override
  void onBannerAdLoaded() {
    print("onBannerAdLoaded");
  }

  @override
  void onBannerAdScreenDismissed() {
    print("onBannerAdScreenDismisse");
  }

  @override
  void onBannerAdScreenPresented() {
    print("onBannerAdScreenPresented");
  }
}