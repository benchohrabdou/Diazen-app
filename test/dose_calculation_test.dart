import 'package:diazen/classes/injection.dart';
import 'package:diazen/services/dose_calculator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Dose Calculator Pure Function Tests', () {
    test('Standard dose calculation: carbs and correction without activity', () {
      // carbs: 60g, ICR: 10 => mealDose = 6 units
      // glucose: 150 mg/dL, target: 100 mg/dL, ISF: 50 => correctionDose = 1 unit
      // totalDose = 7 units
      final result = calculateDose(
        glucose: 150.0,
        carbs: 60.0,
        icr: 10.0,
        isf: 50.0,
        targetGlucose: 100.0,
      );

      expect(result.mealDose, closeTo(6.0, 0.001));
      expect(result.correctionDose, closeTo(1.0, 0.001));
      expect(result.totalDoseBeforeActivity, closeTo(7.0, 0.001));
      expect(result.totalDose, closeTo(7.0, 0.001));
      expect(result.dose, closeTo(7.0, 0.001));
    });

    test('Unplanned activity with moderate intensity (100 kcal -> 10% reduction)', () {
      // Total before activity = 7 units
      // Unplanned activity: 100 kcal base (30 min), duration 30 min, moderate (factor 1.0)
      // 100 kcal falls in 51-100 kcal bracket => 10% reduction
      // Reduction = 7 * 0.10 = 0.7 units => final dose = 6.3 units
      final result = calculateDose(
        glucose: 150.0,
        carbs: 60.0,
        icr: 10.0,
        isf: 50.0,
        targetGlucose: 100.0,
        unplannedActivity: true,
        unplannedCalories: 100.0,
        unplannedDuration: 30,
        unplannedIntensity: 'moderate',
      );

      expect(result.unplannedActivityCalories, closeTo(100.0, 0.001));
      expect(result.unplannedReductionPercent, equals(10.0));
      expect(result.unplannedReductionUnits, closeTo(0.7, 0.001));
      expect(result.totalDose, closeTo(6.3, 0.001));
    });

    test('Planned activity with vigorous intensity factor (1.2)', () {
      // 200 kcal base, duration 30 min, vigorous (factor 1.2) => 240 kcal
      // 240 kcal falls in 201-250 bracket => 25% reduction
      // Total before activity = 7 units
      // Reduction = 7 * 0.25 = 1.75 units => final dose = 5.25 units
      final result = calculateDose(
        glucose: 150.0,
        carbs: 60.0,
        icr: 10.0,
        isf: 50.0,
        targetGlucose: 100.0,
        plannedActivity: true,
        plannedCalories: 200.0,
        plannedDuration: 30,
        plannedIntensity: 'vigorous',
      );

      expect(result.plannedActivityCalories, closeTo(240.0, 0.001));
      expect(result.plannedReductionPercent, equals(25.0));
      expect(result.plannedReductionUnits, closeTo(1.75, 0.001));
      expect(result.totalDose, closeTo(5.25, 0.001));
    });

    test('Both planned and unplanned activities combined', () {
      // Total before activity = 10 units (carbs 100 / 10 = 10, glucose = target)
      // Unplanned: 50 kcal, light (factor 0.8) => 40 kcal => 5% reduction (0.5 units)
      // Planned: 100 kcal, moderate (factor 1.0) => 100 kcal => 10% reduction (1.0 unit)
      // Total reduction = 1.5 units => final dose = 8.5 units
      final result = calculateDose(
        glucose: 100.0,
        carbs: 100.0,
        icr: 10.0,
        isf: 50.0,
        targetGlucose: 100.0,
        unplannedActivity: true,
        unplannedCalories: 50.0,
        unplannedDuration: 30,
        unplannedIntensity: 'light',
        plannedActivity: true,
        plannedCalories: 100.0,
        plannedDuration: 30,
        plannedIntensity: 'moderate',
      );

      expect(result.unplannedReductionPercent, equals(5.0));
      expect(result.unplannedReductionUnits, closeTo(0.5, 0.001));
      expect(result.plannedReductionPercent, equals(10.0));
      expect(result.plannedReductionUnits, closeTo(1.0, 0.001));
      expect(result.totalActivityReduction, closeTo(1.5, 0.001));
      expect(result.totalDose, closeTo(8.5, 0.001));
    });

    test('Intensity multipliers correctly scale activity calories', () {
      // Duration 60 min (multiplier 60/30 = 2.0)
      // Base: 100 kcal
      // 'light' (0.8): 100 * 2.0 * 0.8 = 160 kcal
      // 'moderate' (1.0): 100 * 2.0 * 1.0 = 200 kcal
      // 'vigorous' (1.2): 100 * 2.0 * 1.2 = 240 kcal
      // 'intense' (1.4): 100 * 2.0 * 1.4 = 280 kcal
      final light = calculateDose(
        glucose: 100.0,
        carbs: 50.0,
        icr: 10.0,
        isf: 50.0,
        plannedActivity: true,
        plannedCalories: 100.0,
        plannedDuration: 60,
        plannedIntensity: 'light',
      );
      expect(light.plannedActivityCalories, closeTo(160.0, 0.001));

      final moderate = calculateDose(
        glucose: 100.0,
        carbs: 50.0,
        icr: 10.0,
        isf: 50.0,
        plannedActivity: true,
        plannedCalories: 100.0,
        plannedDuration: 60,
        plannedIntensity: 'moderate',
      );
      expect(moderate.plannedActivityCalories, closeTo(200.0, 0.001));

      final vigorous = calculateDose(
        glucose: 100.0,
        carbs: 50.0,
        icr: 10.0,
        isf: 50.0,
        plannedActivity: true,
        plannedCalories: 100.0,
        plannedDuration: 60,
        plannedIntensity: 'vigorous',
      );
      expect(vigorous.plannedActivityCalories, closeTo(240.0, 0.001));

      final intense = calculateDose(
        glucose: 100.0,
        carbs: 50.0,
        icr: 10.0,
        isf: 50.0,
        plannedActivity: true,
        plannedCalories: 100.0,
        plannedDuration: 60,
        plannedIntensity: 'intense',
      );
      expect(intense.plannedActivityCalories, closeTo(280.0, 0.001));
    });

    test('Clamps negative or excessive reduction doses to zero', () {
      // 1. Negative correction exceeding meal dose:
      // carbs: 10g, ICR: 20 => mealDose = 0.5
      // glucose: 75 mg/dL, target: 100 mg/dL, ISF: 20 => correction = -1.25
      // total = -0.75 => clamped to 0.0
      final result1 = calculateDose(
        glucose: 75.0,
        carbs: 10.0,
        icr: 20.0,
        isf: 20.0,
        targetGlucose: 100.0,
      );
      expect(result1.totalDoseBeforeActivity, closeTo(-0.75, 0.001));
      expect(result1.totalDose, equals(0.0));

      // 2. High activity reduction exceeding 100% (e.g. two 60% reductions):
      // carbs: 20g, ICR: 10 => mealDose = 2.0, correction = 0.0
      // unplanned: >600 kcal => 60% reduction (1.2 units)
      // planned: >600 kcal => 60% reduction (1.2 units)
      // total reduction = 2.4 units > 2.0 units => clamped to 0.0
      final result2 = calculateDose(
        glucose: 100.0,
        carbs: 20.0,
        icr: 10.0,
        isf: 50.0,
        unplannedActivity: true,
        unplannedCalories: 700.0,
        unplannedDuration: 30,
        unplannedIntensity: 'moderate',
        plannedActivity: true,
        plannedCalories: 700.0,
        plannedDuration: 30,
        plannedIntensity: 'moderate',
      );
      expect(result2.totalActivityReduction, closeTo(2.4, 0.001));
      expect(result2.totalDose, equals(0.0));
    });
  });

  group('Calorie Table Boundary Tests', () {
    test('Boundary test: <= 50 kcal -> 5%', () {
      expect(getReductionPercentFromCalories(0), equals(5.0));
      expect(getReductionPercentFromCalories(25), equals(5.0));
      expect(getReductionPercentFromCalories(50), equals(5.0));
    });

    test('Boundary test: 51 - 100 kcal -> 10%', () {
      expect(getReductionPercentFromCalories(50.1), equals(10.0));
      expect(getReductionPercentFromCalories(75), equals(10.0));
      expect(getReductionPercentFromCalories(100), equals(10.0));
    });

    test('Boundary test: 101 - 150 kcal -> 15%', () {
      expect(getReductionPercentFromCalories(100.1), equals(15.0));
      expect(getReductionPercentFromCalories(125), equals(15.0));
      expect(getReductionPercentFromCalories(150), equals(15.0));
    });

    test('Boundary test: 151 - 200 kcal -> 20%', () {
      expect(getReductionPercentFromCalories(150.1), equals(20.0));
      expect(getReductionPercentFromCalories(175), equals(20.0));
      expect(getReductionPercentFromCalories(200), equals(20.0));
    });

    test('Boundary test: 201 - 250 kcal -> 25%', () {
      expect(getReductionPercentFromCalories(200.1), equals(25.0));
      expect(getReductionPercentFromCalories(225), equals(25.0));
      expect(getReductionPercentFromCalories(250), equals(25.0));
    });

    test('Boundary test: 251 - 300 kcal -> 30%', () {
      expect(getReductionPercentFromCalories(250.1), equals(30.0));
      expect(getReductionPercentFromCalories(275), equals(30.0));
      expect(getReductionPercentFromCalories(300), equals(30.0));
    });

    test('Boundary test: 301 - 400 kcal -> 35%', () {
      expect(getReductionPercentFromCalories(300.1), equals(35.0));
      expect(getReductionPercentFromCalories(350), equals(35.0));
      expect(getReductionPercentFromCalories(400), equals(35.0));
    });

    test('Boundary test: 401 - 500 kcal -> 40%', () {
      expect(getReductionPercentFromCalories(400.1), equals(40.0));
      expect(getReductionPercentFromCalories(450), equals(40.0));
      expect(getReductionPercentFromCalories(500), equals(40.0));
    });

    test('Boundary test: 501 - 600 kcal -> 50%', () {
      expect(getReductionPercentFromCalories(500.1), equals(50.0));
      expect(getReductionPercentFromCalories(550), equals(50.0));
      expect(getReductionPercentFromCalories(600), equals(50.0));
    });

    test('Boundary test: > 600 kcal -> 60%', () {
      expect(getReductionPercentFromCalories(600.1), equals(60.0));
      expect(getReductionPercentFromCalories(700), equals(60.0));
      expect(getReductionPercentFromCalories(1200), equals(60.0));
    });
  });

  group('Safety Validation Tests', () {
    test('Glucose < 70 mg/dL throws HypoglycemiaException with warning message', () {
      expect(
        () => calculateDose(
          glucose: 69.9,
          carbs: 50.0,
          icr: 10.0,
          isf: 50.0,
        ),
        throwsA(
          isA<HypoglycemiaException>().having(
            (e) => e.message,
            'message',
            contains('Treat the low first and recheck before taking insulin'),
          ),
        ),
      );

      expect(
        () => calculateDose(
          glucose: 55.0,
          carbs: 30.0,
          icr: 10.0,
          isf: 50.0,
        ),
        throwsA(isA<HypoglycemiaException>()),
      );

      expect(
        () => calculateDose(
          glucose: 20.0,
          carbs: 30.0,
          icr: 10.0,
          isf: 50.0,
        ),
        throwsA(isA<HypoglycemiaException>()),
      );
    });

    test('Glucose outside 20 - 600 mg/dL throws ArgumentError', () {
      // Below 20
      expect(
        () => calculateDose(
          glucose: 19.9,
          carbs: 50.0,
          icr: 10.0,
          isf: 50.0,
        ),
        throwsArgumentError,
      );

      expect(
        () => calculateDose(
          glucose: 0.0,
          carbs: 50.0,
          icr: 10.0,
          isf: 50.0,
        ),
        throwsArgumentError,
      );

      expect(
        () => calculateDose(
          glucose: -15.0,
          carbs: 50.0,
          icr: 10.0,
          isf: 50.0,
        ),
        throwsArgumentError,
      );

      // Above 600
      expect(
        () => calculateDose(
          glucose: 600.1,
          carbs: 50.0,
          icr: 10.0,
          isf: 50.0,
        ),
        throwsArgumentError,
      );

      expect(
        () => calculateDose(
          glucose: 850.0,
          carbs: 50.0,
          icr: 10.0,
          isf: 50.0,
        ),
        throwsArgumentError,
      );
    });

    test('Carbs outside 0 - 300 g throws ArgumentError', () {
      // Negative carbs
      expect(
        () => calculateDose(
          glucose: 100.0,
          carbs: -1.0,
          icr: 10.0,
          isf: 50.0,
        ),
        throwsArgumentError,
      );

      // Above 300 g
      expect(
        () => calculateDose(
          glucose: 100.0,
          carbs: 300.1,
          icr: 10.0,
          isf: 50.0,
        ),
        throwsArgumentError,
      );

      expect(
        () => calculateDose(
          glucose: 100.0,
          carbs: 450.0,
          icr: 10.0,
          isf: 50.0,
        ),
        throwsArgumentError,
      );
    });

    test('Valid boundary conditions do not throw', () {
      // Glucose at exactly 70 mg/dL is allowed
      expect(
        () => calculateDose(
          glucose: 70.0,
          carbs: 50.0,
          icr: 10.0,
          isf: 50.0,
        ),
        returnsNormally,
      );

      // Glucose at exactly 600 mg/dL is allowed
      expect(
        () => calculateDose(
          glucose: 600.0,
          carbs: 50.0,
          icr: 10.0,
          isf: 50.0,
        ),
        returnsNormally,
      );

      // Carbs at exactly 0 g is allowed
      expect(
        () => calculateDose(
          glucose: 120.0,
          carbs: 0.0,
          icr: 10.0,
          isf: 50.0,
        ),
        returnsNormally,
      );

      // Carbs at exactly 300 g is allowed
      expect(
        () => calculateDose(
          glucose: 120.0,
          carbs: 300.0,
          icr: 10.0,
          isf: 50.0,
        ),
        returnsNormally,
      );
    });
  });

  group('Injection Model Tests', () {
    test('Serialization and deserialization with fromJson and toJson', () {
      final injection = Injection(
        tempsInject: const TimeOfDay(hour: 12, minute: 30),
        glycemie: 150,
        quantiteGlu: 50.0,
        doseInsuline: 5.0,
        mealName: 'Lunch',
        userId: 'user_123',
        timestamp: DateTime(2026, 9, 11, 12, 30),
      );

      final json = injection.toJson();

      expect(json['tempsInject'], equals('12:30'));
      expect(json['glycemie'], equals(150));
      expect(json['quantiteGlu'], equals(50.0));
      expect(json['doseInsuline'], equals(5.0));
      expect(json['mealName'], equals('Lunch'));
      expect(json['userId'], equals('user_123'));

      final reconstructed = Injection.fromJson(json);
      expect(reconstructed.tempsInject.hour, equals(12));
      expect(reconstructed.tempsInject.minute, equals(30));
      expect(reconstructed.glycemie, equals(150));
      expect(reconstructed.quantiteGlu, equals(50.0));
      expect(reconstructed.doseInsuline, equals(5.0));
      expect(reconstructed.mealName, equals('Lunch'));
      expect(reconstructed.userId, equals('user_123'));
    });
  });
}
