import 'dart:io';
import 'package:image/image.dart' as img;

class Filters {

  static Future<void> bw(String path) async {
    final image = (await img.decodeImageFile(path))!;
    for (var pixel in image) {
      int bw = ((pixel.r * 0.2126) +( pixel.g * 0.7152) + (pixel.b * 0.0722)) / 255 > 0.5 ? 255 : 0;
      pixel.r = bw; pixel.g = bw; pixel.b = bw;
    }
    await File(path).writeAsBytes(img.encodePng(image, level: 9));
  }

  /// mimic MATLAB rgb2gray https://www.mathworks.com/help/matlab/ref/rgb2gray.html
  /// note this uses a weird convention of 0.2989 for the coefficient of red instead
  /// of the coefficient 0.299
  static Future<void> grayscale(String path) async { //
    final image = (await img.decodeImageFile(path))!;
    for (var pixel in image) {
      int gs = ((0.2989 * pixel.r) + (0.5870 * pixel.g) + (0.1140 * pixel.b)).toInt().clamp(0, 255);
      pixel.r = gs; pixel.g = gs; pixel.b = gs;
    }
    await File(path).writeAsBytes(img.encodePng(image, level: 9));
  }

}