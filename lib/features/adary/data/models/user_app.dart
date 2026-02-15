class AppUser {
  final String school;
  final String username;
  final String schoolSystem;
  final int dateSystem;
  final bool isSmartbleActive;
  final String ky;
  final bool isFollowerActive;
  final SmartblePlanInfo smartblePlanInfo;
  final FollowerPlanInfo followerPlanInfo;
  final WhatsappService whatsappService;
  final WhatsappService? smsService;
  final String? password;

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
    required this.smsService,
    required this.ky,
    required this.password,
  });

  // Factory method to create an instance from JSON
  factory AppUser.fromJson(Map<String, dynamic> json, {String? password}) {
    return AppUser(
      school: json['school'],
      ky: json['app-key'] ?? '',
      username: json['username'],
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
        school: json['school'],
        username: json['username'],
        ky: user?.ky ?? json['app-key'] ?? '',
        schoolSystem: json['school_system'],
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
      'school': school,
      'username': username,
      'school_system': schoolSystem,
      'date_system': dateSystem,
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
