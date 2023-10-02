import 'package:test/test.dart';

import 'dart:convert';
import 'package:workout_model/src/models/exercise_model.dart';
import 'package:workout_model/src/repositories/exercise_repository.dart';

void main() {
  group('Exercise model tests', () {
    setUp(() {
      // Additional setup goes here.
    });

    test('Initalize Exercise ', () {
      final exercise = Exercise(
          id: 'test',
          name: 'name',
          description: 'description',
          repetitions: 10,
          restTime: 60,
          sets: 3,
          weight: 50);
      expect(exercise, isNotNull);
      expect(exercise.id, 'test');
    });

    test('Test uuid', () {
      final ex = Exercise(
          name: 'basic',
          description: 'basic',
          repetitions: 10,
          restTime: 60,
          sets: 3,
          weight: 50);
      expect(ex.id.length, 36);
    });

    test('Test serialize', () {
      final ex = Exercise(
          id: '01',
          name: 'basic',
          description: 'basic',
          repetitions: 10,
          restTime: 60,
          sets: 3,
          weight: 50);
      expect(
          ex.serialize(),
          jsonEncode({
            "id": "01",
            "name": "basic",
            "description": "basic",
            "repetitions": 10,
            "restTime": 60,
            "sets": 3,
            "weight": 50.0
          }));
    });
  });
  group('Exercise repository tests', () {
    final repo = ExerciseRepository();
    repo.initalize();
    setUp(() {
      // Additional setup goes here.
    });

    test('Test listing exercises', () {
      final list = repo.list();
      expect(list, isNotEmpty);
      expect(list.length, 6);
    });

    test('Test create', () {
      final exercise = Exercise(
          id: '4654654',
          name: 'Bänkpress',
          description: 'Pressa för faaan',
          repetitions: 10,
          restTime: 60,
          sets: 3,
          weight: 50);
      repo.create(exercise);
      final res = repo.read('4654654');
      expect(res, isNotNull);
      expect(res?.description, 'Pressa för faaan');
    });
    test('Test create 2', () {
      repo.create(Exercise(
          id: '01',
          name: 'bänkpress',
          description: 'description',
          repetitions: 10,
          restTime: 60,
          sets: 3,
          weight: 50));
      repo.create(Exercise(
          id: '02',
          name: 'knäböj',
          description: 'description',
          repetitions: 10,
          restTime: 60,
          sets: 3,
          weight: 50));
      repo.create(Exercise(
          id: '03',
          name: 'bicepscurl',
          description: 'description',
          repetitions: 10,
          restTime: 60,
          sets: 3,
          weight: 50));
      final list = repo.list();
      expect(list, isNotNull);
      expect(list.length, 6);
    });
    test('Test create an exercise with existing id', () {
      final list = repo.list();
      expect(list, isNotNull);
      expect(list.length, 6);
      repo.create(Exercise(
          id: '01',
          name: 'bänkpress',
          description: 'description',
          repetitions: 10,
          restTime: 60,
          sets: 3,
          weight: 50));
      expect(list.length, 6);
    });
    test('Test read', () {
      final ex = repo.read('01');
      expect(ex?.name, 'bänkpress');
    });
    test('Test update', () {
      final ex = repo.read('01');
      final ex2 = repo.update(exercise: ex!, name: 'situps');
      expect(ex2.name, 'situps');
    });

    test('Test delete', () {
      repo.create(Exercise(
          id: 'test',
          name: 'delete',
          description: 'the doctor must be deleted'));
      expect(repo.read('test'), isNotNull);
      expect(repo.delete('test'), true);
      expect(repo.read('test'), isNull);
    });
  });
}
