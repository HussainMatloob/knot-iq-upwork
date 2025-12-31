import 'dart:io';
import 'package:flutter/material.dart';
import 'package:knot_iq/utils/colors.dart';
import 'package:photo_view/photo_view.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class DocumentViewScreen extends StatefulWidget {
  final String url; // Can be local path or network URL

  const DocumentViewScreen({super.key, required this.url});

  @override
  State<DocumentViewScreen> createState() => _DocumentViewScreenState();
}

class _DocumentViewScreenState extends State<DocumentViewScreen> {
  File? localFile;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    _prepareFile();
  }

  // Get file extension
  String get ext => widget.url.split('.').last.toLowerCase();

  bool get isImage =>
      ['jpg', 'jpeg', 'png', 'gif', 'webp', 'bmp'].contains(ext);
  bool get isPDF => ext == 'pdf';
  bool get isText => ['txt', 'csv'].contains(ext);
  bool get isDocument => ['doc', 'docx', 'xls', 'xlsx'].contains(ext);

  // Prepare local file for network PDFs / TXT
  Future<void> _prepareFile() async {
    final isNetwork = widget.url.startsWith('http');

    // Only download network PDF / TXT
    if (!isNetwork) return;

    if (isPDF || isText) {
      setState(() => loading = true);

      try {
        final response = await http.get(Uri.parse(widget.url));
        final dir = await getTemporaryDirectory();
        final file = File('${dir.path}/temp_file.$ext');
        await file.writeAsBytes(response.bodyBytes);

        setState(() {
          localFile = file;
          loading = false;
        });
      } catch (e) {
        setState(() => loading = false);
        print("Error downloading file: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Scaffold(
        appBar: AppBar(backgroundColor: Appcolors.whiteColor),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // ---------------- IMAGE VIEW ----------------
    if (isImage) {
      final imageProvider = widget.url.startsWith('http')
          ? NetworkImage(widget.url)
          : FileImage(File(widget.url)) as ImageProvider;

      return Scaffold(
        appBar: AppBar(backgroundColor: Appcolors.whiteColor),
        body: PhotoView(imageProvider: imageProvider),
      );
    }

    // ---------------- PDF VIEW ----------------
    if (isPDF) {
      final fileToUse = localFile ?? File(widget.url);
      if (!fileToUse.existsSync()) {
        return Scaffold(
          appBar: AppBar(title: Text("PDF Viewer")),
          body: Center(child: Text("PDF not found")),
        );
      }

      return Scaffold(
        appBar: AppBar(backgroundColor: Appcolors.whiteColor),
        body: SfPdfViewer.file(fileToUse),
      );
    }

    // ---------------- TEXT / CSV VIEW ----------------
    if (isText) {
      final fileToUse = localFile ?? File(widget.url);
      final content = fileToUse.existsSync()
          ? fileToUse.readAsStringSync()
          : "Cannot load file";

      return Scaffold(
        appBar: AppBar(backgroundColor: Appcolors.whiteColor),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Text(content),
        ),
      );
    }

    // ---------------- DOCUMENT ICON (DOC/DOCX/XLS/XLSX) ----------------
    if (isDocument) {
      return Scaffold(
        appBar: AppBar(backgroundColor: Appcolors.whiteColor),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.insert_drive_file, size: 80, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                "Cannot preview this file natively.\nConsider converting it to PDF.",
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    // ---------------- UNSUPPORTED ----------------
    return Scaffold(
      backgroundColor: Appcolors.whiteColor,
      appBar: AppBar(backgroundColor: Appcolors.whiteColor),
      body: Center(
        child: Text(
          "This file type cannot be previewed.",
          style: TextStyle(
            color: Appcolors.blackColor,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
