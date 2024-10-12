class TaskGroup {
  int? id;
  String name;

  TaskGroup({this.id, required this.name});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory TaskGroup.fromMap(Map<String, dynamic> map) {
    return TaskGroup(
      id: map['id'],
      name: map['name'],
    );
  }
}
