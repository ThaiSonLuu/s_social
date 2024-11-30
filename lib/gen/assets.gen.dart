/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';

class $AssetsIconsGen {
  const $AssetsIconsGen();

  /// File path: assets/icons/app_icon.png
  AssetGenImage get appIcon => const AssetGenImage('assets/icons/app_icon.png');

  /// List of all assets
  List<AssetGenImage> get values => [appIcon];
}

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/anonymous.png
  AssetGenImage get anonymous =>
      const AssetGenImage('assets/images/anonymous.png');

  /// File path: assets/images/background_default_1.png
  AssetGenImage get backgroundDefault1 =>
      const AssetGenImage('assets/images/background_default_1.png');

  /// File path: assets/images/background_default_10.png
  AssetGenImage get backgroundDefault10 =>
      const AssetGenImage('assets/images/background_default_10.png');

  /// File path: assets/images/background_default_2.png
  AssetGenImage get backgroundDefault2 =>
      const AssetGenImage('assets/images/background_default_2.png');

  /// File path: assets/images/background_default_3.png
  AssetGenImage get backgroundDefault3 =>
      const AssetGenImage('assets/images/background_default_3.png');

  /// File path: assets/images/background_default_4.png
  AssetGenImage get backgroundDefault4 =>
      const AssetGenImage('assets/images/background_default_4.png');

  /// File path: assets/images/background_default_5.png
  AssetGenImage get backgroundDefault5 =>
      const AssetGenImage('assets/images/background_default_5.png');

  /// File path: assets/images/background_default_6.png
  AssetGenImage get backgroundDefault6 =>
      const AssetGenImage('assets/images/background_default_6.png');

  /// File path: assets/images/background_default_7.png
  AssetGenImage get backgroundDefault7 =>
      const AssetGenImage('assets/images/background_default_7.png');

  /// File path: assets/images/background_default_8.png
  AssetGenImage get backgroundDefault8 =>
      const AssetGenImage('assets/images/background_default_8.png');

  /// File path: assets/images/background_default_9.png
  AssetGenImage get backgroundDefault9 =>
      const AssetGenImage('assets/images/background_default_9.png');

  /// File path: assets/images/invisible.png
  AssetGenImage get invisible =>
      const AssetGenImage('assets/images/invisible.png');

  /// File path: assets/images/logo_facebook.png
  AssetGenImage get logoFacebook =>
      const AssetGenImage('assets/images/logo_facebook.png');

  /// File path: assets/images/logo_google.png
  AssetGenImage get logoGoogle =>
      const AssetGenImage('assets/images/logo_google.png');

  /// File path: assets/images/logo_s.png
  AssetGenImage get logoS => const AssetGenImage('assets/images/logo_s.png');

  /// File path: assets/images/visible.png
  AssetGenImage get visible => const AssetGenImage('assets/images/visible.png');

  /// List of all assets
  List<AssetGenImage> get values => [
        anonymous,
        backgroundDefault1,
        backgroundDefault10,
        backgroundDefault2,
        backgroundDefault3,
        backgroundDefault4,
        backgroundDefault5,
        backgroundDefault6,
        backgroundDefault7,
        backgroundDefault8,
        backgroundDefault9,
        invisible,
        logoFacebook,
        logoGoogle,
        logoS,
        visible
      ];
}

class Assets {
  Assets._();

  static const $AssetsIconsGen icons = $AssetsIconsGen();
  static const $AssetsImagesGen images = $AssetsImagesGen();
}

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
  });

  final String _assetName;

  final Size? size;
  final Set<String> flavors;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.low,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({
    AssetBundle? bundle,
    String? package,
  }) {
    return AssetImage(
      _assetName,
      bundle: bundle,
      package: package,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
