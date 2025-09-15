class ClassHealth {
  final int id;
  final String name;
  final int healthCount;

  ClassHealth({
    required this.id,
    required this.name,
    required this.healthCount,
  });

  factory ClassHealth.fromMap(Map<String, dynamic> map) {
    return ClassHealth(
      id: map['id'],
      name: map['name'],
      healthCount: map['healthcondition_count'],
    );
  }
}
