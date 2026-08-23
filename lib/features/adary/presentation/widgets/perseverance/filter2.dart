import 'package:adary/core/bloc/base_bloc.dart';
import 'package:adary/core/model/select_model.dart';
import 'package:adary/core/share/inputs/select_input.dart';
import 'package:adary/core/share/widgets/btn_app.dart';
import 'package:adary/core/share/widgets/date_widget.dart';
import 'package:adary/core/share/widgets/my_app_bar.dart';
import 'package:adary/features/adary/domain/entities/filter_report_entity.dart';
import 'package:adary/features/adary/presentation/bloc/perseverance/perseverance_bloc.dart';
import 'package:adary/features/adary/presentation/widgets/note_teacher/titile.dart';
import 'package:adary/injections/injection_main.dart';
import 'package:easy_localization/easy_localization.dart' as e;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';

class FilterWidget2 extends StatefulWidget {
  const FilterWidget2({super.key});

  @override
  State<FilterWidget2> createState() => _FilterWidget2State();
}

class _FilterWidget2State extends State<FilterWidget2> {
  SelectModel? valueTypeReport, valuePeroid, valueExport;
  SelectModel? valueClass;
  final formState = GlobalKey<FormState>();

  final List<SelectModel> typeReports = [
    IconModel(id: 1, name: 'تقرير المواظبة', value: 'attendance', type: ''),
    IconModel(id: 2, name: 'تقرير السلوك', value: 'behavior', type: ''),
    IconModel(id: 3, name: 'تقرير شامل', value: 'combined', type: ''),
  ];
  final List<SelectModel> peroids = [
    IconModel(id: 1, name: 'يومي', value: 'daily', type: ''),
    IconModel(id: 2, name: 'أسبوعياً', value: 'weekly', type: ''),
    IconModel(id: 3, name: 'شهري', value: 'monthly', type: ''),
    // IconModel(id: 4, name: 'مخصص', value: 'monthly', type: ''),
  ];
  final List<SelectModel> typeExport = [
    IconModel(id: 1, name: 'PDF', value: 'pdf', type: ''),
    IconModel(id: 2, name: 'Excel', value: 'excel', type: ''),
    // IconModel(id: 3, name: 'شهري', value: 'monthly', type: ''),
    // IconModel(id: 4, name: 'مخصص', value: 'monthly', type: ''),
  ];
  List<SelectModel> clsses = [];

  /// يتطلّب اكتمال الاختيارات قبل بناء الطلب، فقيمها تُحوَّل إلى IconModel.
  Future<void> _download() async {
    if (valueTypeReport is! IconModel ||
        valuePeroid is! IconModel ||
        valueExport is! IconModel) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('اختر نوع التقرير والفترة والصيغة'),
        ),
      );
      return;
    }

    final tempDir = await getTemporaryDirectory();
    final format = (valueExport as IconModel).value;
    final filePath = '${tempDir.path}/report.${format == 'excel' ? 'xlsx' : 'pdf'}';

    if (!mounted) return;
    BaseBloc.get<PerseveranceBloc>(context).add(
      DownloadReportEvent(
        entity: FilterReportEntity(
          reportClass: valueClass?.id ?? 0,
          reportFormat: format,
          reportPeriod: (valuePeroid as IconModel).value,
          Path: filePath,
          reportType: (valueTypeReport as IconModel).value,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<PerseveranceBloc>(),
      child: BlocBuilder<PerseveranceBloc, PerseveranceState>(
        builder: (context, state) {
          if (state is PerseveranceInitial) {
            BaseBloc.get<PerseveranceBloc>(context).add(GetClassesEvent());
          } else if (state is DoneGetClassesstate) {
            clsses = state.classes;
          }
          return Scaffold(
            appBar: MyAppBar(title: 'فلتر '),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Expanded(
                    child: BtnApp(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      label: 'تحميل',
                      onTap: _download,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: BtnApp(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      label: 'استعراض',
                      onTap: () => Navigator.pop(context),
                    ),
                  ),
                ],
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: formState,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // SizedBox(height: 20),
                    Titile(label: e.tr('نوع التقرير ')),
                    SelectInput(
                      items: typeReports,
                      onChanged: (v) {
                        setState(() {
                          valueTypeReport = v;
                        });
                      },
                      label: e.tr('نوع التقرير '),
                      selectedValue: valueTypeReport != null
                          ? valueTypeReport as SelectModel
                          : valueTypeReport,
                    ),
                    Titile(label: e.tr('الفترة')),
                    SelectInput(
                      items: peroids,
                      onChanged: (v) {
                        setState(() {
                          valuePeroid = v as IconModel;
                        });
                      },
                      label: e.tr('الفترة'),
                      selectedValue: valuePeroid,
                    ),
                    Titile(label: e.tr('أسم الفصل')),
                    SelectInput(
                      items: clsses,
                      onChanged: (v) {
                        setState(() {
                          valueClass = v;
                        });
                      },
                      label: e.tr('أسم الفصل'),
                      selectedValue: valueClass,
                    ),
                    // SizedBox(height: 20),
                    Titile(label: e.tr('الصيغة ')),
                    SelectInput(
                      items: typeExport,
                      onChanged: (v) {
                        setState(() {
                          valueExport = v as IconModel;
                        });
                      },
                      label: e.tr('الصيغة '),
                      selectedValue: valueExport,
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
