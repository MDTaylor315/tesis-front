class MealItem {
  final String name;
  final String details;
  final int kcal;
  final String prot;
  final String fat;
  final String carb;
  final bool isCompleted;

  MealItem({
    required this.name,
    required this.details,
    required this.kcal,
    required this.prot,
    required this.fat,
    required this.carb,
    this.isCompleted = false,
  });
}
