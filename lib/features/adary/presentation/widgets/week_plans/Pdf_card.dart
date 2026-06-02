import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart' show PDFView;
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:pdfrx/pdfrx.dart';

class PdfCard extends StatelessWidget {
  final String pdfUrl;

  const PdfCard({
    super.key,
    required this.pdfUrl,
  });

  String get fileName => pdfUrl.split('/').last;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              /// PDF Preview
              Container(
                height: 170,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.teal, width: 1.5),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: PdfViewer.file(
                    pdfUrl,
                    // You'll need to ensure the file exists locally
                    // For network PDFs, download first or use PdfViewer.network
                  ),
                ),
              ),

              /// Popup Menu
              Positioned(
                top: 6,
                right: 6,
                child: PopupMenuButton<String>(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  onSelected: (value) {
                    if (value == "download") {
                      debugPrint("Download $pdfUrl");
                    } else if (value == "delete") {
                      debugPrint("Delete $pdfUrl");
                    }
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem(
                      value: "download",
                      child: Text("تحميل"),
                    ),
                    PopupMenuItem(
                      value: "delete",
                      child: Text("حذف"),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          /// Title
          const Text(
            "الخطة الأسبوعية",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 4),

          /// File name
          Text(
            fileName,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.black54),
          ),

          const SizedBox(height: 6),

          /// Date
          const Text(
            "1447/09/12",
            style: TextStyle(
              color: Colors.teal,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class PdfCardWithFlutterPdfView extends StatefulWidget {
  final String pdfUrl;

  const PdfCardWithFlutterPdfView({
    super.key,
    required this.pdfUrl,
  });

  @override
  State<PdfCardWithFlutterPdfView> createState() =>
      _PdfCardWithFlutterPdfViewState();
}

class _PdfCardWithFlutterPdfViewState extends State<PdfCardWithFlutterPdfView> {
  String? _localPath;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _downloadAndSavePdf();
  }

  Future<void> _downloadAndSavePdf() async {
    try {
      final directory = await getTemporaryDirectory();

      final fileName = widget.pdfUrl.split('/').last;
      final localFile = File('${directory.path}/$fileName');

      if (await localFile.exists()) {
        setState(() {
          _localPath = localFile.path;
          _isLoading = false;
        });
        return;
      }

      final response = await http.get(Uri.parse(widget.pdfUrl));

      if (response.statusCode == 200) {
        await localFile.writeAsBytes(response.bodyBytes);
        setState(() {
          _localPath = localFile.path;
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to download PDF');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 0.75, // 👈 مهم جدًا عشان يناسب 3 columns
      child: Container(
        margin: const EdgeInsets.all(4),
        child: Column(
          children: [
            // ===== TOP CARD (Preview) =====
            Expanded(
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.teal, width: 1.5),
                      color: Colors.grey[100],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: _buildPreview(),
                    ),
                  ),

                  // Popup menu
                  Positioned(
                    top: 4,
                    right: 4,
                    child: PopupMenuButton<String>(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      onSelected: (value) {
                        if (value == "download") {
                          debugPrint("Download ${widget.pdfUrl}");
                        } else if (value == "delete") {
                          debugPrint("Delete ${widget.pdfUrl}");
                        }
                      },
                      itemBuilder: (context) => const [
                        PopupMenuItem(
                          value: "download",
                          child: Text("تحميل"),
                        ),
                        PopupMenuItem(
                          value: "delete",
                          child: Text("حذف"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 6),

            // ===== TITLE =====
            const Text(
              "الخطة الأسبوعية",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),

            const SizedBox(height: 2),

            // ===== FILE NAME =====
            Text(
              widget.pdfUrl.split('/').last,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 10,
                color: Colors.black54,
              ),
            ),

            const SizedBox(height: 4),

            // ===== DATE =====
            const Text(
              "1447/09/12",
              style: TextStyle(
                color: Colors.teal,
                fontWeight: FontWeight.bold,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreview() {
    return PDFView(
      filePath: _localPath ?? '',
      enableSwipe: false, // Disable swipe for preview
      swipeHorizontal: false,
      autoSpacing: false,
      pageFling: false,
      backgroundColor: Colors.grey[200],
      onError: (error) {
        debugPrint('PDF View Error: ${error.toString()}');
        setState(() {
          _hasError = true;
        });
      },
      onPageError: (page, error) {
        debugPrint('Page $page error: ${error.toString()}');
      },
    );
  }
}
