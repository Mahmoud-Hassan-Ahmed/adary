abstract class SelectModel {
  final int id;
  final String name;

  SelectModel({required this.id, required this.name});
}

class SessionModel extends SelectModel {
  SessionModel({required super.id, required super.name});
}

class IconModel extends SelectModel {
  final String type;
  final String value;
  IconModel(
      {required super.id,
      required super.name,
      required this.type,
      required this.value});
}

final List<IconModel> behaviorIcons = [
  // إيجابية
  IconModel(
      id: 1, name: '😊 إبتسامة', type: 'positive', value: 'bi bi-emoji-smile'),
  IconModel(
      id: 2, name: '😂 ضحك', type: 'positive', value: 'bi bi-emoji-laughing'),
  IconModel(id: 3, name: '⭐ نجمة', type: 'positive', value: 'bi bi-star'),
  IconModel(
      id: 4,
      name: '🌟 نجمة مملوءة',
      type: 'positive',
      value: 'bi bi-star-fill'),
  IconModel(id: 5, name: '❤️ قلب', type: 'positive', value: 'bi bi-heart'),
  IconModel(
      id: 6, name: '💖 قلب مملوء', type: 'positive', value: 'bi bi-heart-fill'),
  IconModel(id: 7, name: '🏆 جائزة', type: 'positive', value: 'bi bi-award'),
  IconModel(id: 8, name: '🥇 كأس', type: 'positive', value: 'bi bi-trophy'),
  IconModel(
      id: 9, name: '👍 إعجاب', type: 'positive', value: 'bi bi-hand-thumbs-up'),
  IconModel(
      id: 10,
      name: '👍 إعجاب مملوء',
      type: 'positive',
      value: 'bi bi-hand-thumbs-up-fill'),
  IconModel(
      id: 11,
      name: '✅ دائرة صح',
      type: 'positive',
      value: 'bi bi-check-circle'),
  IconModel(
      id: 12,
      name: '✅ دائرة صح مملوءة',
      type: 'positive',
      value: 'bi bi-check-circle-fill'),
  IconModel(
      id: 13,
      name: '📌 علامة تحقق',
      type: 'positive',
      value: 'bi bi-bookmark-check'),
  IconModel(
      id: 14,
      name: '⬆️ سهم للأعلى',
      type: 'positive',
      value: 'bi bi-arrow-up-circle'),
  IconModel(id: 15, name: '⚡ برق', type: 'positive', value: 'bi bi-lightning'),

  // سلبية
  IconModel(
      id: 16, name: '😔 عبوس', type: 'negative', value: 'bi bi-emoji-frown'),
  IconModel(
      id: 17, name: '😠 غضب', type: 'negative', value: 'bi bi-emoji-angry'),
  IconModel(
      id: 18,
      name: '👎 عدم إعجاب',
      type: 'negative',
      value: 'bi bi-hand-thumbs-down'),
  IconModel(
      id: 19,
      name: '👎 عدم إعجاب مملوء',
      type: 'negative',
      value: 'bi bi-hand-thumbs-down-fill'),
  IconModel(
      id: 20, name: '❌ دائرة خطأ', type: 'negative', value: 'bi bi-x-circle'),
  IconModel(
      id: 21,
      name: '❌ دائرة خطأ مملوءة',
      type: 'negative',
      value: 'bi bi-x-circle-fill'),
  IconModel(
      id: 22,
      name: '⚠️ دائرة تعجب',
      type: 'negative',
      value: 'bi bi-exclamation-circle'),
  IconModel(
      id: 23,
      name: '⚠️ مثلث تعجب',
      type: 'negative',
      value: 'bi bi-exclamation-triangle'),
  IconModel(
      id: 24,
      name: '⭕ دائرة مائلة',
      type: 'negative',
      value: 'bi bi-slash-circle'),
  IconModel(
      id: 25,
      name: '➖ دائرة ناقص',
      type: 'negative',
      value: 'bi bi-dash-circle'),
  IconModel(id: 26, name: '🚩 علم', type: 'negative', value: 'bi bi-flag'),
  IconModel(
      id: 27,
      name: '⬇️ سهم للأسفل',
      type: 'negative',
      value: 'bi bi-arrow-down-circle'),
  IconModel(
      id: 28,
      name: '⚡ شحنة برق',
      type: 'negative',
      value: 'bi bi-lightning-charge'),
  IconModel(id: 29, name: '⏰ ساعة', type: 'negative', value: 'bi bi-clock'),
  IconModel(id: 30, name: '🔔 جرس', type: 'negative', value: 'bi bi-bell'),
];

final List<SelectModel> sessionChoices = [
  SessionModel(id: 1, name: 'الأولة'), // The first
  SessionModel(id: 2, name: 'الثانية'), // The second
  SessionModel(id: 3, name: 'الثالثة'), // Third
  SessionModel(id: 4, name: 'الرابعة'), // Fourth
  SessionModel(id: 5, name: 'الخامسة'), // Fifth
  SessionModel(id: 6, name: 'السادسة'), // Six
  SessionModel(id: 7, name: 'السابعة'), // Seven
];
