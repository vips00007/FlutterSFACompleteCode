import 'dart:io';
import 'package:image/image.dart' as img;

void main() {
  final file = File('android/app/src/main/res/drawable/logo.png');
  if (!file.existsSync()) {
    print('Logo file not found');
    return;
  }
  
  final bytes = file.readAsBytesSync();
  final image = img.decodeImage(bytes);
  
  if (image != null) {
    final resized = img.copyResize(image, width: 64, height: 64, interpolation: img.Interpolation.cubic);
    file.writeAsBytesSync(img.encodePng(resized));
    print('Successfully resized android logo to 64x64 px');
  } else {
    print('Failed to decode image');
  }
}
