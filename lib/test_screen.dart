import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:share_plus/share_plus.dart';
import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

// ===============================
// WIDGET: ActionDropdown
// ===============================
class ActionDropdown extends StatelessWidget {
  final void Function()? onDownloadImage;
  final void Function()? onDownloadPdf;
  final void Function()? onShareImage;
  final void Function()? onSharePdf;

  const ActionDropdown({
    super.key,
    this.onDownloadImage,
    this.onDownloadPdf,
    this.onShareImage,
    this.onSharePdf,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildPopup(
          context,
          icon: Icons.download,
          tooltip: "Download",
          items: {"As Image": onDownloadImage, "As PDF": onDownloadPdf},
        ),
        const SizedBox(width: 10),
        _buildPopup(
          context,
          icon: Icons.share,
          tooltip: "Share",
          items: {"As Image": onShareImage, "As PDF": onSharePdf},
        ),
      ],
    );
  }

  Widget _buildPopup(
    BuildContext context, {
    required IconData icon,
    required String tooltip,
    required Map<String, VoidCallback?> items,
  }) {
    return PopupMenuButton<String>(
      tooltip: tooltip,
      icon: Icon(icon),
      onSelected: (value) {
        items[value]?.call();
      },
      itemBuilder: (context) {
        return items.keys.map((String choice) {
          return PopupMenuItem<String>(value: choice, child: Text(choice));
        }).toList();
      },
    );
  }
}

// ===============================
// UTILITY: ExportUtils
// ===============================
class ExportUtils {
  static final ScreenshotController _screenshotController =
      ScreenshotController();

  static Future<void> exportAsImage(GlobalKey previewContainerKey) async {
    try {
      RenderRepaintBoundary boundary =
          previewContainerKey.currentContext!.findRenderObject()
              as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      final directory = await getTemporaryDirectory();
      final imagePath = '${directory.path}/result.png';
      File(imagePath).writeAsBytesSync(pngBytes);

      await Share.shareXFiles([
        XFile(imagePath),
      ], text: 'Shared from Calculator App');
    } catch (e) {
      debugPrint('Error exporting image: $e');
    }
  }

  static Future<void> exportAsPdf(GlobalKey previewContainerKey) async {
    try {
      RenderRepaintBoundary boundary =
          previewContainerKey.currentContext!.findRenderObject()
              as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      final pdf = pw.Document();
      final imageProvider = pw.MemoryImage(pngBytes);

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Center(child: pw.Image(imageProvider));
          },
        ),
      );

      final output = await getTemporaryDirectory();
      final file = File("${output.path}/result.pdf");
      await file.writeAsBytes(await pdf.save());

      await Share.shareXFiles([
        XFile(file.path),
      ], text: 'PDF from Calculator App');
    } catch (e) {
      debugPrint('Error exporting PDF: $e');
    }
  }

  static Future<void> shareAsImage(GlobalKey previewContainerKey) async {
    await exportAsImage(previewContainerKey);
  }

  static Future<void> shareAsPdf(GlobalKey previewContainerKey) async {
    await exportAsPdf(previewContainerKey);
  }
}

// ===============================
// USAGE EXAMPLE IN UI
// ===============================
/*
Inside your calculator screen:

final GlobalKey previewKey = GlobalKey();

Column(
  children: [
    ActionDropdown(
      onDownloadImage: () => ExportUtils.exportAsImage(previewKey),
      onDownloadPdf: () => ExportUtils.exportAsPdf(previewKey),
      onShareImage: () => ExportUtils.shareAsImage(previewKey),
      onSharePdf: () => ExportUtils.shareAsPdf(previewKey),
    ),
    Expanded(
      child: RepaintBoundary(
        key: previewKey,
        child: CalculatorUI(...),
      ),
    ),
  ],
);
*/
