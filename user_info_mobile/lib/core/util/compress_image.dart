import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';

Future<File> compressImage(File file) async {
  final filePath = file.absolute.path;

  final lastIndex = filePath.lastIndexOf('.');
  final splitted = filePath.substring(0, lastIndex);
  final outPath = "${splitted}_compressed.jpg";

  var result = await FlutterImageCompress.compressAndGetFile(
    file.absolute.path,
    outPath,
    quality: 70,
    minWidth: 1024,
    minHeight: 1024,
  );

  return File(result!.path);
}
