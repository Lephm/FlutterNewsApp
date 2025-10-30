import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb, debugPrint;
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;
//TODO: replace this with production key
const String iosInterstitialAdKey = "ca-app-pub-3940256099942544/4411468910";
const String androidInterstitialAdKey =
    "ca-app-pub-3940256099942544/1033173712";

var adManager = AdManager();

class AdManager {
  AdManager() {
    supabase.auth.onAuthStateChange.listen(loadUserCurrentAdState);
  }

  int numberOfRequestBeforeShowingAd = 3;
  int currentNumberOfShowingAdRequest = 0;
  bool hasRemovedAd = false;

  void requestToShowAd() {
    if (hasRemovedAd) return;
    currentNumberOfShowingAdRequest += 1;
    if (currentNumberOfShowingAdRequest >= numberOfRequestBeforeShowingAd) {
      resetCurrentNumberOfShowingAdRequest();
      showInterstitialAd();
    }
  }

  void showInterstitialAd() {
    if (kIsWeb) {
      //TODO: Intergrate adsense
      return;
    }
    InterstitialAd.load(
      adUnitId: Platform.isAndroid
          ? androidInterstitialAdKey
          : iosInterstitialAdKey,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          debugPrint('Ad was loaded.');
          ad.show();
        },
        onAdFailedToLoad: (LoadAdError error) {
          debugPrint('Ad failed to load with error: $error');
        },
      ),
    );
  }

  void resetCurrentNumberOfShowingAdRequest() {
    currentNumberOfShowingAdRequest = 0;
  }

  void setHasRemovedAd(bool value) {
    hasRemovedAd = value;
  }

  void loadUserCurrentAdState(AuthState data) async {
    if (supabase.auth.currentUser == null) {
      setHasRemovedAd(false);
    } else {
      //TODO: add loading user ad state
    }
  }
}
