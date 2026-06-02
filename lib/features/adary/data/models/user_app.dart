class DataFollower {
  final String last_time_notes,
      last_time_circular,
      num_health_today,
      visits,
      num_week_day_active,
      socila_status,
      performance,
      classes,
      managements,
      behavior;

  DataFollower(
      {required this.last_time_notes,
      required this.last_time_circular,
      required this.num_health_today,
      required this.visits,
      required this.num_week_day_active,
      required this.socila_status,
      required this.performance,
      required this.classes,
      required this.managements,
      required this.behavior});

  factory DataFollower.fromJson(Map<String, dynamic> json) => DataFollower(
      last_time_notes: json['last_time_notes'],
      last_time_circular: json['last_time_circular'],
      num_health_today: json['num_health_today'],
      visits: json['visits'],
      num_week_day_active: json['num_week_day_active'],
      socila_status: json['socila_status'],
      performance: json['performance'],
      classes: json['classes'],
      managements: json['managements'],
      behavior: json['managements']);
}

class AppUser {
  final String school;
  final String username;
  final String schoolSystem;
  final int dateSystem;
  final DataFollower? data_follower;
  final bool isSmartbleActive;
  final String ky;
  final bool isFollowerActive;
  final SmartblePlanInfo smartblePlanInfo;
  final FollowerPlanInfo followerPlanInfo;
  final WhatsappService whatsappService;
  final WhatsappService? smsService;
  final String? password;
  final int id;
  final String? logo;

  AppUser({
    required this.school,
    required this.username,
    required this.schoolSystem,
    required this.dateSystem,
    required this.isSmartbleActive,
    required this.isFollowerActive,
    required this.smartblePlanInfo,
    required this.followerPlanInfo,
    required this.whatsappService,
    this.data_follower,
    required this.smsService,
    required this.ky,
    required this.id,
    required this.password,
    this.logo,
  });

  // Factory method to create an instance from JSON
  factory AppUser.fromJson(Map<String, dynamic> json, {String? password}) {
    return AppUser(
      id: json['id'],
      school: json['school'],
      data_follower: json['data_follower'] != null
          ? DataFollower.fromJson(json['data_follower'])
          : null,
      ky: json['app-key'] ?? '',
      username: json['username'],
      logo: json['logo'],
      password: password,
      schoolSystem: json['school_system'],
      dateSystem: json['date_system'],
      isSmartbleActive: json['is_smartble_active'] ?? false,
      isFollowerActive: json['is_follower_active'] ?? false,
      smartblePlanInfo: SmartblePlanInfo.fromJson(json['smartble_plan_info']),
      followerPlanInfo: FollowerPlanInfo.fromJson(json['follower_plan_info']),
      whatsappService: WhatsappService.fromJson(json['whatsapp_service']),
      smsService: json['smsService'] != null
          ? WhatsappService.fromJson(json['smsService'])
          : null,
    );
  }

  factory AppUser.fromJsom2(AppUser? user, Map<String, dynamic> json) =>
      AppUser(
        id: json['id'],
        school: json['school'],
        username: json['username'],
        ky: user?.ky ?? json['app-key'] ?? '',
        schoolSystem: json['school_system'],
        logo: json['logo'],
        dateSystem: json['date_system'],
        isSmartbleActive: json['is_smartble_active'],
        isFollowerActive: json['is_follower_active'],
        password: user?.password ?? json['password'],
        smartblePlanInfo: SmartblePlanInfo.fromJson(json['smartble_plan_info']),
        followerPlanInfo: FollowerPlanInfo.fromJson(json['follower_plan_info']),
        whatsappService: WhatsappService.fromJson(json['whatsapp_service']),
        smsService: json['smsService'] != null
            ? WhatsappService.fromJson(json['smsService'])
            : null,
      );
  // Convert the instance to JSON
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      'school': school,
      'username': username,
      'school_system': schoolSystem,
      'date_system': dateSystem,
      'logo': logo,
      'app-key': ky,
      'is_smartble_active': isSmartbleActive,
      'is_follower_active': isFollowerActive,
      'smartble_plan_info': smartblePlanInfo.toJson(),
      'follower_plan_info': followerPlanInfo.toJson(),
      'whatsapp_service': whatsappService.toJson(),
      'smsService:': smsService?.toJson(),
      "password": password,
    };
  }
}

