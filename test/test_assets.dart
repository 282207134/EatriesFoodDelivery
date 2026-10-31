import 'dart:convert';

import 'font_bytes_io.dart' if (dart.library.js_interop) 'font_bytes_web.dart';

import 'package:flutter/services.dart';

Future<void> loadTestFont() async {
  final loader = FontLoader('Manrope')..addFont(loadFontBytes());
  await loader.load();
}

/// Use a validated tiny PNG for layout and interaction tests.
/// Browser captures and Android integration tests use the real images.
class TestAssets extends CachingAssetBundle {
  static final pixel = base64Decode(
    'iVBORw0KGgoAAAANSUhEUgAAAAIAAAACCAYAAABytg0kAAAAC0lEQVR4nGNgQAcAABIAAXfx+gAAAAAASUVORK5CYII=',
  );
  static final manifest = const StandardMessageCodec().encodeMessage(
    <String, Object>{},
  )!;
  @override
  Future<ByteData> load(String key) async {
    if (key == 'AssetManifest.bin') return manifest;
    if (key.endsWith('.webp')) return ByteData.sublistView(pixel);
    return rootBundle.load(key);
  }

  @override
  Future<String> loadString(String key, {bool cache = true}) async {
    if (key == 'AssetManifest.bin.json') {
      return jsonEncode(
        base64Encode(
          manifest.buffer.asUint8List(
            manifest.offsetInBytes,
            manifest.lengthInBytes,
          ),
        ),
      );
    }
    return super.loadString(key, cache: cache);
  }
}
