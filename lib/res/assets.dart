import 'package:raskop_fe_backoffice/res/paths.dart';

/// Image Assets Path
class ImageAssets {
  /// Base Image Path for Image Concatenations
  static const _base = BasePaths.baseImagePath;

  ///
  static const raskop = '$_base/raskop.png';

  ///
  static const qris = '$_base/qris-logo.png';
}

/// Icon Assets SVG
class IconAssets {
  ///
  static const bankCard =
      '<svg xmlns="http://www.w3.org/2000/svg" width="48" height="48" viewBox="0 0 48 48"><g fill="none" stroke="currentColor" stroke-linejoin="round" stroke-width="4"><path d="M4 10a2 2 0 0 1 2-2h36a2 2 0 0 1 2 2v28a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2z"/><path stroke-linecap="square" d="M4 16h40"/><path stroke-linecap="round" d="M27 32h9m8-22v16M4 10v16"/></g></svg>';

  ///
  static const searchIcon =
      '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24"><path fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="m21 21l-4.343-4.343m0 0A8 8 0 1 0 5.343 5.343a8 8 0 0 0 11.314 11.314"/></svg>';
}
