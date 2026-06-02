part of 'evidence_bloc.dart';

sealed class EvidenceEvent extends Equatable {
  const EvidenceEvent();

  @override
  List<Object> get props => [];
}

final class GetEvidencesEvent extends EvidenceEvent {
  final EvidencePaginationEntity entity;

  const GetEvidencesEvent({required this.entity});
}

final class GetEvidencesCaregoriesEvent extends EvidenceEvent {
  const GetEvidencesCaregoriesEvent();
}

final class GetTeachersEvent extends EvidenceEvent {
  const GetTeachersEvent();
}

final class AddCategoryEveidenceEvent extends EvidenceEvent {
  final EvidenceCategoryModel entity;

  const AddCategoryEveidenceEvent({required this.entity});
}

final class RateFileEvent extends EvidenceEvent {
  final EvidenceTeacherModel entity;

  const RateFileEvent({required this.entity});
}
