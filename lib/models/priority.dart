enum Priority {
  low(1),
  medium(2),
  high(3);

  final int level;

  const Priority(this.level);


  factory Priority.fromString(String value) {
    return switch (value.toLowerCase()) {
      "low" => Priority.low,
      "medium" => Priority.medium,
      "high" => Priority.high,
      _ => throw ArgumentError("Unknown priority: $value"),
    };
  }


  String get displayName {
    return name.toUpperCase();
  }
}