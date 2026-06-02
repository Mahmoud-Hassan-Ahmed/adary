import 'dart:io';

import 'package:adary/core/utils/app_utils.dart';
import 'package:adary/features/adary/data/models/evidence_model.dart';
import 'package:adary/features/adary/presentation/pages/rate_file.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart'
    show getApplicationDocumentsDirectory;
import 'package:permission_handler/permission_handler.dart';

class FileCard extends StatelessWidget {
  const FileCard({super.key, required this.model});
  final EvidenceTeacherModel model;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.teal, width: 1.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Top Row (Rating + Menu)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text("${model.rate.toStringAsFixed(1)}"),
                  const SizedBox(width: 4),
                  const Icon(Icons.star, color: Colors.orange, size: 16),
                ],
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert),
                onSelected: (value) {
                  // handle actions
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'download',
                    child: Text('تحميل'),
                    onTap: () async {
                      // await OpenFilex.open(model.file);
                      EasyLoading.show(status: 'جاري التحميل...');
                      try {
                        // صلاحية التخزين للاندرويد
                        if (Platform.isAndroid) {
                          Map<Permission, PermissionStatus> statuses = await [
                            Permission.photos,
                            Permission.storage,
                          ].request();

                          print(statuses);
                        }

                        Directory dir;

                        dir = await getApplicationDocumentsDirectory();

                        if (!await dir.exists()) {
                          await dir.create(recursive: true);
                        }

                        final filePath =
                            '${dir.path}/${model.file.split('/').last}';

                        // تحميل الملف
                        await Dio().download(
                          model.file,
                          filePath,
                          onReceiveProgress: (received, total) {
                            if (total != -1) {
                              print(
                                'Downloading: ${(received / total * 100).toStringAsFixed(0)}%',
                              );
                            }
                          },
                        );

                        print('File saved at: $filePath');

                        // فتح الملف
                        EasyLoading.dismiss();
                        final result = await OpenFilex.open(filePath);

                        print(result.type);
                        print(result.message);
                      } catch (e) {
                        print('Error: $e');
                      }
                    },
                  ),
                  PopupMenuItem(
                    onTap: () {
                      AppUtils.go(RateFile(file: model));
                    },
                    value: 'rate',
                    child: const Text('تقييم'),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),

          // PDF Icon
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
                model.typeFile == 'i'
                    ? Icons.insert_photo
                    : model.typeFile == 'w'
                        ? Icons.woo_commerce_rounded
                        : Icons.picture_as_pdf,
                color: Colors.white),
          ),

          const SizedBox(height: 12),

          // Name Chip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.teal,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              model.teacher.name,
              style: const TextStyle(color: Colors.white),
            ),
          ),

          const SizedBox(height: 8),

          // File Name
          Text(
            model.category?.name ?? '', // عرض اسم الملف فقط
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 4),

          // Date
          Text(
            "التاريخ: ${DateFormat('yyyy-MM-dd').format(DateTime.parse(model.createdAt))}",
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
