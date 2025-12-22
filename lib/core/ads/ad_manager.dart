import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../config/admob_config.dart';

/// Gerenciador de anúncios AdMob
class AdManager {
  static BannerAd? _bannerAd;
  static bool _isBannerAdReady = false;

  /// Inicializa o SDK do AdMob
  static Future<void> initialize() async {
    await MobileAds.instance.initialize();
  }

  /// Carrega um banner ad
  static void loadBannerAd({
    required Function(BannerAd ad) onAdLoaded,
    required Function(Ad ad, LoadAdError error) onAdFailedToLoad,
  }) {
    _bannerAd = BannerAd(
      adUnitId: _getAdUnitId(),
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          _isBannerAdReady = true;
          onAdLoaded(ad as BannerAd);
        },
        onAdFailedToLoad: (ad, error) {
          _isBannerAdReady = false;
          ad.dispose();
          onAdFailedToLoad(ad, error);
        },
      ),
    );

    _bannerAd!.load();
  }

  static String _getAdUnitId() {
    // Usa test ID em debug mode, production ID em release
    if (const bool.fromEnvironment('dart.vm.product') == false) {
      // Se não estiver em modo de produção, verifica kDebugMode
      // kDebugMode é true apenas em debug
      return AdMobConfig.testBannerAdUnitId;
    }
    return AdMobConfig.bannerAdUnitId;
  }

  /// Retorna se o banner está pronto
  static bool get isBannerAdReady => _isBannerAdReady;

  /// Retorna o banner ad atual
  static BannerAd? get bannerAd => _bannerAd;

  /// Libera recursos do banner ad
  static void disposeBannerAd() {
    _bannerAd?.dispose();
    _bannerAd = null;
    _isBannerAdReady = false;
  }
}
