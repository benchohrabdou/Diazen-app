/// Dose calculation service for Functional Insulin Therapy (FIT).
/// Pure computation engine without UI or state side-effects.
library;

class HypoglycemiaException implements Exception {
  final String message;
  const HypoglycemiaException([
    this.message = 'Treat the low first and recheck before taking insulin',
  ]);

  @override
  String toString() => message;
}

const Map<String, double> activityIntensityFactors = {
  'light': 0.8,
  'moderate': 1.0,
  'vigorous': 1.2,
  'intense': 1.4,
  'none': 1.0,
};

/// Returns the intensity multiplier for a given activity intensity level.
double getActivityIntensityFactor(String intensity) {
  return activityIntensityFactors[intensity.toLowerCase()] ?? 1.0;
}

/// Returns the reduction percentage based on total calories burned.
///
/// Calorie boundary table:
/// - <= 50 kcal: 5%
/// - 51 - 100 kcal: 10%
/// - 101 - 150 kcal: 15%
/// - 151 - 200 kcal: 20%
/// - 201 - 250 kcal: 25%
/// - 251 - 300 kcal: 30%
/// - 301 - 400 kcal: 35%
/// - 401 - 500 kcal: 40%
/// - 501 - 600 kcal: 50%
/// - > 600 kcal: 60%
double getReductionPercentFromCalories(double totalCalories) {
  if (totalCalories <= 50) return 5.0;
  if (totalCalories <= 100) return 10.0;
  if (totalCalories <= 150) return 15.0;
  if (totalCalories <= 200) return 20.0;
  if (totalCalories <= 250) return 25.0;
  if (totalCalories <= 300) return 30.0;
  if (totalCalories <= 400) return 35.0;
  if (totalCalories <= 500) return 40.0;
  if (totalCalories <= 600) return 50.0;
  return 60.0;
}

class DoseCalculationResult {
  final double totalDose;
  final double mealDose;
  final double correctionDose;
  final double totalDoseBeforeActivity;
  final double unplannedActivityCalories;
  final double unplannedReductionPercent;
  final double unplannedReductionUnits;
  final double plannedActivityCalories;
  final double plannedReductionPercent;
  final double plannedReductionUnits;
  final double totalActivityReduction;

  const DoseCalculationResult({
    required this.totalDose,
    required this.mealDose,
    required this.correctionDose,
    required this.totalDoseBeforeActivity,
    required this.unplannedActivityCalories,
    required this.unplannedReductionPercent,
    required this.unplannedReductionUnits,
    required this.plannedActivityCalories,
    required this.plannedReductionPercent,
    required this.plannedReductionUnits,
    required this.totalActivityReduction,
  });

  /// Alias for totalDose.
  double get dose => totalDose;
}

/// Pure function that computes prandial insulin dose according to FIT principles.
///
/// Throws [ArgumentError] if:
/// - [glucose] is outside 20 - 600 mg/dL.
/// - [carbs] is outside 0 - 300 g.
/// - [icr] <= 0 or [isf] <= 0.
///
/// Throws [HypoglycemiaException] if:
/// - [glucose] < 70 mg/dL.
DoseCalculationResult calculateDose({
  required double glucose,
  required double carbs,
  required double icr,
  required double isf,
  double targetGlucose = 100.0,
  bool unplannedActivity = false,
  double unplannedCalories = 0.0,
  int unplannedDuration = 30,
  String unplannedIntensity = 'none',
  bool plannedActivity = false,
  double plannedCalories = 0.0,
  int plannedDuration = 30,
  String plannedIntensity = 'none',
}) {
  // Safety checks
  if (glucose < 20 || glucose > 600) {
    throw ArgumentError(
      'Blood glucose must be between 20 and 600 mg/dL (was $glucose)',
    );
  }

  if (glucose < 70) {
    throw const HypoglycemiaException(
      'Treat the low first and recheck before taking insulin',
    );
  }

  if (carbs < 0 || carbs > 300) {
    throw ArgumentError(
      'Carbohydrates must be between 0 and 300 g (was $carbs)',
    );
  }

  if (icr <= 0 || isf <= 0) {
    throw ArgumentError(
      'Medical information invalid: ICR and ISF must be greater than 0.',
    );
  }

  // 1. Meal dose
  final double mealDose = carbs / icr;

  // 2. Correction dose
  final double correctionDose = (glucose - targetGlucose) / isf;

  // 3. Total dose before activity adjustments
  final double totalDoseBeforeActivity = mealDose + correctionDose;

  // 4. Activity reductions
  double totalActivityReduction = 0.0;

  double unplannedActivityCalories = 0.0;
  double unplannedReductionPercent = 0.0;
  double unplannedReductionUnits = 0.0;

  if (unplannedActivity) {
    unplannedActivityCalories =
        unplannedCalories * (unplannedDuration / 30.0);
    final double intensityFactor =
        getActivityIntensityFactor(unplannedIntensity);
    unplannedActivityCalories *= intensityFactor;
    unplannedReductionPercent =
        getReductionPercentFromCalories(unplannedActivityCalories);
    unplannedReductionUnits =
        totalDoseBeforeActivity * (unplannedReductionPercent / 100.0);
    totalActivityReduction += unplannedReductionUnits;
  }

  double plannedActivityCalories = 0.0;
  double plannedReductionPercent = 0.0;
  double plannedReductionUnits = 0.0;

  if (plannedActivity) {
    plannedActivityCalories = plannedCalories * (plannedDuration / 30.0);
    final double intensityFactor =
        getActivityIntensityFactor(plannedIntensity);
    plannedActivityCalories *= intensityFactor;
    plannedReductionPercent =
        getReductionPercentFromCalories(plannedActivityCalories);
    plannedReductionUnits =
        totalDoseBeforeActivity * (plannedReductionPercent / 100.0);
    totalActivityReduction += plannedReductionUnits;
  }

  // 5. Final dose clamped at 0
  final double rawTotalDose = totalDoseBeforeActivity - totalActivityReduction;
  final double totalDose = rawTotalDose.clamp(0.0, double.infinity);

  return DoseCalculationResult(
    totalDose: totalDose,
    mealDose: mealDose,
    correctionDose: correctionDose,
    totalDoseBeforeActivity: totalDoseBeforeActivity,
    unplannedActivityCalories: unplannedActivityCalories,
    unplannedReductionPercent: unplannedReductionPercent,
    unplannedReductionUnits: unplannedReductionUnits,
    plannedActivityCalories: plannedActivityCalories,
    plannedReductionPercent: plannedReductionPercent,
    plannedReductionUnits: plannedReductionUnits,
    totalActivityReduction: totalActivityReduction,
  );
}
