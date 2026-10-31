import 'dart:js_interop';
import 'dart:typed_data';

@JS('fetch')
external JSPromise<FontResponse> fetchFont(JSString url);

extension type FontResponse._(JSObject _) implements JSObject {
  external JSPromise<JSArrayBuffer> arrayBuffer();
}

Future<ByteData> loadFontBytes() async {
  final response = await fetchFont('/assets/fonts/Manrope.ttf'.toJS).toDart;
  final buffer = await response.arrayBuffer().toDart;
  return ByteData.view(buffer.toDart);
}
