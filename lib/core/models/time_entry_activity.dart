class TimeEntryActivity {
  const TimeEntryActivity({
    required this.id,
    required this.name,
    this.isDefault = false,
  });

  final int id;
  final String name;
  final bool isDefault;
}

