abstract class SelectModel {
  final int id;
  final String name;

  SelectModel({required this.id, required this.name});
}

class SessionModel extends SelectModel {
  SessionModel({required super.id, required super.name});
}

final List<SelectModel> sessionChoices = [
  SessionModel(id: 1, name: 'الأولة'), // The first
  SessionModel(id: 2, name: 'الثانية'), // The second
  SessionModel(id: 3, name: 'الثالثة'), // Third
  SessionModel(id: 4, name: 'الرابعة'), // Fourth
  SessionModel(id: 5, name: 'الخامسة'), // Fifth
  SessionModel(id: 6, name: 'السادسة'), // Six
  SessionModel(id: 7, name: 'السابعة'), // Seven
];
