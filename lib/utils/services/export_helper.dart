import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

class ExportHelper {
  static Future<void> exportAsImage(GlobalKey key, String fileName) async {
    try {
      debugPrint("Start image export");

      await Future.delayed(
        Duration(milliseconds: 300),
      ); // slight delay for build

      RenderRepaintBoundary? boundary =
          key.currentContext?.findRenderObject() as RenderRepaintBoundary?;

      if (boundary == null) {
        debugPrint("❌ Render boundary is null.");
        return;
      }

      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) {
        debugPrint("❌ ByteData is null.");
        return;
      }

      final pngBytes = byteData.buffer.asUint8List();
      final directory = await getApplicationDocumentsDirectory();
      final imagePath = '${directory.path}/$fileName.png';
      final imageFile = File(imagePath)..writeAsBytesSync(pngBytes);

      await Share.shareXFiles([XFile(imagePath)], text: '$fileName Result');
    } catch (e) {
      debugPrint("Export failed: $e");
    }
  }

  static Future<void> downloadAsImage(GlobalKey key, String fileName) async {
    try {
      print("Start image download");

      await WidgetsBinding.instance.endOfFrame;

      if (await Permission.storage.request().isGranted) {
        RenderRepaintBoundary? boundary =
            key.currentContext?.findRenderObject() as RenderRepaintBoundary?;

        if (boundary == null || !boundary.debugNeedsPaint) {
          final image = await boundary!.toImage(pixelRatio: 3.0);
          final byteData = await image.toByteData(
            format: ui.ImageByteFormat.png,
          );
          final pngBytes = byteData!.buffer.asUint8List();

          final directory = await getExternalStorageDirectory(); // for Android
          final downloadPath = '${directory!.path}/$fileName.png';
          final file = File(downloadPath)..writeAsBytesSync(pngBytes);

          print("Image saved at $downloadPath");
        } else {
          print("Boundary not ready");
        }
      } else {
        print("Permission denied");
      }
    } catch (e) {
      debugPrint("Download failed: $e");
    }
  }
}
