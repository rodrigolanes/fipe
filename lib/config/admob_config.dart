import 'dart:io';

/// Configurações do Google AdMob
///
/// Este arquivo contém os IDs dos anúncios AdMob.
/// IMPORTANTE: Adicione este arquivo ao .gitignore para não expor IDs de produção.
class AdMobConfig {
  /// ID do App AdMob para Android
  static const String androidAppId = 'ca-app-pub-3940256099942544~3347511713';

  /// ID do App AdMob para iOS
  static const String iosAppId = 'ca-app-pub-3940256099942544~1458002511';

  /// ID do Banner para Android (Test ID)
  static const String androidBannerId =
      'ca-app-pub-3940256099942544/6300978111';

  /// ID do Banner para iOS (Test ID)
  static const String iosBannerId = 'ca-app-pub-3940256099942544/2934735716';

  /// ID do Intersticial para Android (Test ID)
  static const String androidInterstitialId =
      'ca-app-pub-3940256099942544/1033173712';

  /// ID do Intersticial para iOS (Test ID)
  static const String iosInterstitialId =
      'ca-app-pub-3940256099942544/4411468910';

  /// Retorna o App ID de acordo com a plataforma
  static String get appId {
    if (Platform.isAndroid) {
      return androidAppId;
    } else if (Platform.isIOS) {
      return iosAppId;
    }
    throw UnsupportedError('Plataforma não suportada para AdMob');
  }

  /// Retorna o Banner ID de acordo com a plataforma
  static String get bannerId {
    if (Platform.isAndroid) {
      return androidBannerId;
    } else if (Platform.isIOS) {
      return iosBannerId;
    }
    throw UnsupportedError('Plataforma não suportada para AdMob');
  }

  /// Retorna o Intersticial ID de acordo com a plataforma
  static String get interstitialId {
    if (Platform.isAndroid) {
      return androidInterstitialId;
    } else if (Platform.isIOS) {
      return iosInterstitialId;
    }
    throw UnsupportedError('Plataforma não suportada para AdMob');
  }
}
