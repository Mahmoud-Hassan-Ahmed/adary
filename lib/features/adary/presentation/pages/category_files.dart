import 'package:adary/core/bloc/base_bloc.dart';
import 'package:adary/core/share/widgets/my_app_bar.dart';
import 'package:adary/features/adary/data/models/evidence_model.dart';
import 'package:adary/features/adary/presentation/bloc/evidence/evidence_bloc.dart';
import 'package:adary/features/adary/presentation/widgets/performance/caegory_item.dart';
import 'package:adary/injections/injection_main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryFiles extends StatelessWidget {
  const CategoryFiles({super.key});
  @override
  Widget build(BuildContext context) {
    List<EvidenceCategoryModel> list = [];

    return BlocProvider(
      create: (context) => sl<EvidenceBloc>(),
      child: BlocBuilder<EvidenceBloc, EvidenceState>(
        builder: (context, state) {
          if (state is EvidenceInitial) {
            BaseBloc.get<EvidenceBloc>(context)
                .add(const GetEvidencesCaregoriesEvent());
          } else if (state is DoneGetEvidencesCaregoriesState) {
            list = state.model;
          }
          return RefreshIndicator(
            onRefresh: () async {
              BaseBloc.get<EvidenceBloc>(context)
                  .add(const GetEvidencesCaregoriesEvent());
            },
            child: ListView(
              children: list
                  .map((e) => CategoryItem(
                        model: e,
                      ))
                  .toList(),
            ),
          );
        },
      ),
    );
  }
}
