import 'package:adary/features/adary/domain/entities/base_enity.dart';

class Planning extends BaseEnity {
  final int id;
  final int clarityLesson;
  final int lessonContentAppropriate;
  final int appropriateEducationalMethods;
  final String note;

  Planning({
    required this.id,
    required this.clarityLesson,
    required this.lessonContentAppropriate,
    required this.appropriateEducationalMethods,
    required this.note,
  });

  factory Planning.fromJson(Map<String, dynamic> json) {
    return Planning(
      id: json['id'] ?? 0,
      clarityLesson: json['clarity_lesson'] ?? 0,
      lessonContentAppropriate: json['lesson_content_appropriate'] ?? 0,
      appropriateEducationalMethods:
          json['appropriate_educational_methods'] ?? 0,
      note: json['note'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'clarity_lesson': clarityLesson,
      'lesson_content_appropriate': lessonContentAppropriate,
      'appropriate_educational_methods': appropriateEducationalMethods,
      'note': note,
    };
  }
}

class Implementation extends BaseEnity {
  final int id;
  final int clarityExplanation;
  final int diversityStrategies;
  final int investTime;
  final String note;

  Implementation({
    required this.id,
    required this.clarityExplanation,
    required this.diversityStrategies,
    required this.investTime,
    required this.note,
  });

  factory Implementation.fromJson(Map<String, dynamic> json) {
    return Implementation(
      id: json['id'] ?? 0,
      clarityExplanation: json['clarity_explanation'] ?? 0,
      diversityStrategies: json['diversity_strategies'] ?? 0,
      investTime: json['invest_time'] ?? 0,
      note: json['note'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'clarity_explanation': clarityExplanation,
      'diversity_strategies': diversityStrategies,
      'invest_time': investTime,
      'note': note,
    };
  }
}

class Interaction extends BaseEnity {
  final int id;
  final int studentInteraction;
  final int variousEvaluation;
  final int provideFeed;
  final String note;

  Interaction({
    required this.id,
    required this.studentInteraction,
    required this.variousEvaluation,
    required this.provideFeed,
    required this.note,
  });

  factory Interaction.fromJson(Map<String, dynamic> json) {
    return Interaction(
      id: json['id'] ?? 0,
      studentInteraction: json['student_interaction'] ?? 0,
      variousEvaluation: json['various_evaluation'] ?? 0,
      provideFeed: json['provide_feed'] ?? 0,
      note: json['note'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'student_interaction': studentInteraction,
      'various_evaluation': variousEvaluation,
      'provide_feed': provideFeed,
      'note': note,
    };
  }
}

class Managment extends BaseEnity {
  final int id;
  final int controllingStudentBehavior;
  final int organizingClassroom;
  final int investClassTime;
  final String note;

  Managment({
    required this.id,
    required this.controllingStudentBehavior,
    required this.organizingClassroom,
    required this.investClassTime,
    required this.note,
  });

  factory Managment.fromJson(Map<String, dynamic> json) {
    return Managment(
      id: json['id'] ?? 0,
      controllingStudentBehavior: json['controlling_student_behavior'] ?? 0,
      organizingClassroom: json['organizing_classroom'] ?? 0,
      investClassTime: json['invest_class_time'] ?? 0,
      note: json['note'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'controlling_student_behavior': controllingStudentBehavior,
      'organizing_classroom': organizingClassroom,
      'invest_class_time': investClassTime,
      'note': note,
    };
  }
}

class EvaluationModel {
  final int id;
  final Planning? planning;
  final Implementation? implementation;
  final Interaction? interaction;
  final Managment? managment;

  final double overallEvaluation;
  final double visitEvaluation;
  final double planingEvaluation;
  final double implementationEvaluation;
  final double interactionEvaluation;
  final double managementEvaluation;

  final String visitEvaluationNote;
  final String strengths;
  final String areasImprovement;
  final String recommendations;

  EvaluationModel({
    required this.id,
    required this.planning,
    required this.implementation,
    required this.interaction,
    required this.managment,
    required this.overallEvaluation,
    required this.visitEvaluation,
    required this.planingEvaluation,
    required this.implementationEvaluation,
    required this.managementEvaluation,
    required this.interactionEvaluation,
    required this.visitEvaluationNote,
    required this.strengths,
    required this.areasImprovement,
    required this.recommendations,
  });

  factory EvaluationModel.fromJson(Map<String, dynamic> json) {
    return EvaluationModel(
      id: json['id'] ?? 0,
      planning:
          json['planing'] != null ? Planning.fromJson(json['planing']) : null,
      implementation: json['implementation'] != null
          ? Implementation.fromJson(json['implementation'])
          : null,
      interaction: json['interaction'] != null
          ? Interaction.fromJson(json['interaction'])
          : null,
      managment: json['managment'] != null
          ? Managment.fromJson(json['managment'])
          : null,
      overallEvaluation:
          double.tryParse(json['overall_evaluation']?.toString() ?? '0') ?? 0,
      visitEvaluation:
          double.tryParse(json['visit_evaluation']?.toString() ?? '0') ?? 0,
      planingEvaluation:
          double.tryParse(json['planing_evaluation']?.toString() ?? '0') ?? 0,
      implementationEvaluation: double.tryParse(
              json['implementation_evaluation']?.toString() ?? '0') ??
          0,
      interactionEvaluation:
          double.tryParse(json['interaction_evaluation']?.toString() ?? '0') ??
              0,
      managementEvaluation:
          double.tryParse(json['managment_evaluation']?.toString() ?? '0') ?? 0,
      visitEvaluationNote: json['visit_evaluation_note'] ?? '',
      strengths: json['strengths'] ?? '',
      areasImprovement: json['areas_improvement'] ?? '',
      recommendations: json['recommendations'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'planning': planning?.toJson(),
      'implementation': implementation?.toJson(),
      'interaction': interaction?.toJson(),
      'managment': managment?.toJson(),
      'overall_evaluation': overallEvaluation,
      'visit_evaluation': visitEvaluation,
      'planing_evaluation': planingEvaluation,
      'implementation_evaluation': implementationEvaluation,
      'interaction_evaluation': interactionEvaluation,
      'visit_evaluation_note': visitEvaluationNote,
      'strengths': strengths,
      'areas_improvement': areasImprovement,
      'recommendations': recommendations,
    };
  }
}
