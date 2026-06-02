import 'package:adary/features/adary/domain/entities/base_enity.dart';

class FilterReportEntity extends BaseEnity {
  final int reportClass;
  final String reportFormat;
  final String reportPeriod;
  final String reportType;
  final String Path;

  FilterReportEntity(
      {required this.reportClass,
      required this.reportFormat,
      required this.reportPeriod,
      required this.Path,
      required this.reportType});

  @override
  Map<String, dynamic> toJson() => {
        "reportClass": reportClass,
        "reportFormat": reportFormat,
        "reportPeriod": reportPeriod,
        "reportType": reportType
      };
}
