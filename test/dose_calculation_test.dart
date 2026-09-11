import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:diazen/classes/injection.dart';

void main() {
  group('Injection Dose Calculation Tests', () {
    late Injection injection;

    setUp(() {
      injection = Injection(
        tempsInject: const TimeOfDay(hour: 12, minute: 30),
        glycemie: 150,
        quantiteGlu: 50.0,
        doseInsuline: 5.0,
        mealName: 'Lunch',
        userId: 'user_123',
        timestamp: DateTime(2026, 9, 11, 12, 30),
      );
    });

    test('Standard dose calculation: carbs and correction without activity', () {
      // Inputs:
      // carbs: 60g, ICR: 10 => mealDose = 6 units
      // glucose: 150 mg/dL, target: 100 mg/dL, ISF: 50 => correctionDose = 1 unit
      // totalDose = 7 units
      final inputs = {
        'glycemie': 150.0,
        'glucides': 60.0,
        'glycemieCible': 100.0,
        'ratioInsulineGlucide': 10.0,
        'sensitiviteInsuline': 50.0,
        'activityFactor': 0.0,
      };

      final dose = injection.calculerDose(inputs);
      expect(dose, closeTo(7.0, 0.01));
    });

    test('Dose calculation with activity reduction factor', () {
      // Total before activity = 7 units
      // Activity factor = 0.20 (20% reduction)
      // Reduction = 1.4 units => final = 5.6 units
      final inputs = {
        'glycemie': 150.0,
        'glucides': 60.0,
        'glycemieCible': 100.0,
        'ratioInsulineGlucide': 10.0,
        'sensitiviteInsuline': 50.0,
        'activityFactor': 0.20,
      };

      final dose = injection.calculerDose(inputs);
      expect(dose, closeTo(5.6, 0.01));
    });

    test('Dose calculation clamps negative total dose to zero', () {
      // Hypoglycemic state:
      // carbs: 0g => mealDose = 0
      // glucose: 60 mg/dL, target: 100 mg/dL, ISF: 50 => correction = -0.8 units
      // total should be clamped to 0
      final inputs = {
        'glycemie': 60.0,
        'glucides': 0.0,
        'glycemieCible': 100.0,
        'ratioInsulineGlucide': 10.0,
        'sensitiviteInsuline': 50.0,
        'activityFactor': 0.0,
      };

      final dose = injection.calculerDose(inputs);
      expect(dose, equals(0.0));
    });

    test('Serialization and deserialization with fromJson and toJson', () {
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
