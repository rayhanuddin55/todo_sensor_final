class Task {
  final int? id;
  final String title;
  final int groupId;
  final DateTime? dueDate;
  final String? note;
  final bool isComplete;

  Task({
    this.id,
    required this.title,
    required this.groupId,
    this.dueDate,
    this.note,
    this.isComplete = false,
  });

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      groupId: map['groupId'],
      dueDate: map['dueDate'] != null ? DateTime.parse(map['dueDate']) : null,
      note: map['note'],
      isComplete: map['isComplete'] == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'groupId': groupId,
      'dueDate': dueDate?.toIso8601String(),
      'note': note,
      'isComplete': isComplete ? 1 : 0,
    };
  }

  Task copyWith({
    int? id,
    String? title,
    int? groupId,
    DateTime? dueDate,
    String? note,
    bool? isComplete,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      groupId: groupId ?? this.groupId,
      dueDate: dueDate ?? this.dueDate,
      note: note ?? this.note,
      isComplete: isComplete ?? this.isComplete,
    );
  }
}
