class Classroom {
  final int id;
  final String name;
  final int studentCount;

  Classroom({
    required this.id,
    required this.name,
    required this.studentCount,
  });

  // Factory method to create an instance from a map
  factory Classroom.fromMap(Map<String, dynamic> map) {
    return Classroom(
      id: map['id'],
      name: map['name'],
      studentCount: map['student_count'],
    );
  }
}
