import 'dart:io';
import 'package:centranews/widgets/article_container.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

//TODO replace this with production key
const androidBannerAdKey = "ca-app-pub-3940256099942544/9214589741";
const iosAndroidBannerAdKey = "ca-app-pub-3940256099942544/2435281174";

class BannerAdContainer extends ConsumerStatefulWidget {
  const BannerAdContainer({super.key});

  @override
  ConsumerState<BannerAdContainer> createState() => _BannerAdContainerState();
}

class _BannerAdContainerState extends ConsumerState<BannerAdContainer> {
  BannerAd? _bannerAd;
  bool hasSucessfullyLoadedAd = false;

  @override
  Widget build(BuildContext context) {
    if (_bannerAd == null && !hasSucessfullyLoadedAd) {
      loadAd();
    }
    return kIsWeb ? SizedBox.shrink() : displayAd();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  Widget displayAd() {
    if (_bannerAd == null) return SizedBox.shrink();
    return Align(
      alignment: Alignment.bottomCenter,
      child: SafeArea(
        child: SizedBox(
          width: _bannerAd!.size.width.toDouble(),
          height: _bannerAd!.size.height.toDouble(),
          child: AdWidget(ad: _bannerAd!),
        ),
      ),
    );
  }

  void loadAd() async {
    if (kIsWeb) {
      //TODO: implement adsense
      setState(() {
        hasSucessfullyLoadedAd = true;
      });
      return;
    }
    final size = await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
      MediaQuery.sizeOf(context).width.truncate(),
    );

    if (size == null) {
      return;
    }

    BannerAd(
      adUnitId: Platform.isAndroid ? androidBannerAdKey : iosAndroidBannerAdKey,
      request: const AdRequest(),
      size: size,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          debugPrint("Ad was loaded.");
          if (mounted) {
            setState(() {
              _bannerAd = ad as BannerAd;
              hasSucessfullyLoadedAd = true;
            });
          }
        },
        onAdFailedToLoad: (ad, err) {
          debugPrint("Ad failed to load with error: $err");
          disposeAd(ad);
        },
        onAdClosed: (Ad ad) {
          disposeAd(ad);
        },
        onAdWillDismissScreen: (Ad ad) {
          disposeAd(ad);
        },
      ),
    ).load();
  }

  void disposeAd(Ad ad) {
    ad.dispose();
    if (mounted) {
      setState(() {
        _bannerAd = null;
        hasSucessfullyLoadedAd = false;
      });
    }
  }
}
