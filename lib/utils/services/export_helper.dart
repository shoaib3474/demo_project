import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';

class ExportHelper {
  static Future<void> exportAsImage(GlobalKey key, String fileName) async {
    try {
      RenderRepaintBoundary boundary =
          key.currentContext?.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      final directory = await getApplicationDocumentsDirectory();
      final imagePath = '${directory.path}/$fileName.png';
      final imageFile = File(imagePath)..writeAsBytesSync(pngBytes);

      Share.shareXFiles([XFile(imagePath)], text: 'Shared from my app');
    } catch (e) {
      SizedBox();
    }
  }

  static Future<void> exportAsPdf(GlobalKey key, String fileName) async {
    try {
      RenderRepaintBoundary boundary =
          key.currentContext?.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      final pdf = pw.Document();
      final imageWidget = pw.MemoryImage(pngBytes);

      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Center(child: pw.Image(imageWidget));
          },
        ),
      );

      final output = await getApplicationDocumentsDirectory();
      final file = File('${output.path}/$fileName.pdf');
      await file.writeAsBytes(await pdf.save());

      Share.shareXFiles([XFile(file.path)], text: 'Here is your report PDF!');
    } catch (e) {
      SizedBox();
    }
  }
}

// buttons
class ExportButtons extends StatelessWidget {
  final GlobalKey exportKey;
  final String fileName;

  const ExportButtons({
    super.key,
    required this.exportKey,
    required this.fileName,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton.icon(
          icon: const Icon(Icons.image),
          label: const Text("Export Image"),
          onPressed: () => ExportHelper.exportAsImage(exportKey, fileName),
        ),
        const SizedBox(width: 10),
        ElevatedButton.icon(
          icon: const Icon(Icons.picture_as_pdf),
          label: const Text("Export PDF"),
          onPressed: () => ExportHelper.exportAsPdf(exportKey, fileName),
        ),
      ],
    );
  }
}
