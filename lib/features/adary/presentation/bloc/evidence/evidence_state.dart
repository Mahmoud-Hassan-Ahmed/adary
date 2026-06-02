part of 'evidence_bloc.dart';

sealed class EvidenceState extends Equatable {
  const EvidenceState();
  static int num = 0;
  @override
  List<Object> get props => [num++];
}

final class EvidenceInitial extends EvidenceState {}

final class DoneGetEvidencesState extends EvidenceState {
  final PageinationModel<EvidenceTeacherModel> model;

  const DoneGetEvidencesState({required this.model});
}

final class DoneGetEvidencesCaregoriesState extends EvidenceState {
  final List<EvidenceCategoryModel> model;

  const DoneGetEvidencesCaregoriesState({required this.model});
}

final class DoneGetTeachersState extends EvidenceState {
  final List<Teacher> model;

  const DoneGetTeachersState({required this.model});
}

final class DoneAddCategoryEveidenceState extends EvidenceState {
  const DoneAddCategoryEveidenceState();
}

final class SelectModelState extends EvidenceState {
  final SelectModel model;
  final String type;

  const SelectModelState({required this.model, required this.type});
}

final class DoneRateFileState extends EvidenceState {
  const DoneRateFileState();
}
