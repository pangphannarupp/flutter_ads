library flutter_ads;

import 'dart:async';
import 'dart:math';

import 'package:chartboost/chartboost.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ads/utils/adcolony_util.dart';
import 'package:flutter_ads/utils/applovin_util.dart';
import 'package:flutter_ads/utils/chartboost_util.dart';
import 'package:flutter_ads/utils/ironsouce_util.dart';
import 'package:flutter_ads/utils/unity_util.dart';
import 'package:flutter_ads/utils/vungle_util.dart';
import 'package:flutter_ironsource_x/ironsource.dart';
import 'package:flutter_ironsource_x/models.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';
import 'package:vungle/vungle.dart';

import 'listener/iron_source_banner_ad_listener.dart';

/// A Calculator.
class FlutterAds
    with IronSourceListener, WidgetsBindingObserver {
  // IronSource
  bool isShownIronSourceRewardedVideoAds = false;
  // End IronSource

  void showMessage(String message) {
    print(message);
  }

  // Vungle
  void initVungle(String vunglePlacement) {
    Vungle.getSDKVersion();
    Vungle.onInitilizeListener = () {};
    Vungle.onAdPlayableListener = (placemenId, playable) {};
    Vungle.onAdStartedListener = (placementId) {};
    Vungle.onAdFinishedListener = (placementId, isCTAClicked, completedView) {};
    Vungle.enableBackgroundDownload(true);
    Vungle.init(VungleUtil.APP_ID);
    Vungle.loadAd(vunglePlacement);
  }
  // End Vungle

  // IronSource
  void loadIronSourceInterstitial() {
    IronSource.loadInterstitial();
  }

  @override
  void onInterstitialAdClicked() {
    showMessage("onInterstitialAdClicked");
  }

  @override
  void onInterstitialAdClosed() {
    showMessage("onInterstitialAdClosed");
  }

  @override
  void onInterstitialAdLoadFailed(IronSourceError error) {
    loadIronSourceInterstitial();
  }

  @override
  void onInterstitialAdOpened() {
    showMessage("onInterstitialAdOpened");
  }

  @override
  void onInterstitialAdReady() {
    showMessage("onInterstitialAdReady");
  }

  @override
  void onInterstitialAdShowFailed(IronSourceError error) {
    loadIronSourceInterstitial();
  }

  @override
  void onInterstitialAdShowSucceeded() {
    showMessage("nInterstitialAdShowSucceeded");
  }

  @override
  void onGetOfferwallCreditsFailed(IronSourceError error) {}

  @override
  void onOfferwallAdCredited(OfferwallCredit reward) {
    showMessage("onOfferwallAdCredited : $reward");
  }

  @override
  void onOfferwallAvailable(bool available) {
    showMessage("onOfferwallAvailable : $available");
  }

  @override
  void onOfferwallClosed() {
    showMessage("onOfferwallClosed");
  }

  @override
  void onOfferwallOpened() {
    showMessage("onOfferwallOpened");
  }

  @override
  void onOfferwallShowFailed(IronSourceError error) {}

  @override
  void onRewardedVideoAdClicked(Placement placement) {
    showMessage("onRewardedVideoAdClicked");
  }

  @override
  void onRewardedVideoAdClosed() {
    showMessage("onRewardedVideoAdClosed");
  }

  @override
  void onRewardedVideoAdEnded() {
    showMessage("onRewardedVideoAdEnded");
  }

  @override
  void onRewardedVideoAdOpened() {
    showMessage("onRewardedVideoAdOpened");
  }

  @override
  void onRewardedVideoAdRewarded(Placement placement) {
    showMessage("onRewardedVideoAdRewarded: ${placement.placementName}");
  }

  @override
  void onRewardedVideoAdShowFailed(IronSourceError error) {}

  @override
  void onRewardedVideoAdStarted() {
    showMessage("onRewardedVideoAdStarted");
  }

  @override
  void onRewardedVideoAvailabilityChanged(bool available) {
    showMessage("onRewardedVideoAvailabilityChanged : $available");
  }

  void initIronSource() async {
    var userId = await IronSource.getAdvertiserId();
    await IronSource.validateIntegration();
    await IronSource.setUserId(userId);
    await IronSource.initialize(
        appKey: IronSourceUtil.APP_KEY, listener: this, gdprConsent: true, ccpaConsent: false);
  }
  // End Vungle

  // Local Function
  void showUnityFullScreenAds({Function? onCompleted, Function? onFailed}) async {
    showMessage('Show Unity Interstitial Ads');
    if (Random().nextBool()) {
      showMessage('Show Unity Rewarded');
      UnityAds.showVideoAd(
          placementId: UnityUtil.PLACEMENT_REWARDED_VIDEO,
          onStart: (placementId) {
            // await service
            //     .updateViewGlobalAds(UnityUtil.APP_SERVER_NAME);
          },
          onComplete: (placementId) {
            if(onCompleted != null) onCompleted();
          },
          onFailed: (placementId, error, errorMessage) {
            if(onFailed != null) onFailed();
          });
    } else {
      showMessage('Show Unity Interstitial');
      UnityAds.showVideoAd(
          placementId: UnityUtil.PLACEMENT_VIDEO,
          onStart: (placementId) {
            // await service
            //     .updateViewGlobalAds(UnityUtil.APP_SERVER_NAME);
          },
          onComplete: (placementId) {
            if(onCompleted != null) onCompleted();
          },
          onFailed: (placementId, error, errorMessage) {
            if(onFailed != null) onFailed();
          });
    }
  }

  void showChartBoostFullScreenAds({Function? onCompleted, Function? onFailed}) async {
    showMessage('Show ChartBoost Interstitial Ads');
    await Chartboost.showInterstitial(listener: (ChartboostEventListener event) async {
      showMessage('EVENT: $event');
      if(event == ChartboostEventListener.didCacheInterstitial) {
        showMessage('Cached interstitial!');
        // await service.updateViewGlobalAds(ChartBoostUtil.APP_SERVER_NAME);
      } else if(event == ChartboostEventListener.didFailToLoadInterstitial ||
          event == ChartboostEventListener.didFailToLoadRewardedVideo) {
        if(onFailed != null) onFailed();
      } else if(event == ChartboostEventListener.didCompleteRewardedVideo ||
          event == ChartboostEventListener.didDisplayInterstitial) {
        if(onCompleted != null) onCompleted();
      }
    });
  }

  void showAppLovinFullScreen({Function? onCompleted, Function? onFailed}) {
    showMessage('Show AppLovin Interstitial Ads');
    if(Random().nextBool()) {
      showMessage('Show AppLovin Rewarded');
      // AppLovin.requestInterstitial(
      //         (AppLovinAdListener event) {
      //       if (event == AppLovinAdListener.adReceived) {
      //         AppLovin.showInterstitial(interstitial: false);
      //         // Update View Server Ads
      //       } else if(event == AppLovinAdListener.failedToReceiveAd) {
      //         if(onFailed != null) onFailed();
      //       } else if(event == AppLovinAdListener.adDisplayed) {
      //         if(onCompleted != null) onCompleted();
      //       }
      //     },
      //     interstitial: true);
    } else {
      showMessage('Show AppLovin Interstitial');
      // AppLovin.requestInterstitial(
      //         (AppLovinAdListener event) {
      //       if (event == AppLovinAdListener.adReceived) {
      //         AppLovin.showInterstitial(interstitial: true);
      //         // Update View Server Ads
      //       } else if(event == AppLovinAdListener.failedToReceiveAd) {
      //         if(onFailed != null) onFailed();
      //       } else if(event == AppLovinAdListener.adDisplayed) {
      //         if(onCompleted != null) onCompleted();
      //       }
      //     },
      //     interstitial: true);
    }
  }

  void showVungleFullScreen({Function? onCompleted, Function? onFailed}) async {
    showMessage('Show Vungle Interstitial Ads');

    String vunglePlacement = Random().nextBool() ? VungleUtil.PLACEMENT_REWARDED : VungleUtil.PLACEMENT_INTERSTITIAL;
    initVungle(vunglePlacement);

    if (await Vungle.isAdPlayable(vunglePlacement)) {
      Vungle.playAd(vunglePlacement);
      // await service.updateViewGlobalAds(VungleUtil.APP_SERVER_NAME);
      if(onCompleted != null) onCompleted();
    } else {
      showMessage('The ad is not ready to play');
      if(onFailed != null) onFailed();
    }
  }

  void showIronSourceFullScreen({Function? onCompleted, Function? onFailed}) async {
    if(Random().nextBool()) {
      if (await IronSource.isRewardedVideoAvailable() &&
          !isShownIronSourceRewardedVideoAds) {
        isShownIronSourceRewardedVideoAds = true;
        IronSource.showRewardedVideo();
        if(onCompleted != null) onCompleted();
      } else {
        if(onFailed != null) onFailed();
      }
    } else {
      if (await IronSource.isInterstitialReady()) {
        IronSource.showInterstitial();
        if(onCompleted != null) onCompleted();
      } else {
        loadIronSourceInterstitial();
        if(onFailed != null) onFailed();
      }
    }
  }

  // void showAdcolonyFullScreen({Function? onCompleted, Function? onFailed}) {
  //   AdColony.request(AdcolonyUtil.ZONE_INTERSTITIAL, (AdColonyAdListener event) {
  //     showMessage(event);
  //     if (event == AdColonyAdListener.onRequestFilled) {
  //       AdColony.show();
  //
  //       if(onCompleted != null) onCompleted();
  //     } else if(event == AdColonyAdListener.onRequestNotFilled) {
  //       if(onFailed != null) onFailed();
  //     }
  //   });
  // }

  // End Local Function

  void initialize({
    bool? applovin,
    Map<String, dynamic>? ironSource,
    Map<String, dynamic>? chartBoost,
    Map<String, dynamic>? unity,
    Map<String, dynamic>? vungle,
    Map<String, dynamic>? adcolony,
  }) async {
    // Applovin
    // if(applovin) {
    //   AppLovinUtil.isInit = true;
    //   AppLovin.init();
    // }

    // IronSource
    if(ironSource != null) {
      IronSourceUtil.APP_KEY = ironSource['ironSourceAppKey'];
      showMessage('============= IronSource =============');
      showMessage('APP_KEY: ${IronSourceUtil.APP_KEY}');

      initIronSource();
    }

    // ChartBoost
    if(chartBoost != null) {
      ChartBoostUtil.APP_ID = chartBoost['chartBoostAppId'];
      ChartBoostUtil.APP_SIGNATURE = chartBoost['chartBoostAppSignature'];
      showMessage('============= ChartBoost =============');
      showMessage('APP_ID: ${ChartBoostUtil.APP_ID}');
      showMessage('APP_SIGNATURE: ${ChartBoostUtil.APP_SIGNATURE}');

      // Init Chartboost
      Chartboost.init(ChartBoostUtil.APP_ID, ChartBoostUtil.APP_SIGNATURE)
          .then((value) => Chartboost.cacheInterstitial());
    }

    // Unity
    if(unity != null) {
      UnityUtil.GAME_ID = unity['unityGameId'];
      UnityUtil.PLACEMENT_BANNER = unity['unityPlacementBanner'];
      UnityUtil.PLACEMENT_VIDEO = unity['unityPlacementInterstitial'];
      UnityUtil.PLACEMENT_REWARDED_VIDEO = unity['unityPlacementRewardedVideo'];
      showMessage('============= Unity =============');
      showMessage('GAME_ID: ${UnityUtil.GAME_ID}');
      showMessage('PLACEMENT_BANNER: ${UnityUtil.PLACEMENT_BANNER}');
      showMessage('PLACEMENT_VIDEO: ${UnityUtil.PLACEMENT_VIDEO}');
      showMessage('PLACEMENT_REWARDED_VIDEO: ${UnityUtil.PLACEMENT_REWARDED_VIDEO}');

      // Init Unity
      UnityAds.init(
        gameId: UnityUtil.GAME_ID,
        testMode: UnityUtil.IS_TEST,
        onComplete: () {

        },
        onFailed: (error, errorMessage) {

        },
      );

      UnityAds.load(
        placementId: UnityUtil.PLACEMENT_BANNER,
        onComplete: (placementId) => showMessage('Load Complete $placementId'),
        onFailed: (placementId, error, message) => showMessage('Load Failed $placementId: $error $message'),
      );

      UnityAds.load(
        placementId: UnityUtil.PLACEMENT_VIDEO,
        onComplete: (placementId) => showMessage('Load Complete $placementId'),
        onFailed: (placementId, error, message) => showMessage('Load Failed $placementId: $error $message'),
      );

      UnityAds.load(
        placementId: UnityUtil.PLACEMENT_REWARDED_VIDEO,
        onComplete: (placementId) => showMessage('Load Complete $placementId'),
        onFailed: (placementId, error, message) => showMessage('Load Failed $placementId: $error $message'),
      );
    }

    // Vungle
    if(vungle != null) {
      VungleUtil.APP_ID = vungle['vungleAppId'];
      VungleUtil.PLACEMENT_BANNER = vungle['vunglePlacementBanner'];
      VungleUtil.PLACEMENT_INTERSTITIAL = vungle['vunglePlacementInterstitial'];
      VungleUtil.PLACEMENT_REWARDED = vungle['vunglePlacementRewardedVideo'];
      showMessage('============= Vungle =============');
      showMessage('APP_ID: ${VungleUtil.APP_ID}');
      showMessage('PLACEMENT_BANNER: ${VungleUtil.PLACEMENT_BANNER}');
      showMessage('PLACEMENT_INTERSTITIAL: ${VungleUtil.PLACEMENT_INTERSTITIAL}');
      showMessage('PLACEMENT_REWARDED: ${VungleUtil.PLACEMENT_REWARDED}');
    }

    // Adcolony
    // if(adcolony != null) {
    //   AdcolonyUtil.APP_UUID = adcolony['adcolonyAppUUID'];
    //   AdcolonyUtil.ZONE_BANNER = adcolony['adcolonyPlacementBanner'];
    //   AdcolonyUtil.ZONE_INTERSTITIAL = adcolony['adcolonyPlacementInterstitial'];
    //   AdcolonyUtil.ZONE_REWARDED = adcolony['adcolonyPlacementRewardedVideo'];
    //   showMessage('============= Vungle =============');
    //   showMessage('APP_UUID: ' + AdcolonyUtil.APP_UUID);
    //   showMessage('PLACEMENT_BANNER: ' + AdcolonyUtil.ZONE_BANNER);
    //   showMessage('PLACEMENT_INTERSTITIAL: ' + AdcolonyUtil.ZONE_INTERSTITIAL);
    //   showMessage('PLACEMENT_REWARDED: ' + AdcolonyUtil.ZONE_REWARDED);
    //
    //   AdColony.init(AdColonyOptions(AdcolonyUtil.APP_UUID, '0', [
    //     AdcolonyUtil.ZONE_BANNER,
    //     AdcolonyUtil.ZONE_INTERSTITIAL
    //   ]));
    // }
  }

  Widget showBanner({Function? onLoaded, Function? onFailed}) {
    List<String> ads = [];
    if(UnityUtil.GAME_ID != '') ads.add(UnityUtil.GAME_ID);
    //if(IronSourceUtil.APP_KEY != '') ads.add(IronSourceUtil.APP_KEY);
    // if(AdcolonyUtil.APP_UUID != '') ads.add(AdcolonyUtil.APP_UUID);

    int randomAds = Random().nextInt(ads.length);
    showMessage(ads[randomAds]);
    if(ads[randomAds] == UnityUtil.GAME_ID) {
      showMessage('Show Unity Banner');
      return UnityBannerAd(
        placementId: UnityUtil.PLACEMENT_BANNER,
        onLoad: (placementId) {
          if(onLoaded != null) onLoaded();
        },
        onFailed: (placementId, error, errorMessage) {
          if(onFailed != null) onFailed();
        },
      );
    } else if(ads[randomAds] == IronSourceUtil.APP_KEY) {
      showMessage('Show IronSource Banner');
      return IronSourceBannerAd(
        keepAlive: true,
        listener: IronSourceBannerAdListener(),
        // size: IronBanner.BannerSize.BANNER,
      );
    } else if(ads[randomAds] == AdcolonyUtil.APP_UUID) {
      showMessage('Show Adcolony Banner');
      // return AdcolonyBanner(
      //   zone: AdcolonyUtil.ZONE_BANNER,
      //   onLoaded: onLoaded!,
      //   onFailed: onFailed!
      // );
    }

    return Container();
  }

  void showInterstitial({Function? onCompleted, Function? onFailed}) {
    List<String> ads = [];
    if(UnityUtil.GAME_ID != '') ads.add(UnityUtil.GAME_ID);
    if(ChartBoostUtil.APP_ID != '') ads.add(ChartBoostUtil.APP_ID);
    if(AppLovinUtil.isInit) ads.add('AppLovin');
    if(VungleUtil.APP_ID != '') ads.add(VungleUtil.APP_ID);
    if(IronSourceUtil.APP_KEY != '') ads.add(IronSourceUtil.APP_KEY);
    if(AdcolonyUtil.APP_UUID != '') ads.add(AdcolonyUtil.APP_UUID);

    int randomAds = Random().nextInt(ads.length);
    showMessage(ads[randomAds]);
    // randomAds = 5;
    if(ads[randomAds] == UnityUtil.GAME_ID) {
      showUnityFullScreenAds(onCompleted: onCompleted, onFailed: onFailed);
    } else if(ads[randomAds] == ChartBoostUtil.APP_ID) {
      showChartBoostFullScreenAds(onCompleted: onCompleted, onFailed: onFailed);
    } else if(ads[randomAds] == 'AppLovin') {
      showAppLovinFullScreen(onCompleted: onCompleted, onFailed: onFailed);
    } else if(ads[randomAds] == VungleUtil.APP_ID) {
      showVungleFullScreen(onCompleted: onCompleted, onFailed: onFailed);
    } else if(ads[randomAds] == IronSourceUtil.APP_KEY) {
      showIronSourceFullScreen(onCompleted: onCompleted, onFailed: onFailed);
    } else if(ads[randomAds] == AdcolonyUtil.APP_UUID) {
      // showAdcolonyFullScreen(onCompleted: onCompleted, onFailed: onFailed);
    } else {
      if(onCompleted != null) onCompleted();
    }
  }

  void showLoopInterstitial() {
    int indexAds = -1;
    showMessage('Wait 60 seconds');
    List<String> ads = [];
    if(UnityUtil.GAME_ID != '') ads.add(UnityUtil.GAME_ID);
    if(ChartBoostUtil.APP_ID != '') ads.add(ChartBoostUtil.APP_ID);
    if(AppLovinUtil.isInit) ads.add('AppLovin');
    if(VungleUtil.APP_ID != '') ads.add(VungleUtil.APP_ID);
    if(IronSourceUtil.APP_KEY != '') ads.add(IronSourceUtil.APP_KEY);
    if(AdcolonyUtil.APP_UUID != '') ads.add(AdcolonyUtil.APP_UUID);

    Timer.periodic(const Duration(seconds: 60), (timer) {
      indexAds++;
      // indexAds = 5;
      if(ads[indexAds] == UnityUtil.GAME_ID) {
        showMessage('Show Unity - ${UnityUtil.APP_TITLE}');
        showUnityFullScreenAds(onCompleted: null, onFailed: null);
      } else if(ads[indexAds] == ChartBoostUtil.APP_ID) {
        showMessage('Show ChartBoost - ${ChartBoostUtil.APP_TITLE}');
        showChartBoostFullScreenAds(onCompleted: null, onFailed: null);
      } else if(ads[indexAds] == 'AppLovin') {
        showMessage('Show AppLovin');
        showAppLovinFullScreen(onCompleted: null, onFailed: null);
      } else if(ads[indexAds] == VungleUtil.APP_ID) {
        showMessage('Show Vungle - ${VungleUtil.APP_TITLE}');
        showVungleFullScreen(onCompleted: null, onFailed: null);
      } else if(ads[indexAds] == IronSourceUtil.APP_KEY) {
        showMessage('Show IronSource - ${IronSourceUtil.APP_TITLE}');
        showIronSourceFullScreen(onCompleted: null, onFailed: null);
      } else if(ads[indexAds] == AdcolonyUtil.APP_UUID) {
        showMessage('Show Adcolony - ${AdcolonyUtil.APP_TITLE}');
        // showAdcolonyFullScreen(onCompleted: null, onFailed: null);
      }
      if(indexAds == ads.length - 1) indexAds = -1;
    });
  }
}