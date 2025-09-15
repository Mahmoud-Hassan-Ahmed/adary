import 'package:adary/features/adary/domain/entities/base_enity.dart';

class FileDownloadEneity extends BaseEnity {
  final int id;
  final String pathDownload;
  final bool print;

  FileDownloadEneity({
    required this.id,
    this.print = false,
    required this.pathDownload,
  });

  @override
  Map<String, dynamic> toJson() {
    // TODO: implement toJson
    throw UnimplementedError();
  }
}
