import 'dart:io';

import 'package:adary/core/conts/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FileInput extends StatefulWidget {
  const FileInput({
    super.key,
    required this.selectFile,
  });
  final ValueChanged<File> selectFile;

  @override
  State<FileInput> createState() => _FileInputState();
}

class _FileInputState extends State<FileInput> {
  var name = 'رفع الملف';
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['pdf'],
        );
        if (result != null) {
          widget.selectFile(File(result.files.first.path ?? ''));
          setState(() {
            name = result.files.first.name;
          });
        }
      },
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(20)),
            child: Center(
              child: Column(
                children: [
                  SvgPicture.asset(
                    'assets/icons/upload.svg',
                    width: 30,
                    height: 30,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    name,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontSize: 20,
                        color: Colors.grey.shade400,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          Text(
            'الملف يجب ان يكون بصيغة pdf والا يزيد حجمه عن 1 MB',
            style: Theme.of(context).textTheme.bodyMedium,
          )
        ],
      ),
    );
  }
}
