enum TrackCategory { personal, work, home }

enum TrackType { income, expense }

class TrackData {
  const TrackData(
      {required this.name,
      required this.type,
      required this.value,
      required this.category,
      this.description = ''});
  final String name;
  final TrackType type;
  final int value;
  final TrackCategory category;
  final String description;

  int categoryNumber() {
    switch (category) {
      case TrackCategory.personal:
        {
          return 1;
        }
      case TrackCategory.work:
        {
          return 2;
        }
      case TrackCategory.home:
        {
          return 3;
        }
    }
  }

  bool isExpense() {
    switch (type) {
      case TrackType.expense:
        {
          return true;
        }
      case TrackType.income:
        {
          return false;
        }
    }
  }
}