class SmartblePlanInfo {
  final bool isActive;
  final String? planName;
  final bool isTrial;
  final String? trialMessage;
  final String? expireAt;

  SmartblePlanInfo({
    required this.isActive,
    required this.planName,
    required this.isTrial,
    required this.trialMessage,
    required this.expireAt,
  });

  // Factory method to create an instance from JSON
  factory SmartblePlanInfo.fromJson(Map<String, dynamic> json) {
    return SmartblePlanInfo(
      isActive: json['is_active'],
      planName: json['plan_name'],
      isTrial: json['is_trial'],
      trialMessage: json['trial_message'],
      expireAt: json['expire_at'],
    );
  }

  // Convert the instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'is_active': isActive,
      'plan_name': planName,
      'is_trial': isTrial,
      'trial_message': trialMessage,
      'expire_at': expireAt,
    };
  }
}

class FollowerPlanInfo {
  final bool isActive;
  final String? planName;
  final bool isTrial;
  final String? trialMessage;
  final String? expireAt;

  FollowerPlanInfo({
    required this.isActive,
    required this.planName,
    required this.isTrial,
    required this.trialMessage,
    required this.expireAt,
  });

  // Factory method to create an instance from JSON
  factory FollowerPlanInfo.fromJson(Map<String, dynamic> json) {
    return FollowerPlanInfo(
      isActive: json['is_active'],
      planName: json['plan_name'],
      isTrial: json['is_trial'],
      trialMessage: json['trial_message'],
      expireAt: json['expire_at'],
    );
  }

  // Convert the instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'is_active': isActive,
      'plan_name': planName,
      'is_trial': isTrial,
      'trial_message': trialMessage,
      'expire_at': expireAt,
    };
  }
}

class WhatsappService {
  final bool isActive;
  final int remaining;

  WhatsappService({
    required this.isActive,
    required this.remaining,
  });

  // Factory method to create an instance from JSON
  factory WhatsappService.fromJson(Map<String, dynamic> json) {
    return WhatsappService(
      isActive: json['is_active'],
      remaining: int.tryParse(json['remaining'].toString()) ?? 0,
    );
  }

  // Convert the instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'is_active': isActive,
      'remaining': remaining,
    };
  }
}

// class AppUser {
//   final PlanInfo? smartblePlanInfo;
//   final PlanInfo? followerPlanInfo;
//   final WhatsAppService? whatsappService;
//   final String username;
//   final String ky;
//   final String name;
//   final String? school;
//   final String? schoolSystem;
//   final int? dateSystem;
//   final bool? isSmartbleActive;
//   final bool? isFollowerActive;

//   AppUser({
//     required this.username,
//     required this.ky,
//     required this.name,
//     this.school,
//     this.schoolSystem,
//     this.dateSystem,
//     this.isSmartbleActive,
//     this.isFollowerActive,
//   });
//   factory AppUser.fromJsom(Map<String, dynamic> json) => AppUser(
//         username: json['username'],
//         ky: json['app-key'],
//         name: json['name'],
//       );
//   factory AppUser.fromJsom2(AppUser? user, Map<String, dynamic> json) =>
//       AppUser(
//           username: user?.username ?? json['username'],
//           ky: user?.ky ?? json['ky'],
//           name: user?.name ?? json['name'],
//           dateSystem: json['date_system'],
//           isFollowerActive: json['is_smartble_active'],
//           isSmartbleActive: json['is_smartble_active'],
//           schoolSystem: json['school_system']);

//   Map<String, dynamic> toJson() => {
//         "username": username,
//         "app-key": ky,
//         "name": name,
//         'school_system': schoolSystem,
//         'date_system': dateSystem,
//         'is_smartble_active': isSmartbleActive,
//         'is_follower_active': isFollowerActive
//       };
// }
