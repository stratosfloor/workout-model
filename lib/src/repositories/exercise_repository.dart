import 'dart:io';

import 'package:workout_model/src/interfaces/exercise_interface.dart';
import 'package:workout_model/src/models/exercise_model.dart';
import 'package:hive/hive.dart';

class ExerciseRepository implements IExceriseRepository<Exercise> {
  late Box _exerciseBox;

  ExerciseRepository() {
    Directory directory = Directory.current;
    Hive.init(directory.path);
    // Hive.initFlutter(directory.path);
  }

  Future<void> initalize() async {
    if (!Hive.isBoxOpen('exercises')) {
      _exerciseBox = await Hive.openBox('exercises');
    }
    /*
      Empty box every time we initalize
      Only for testing
    */
    _exerciseBox.clear();
    print('Box is open');
  }

  @override
  bool create(Exercise exercise) {
    if (!Hive.isBoxOpen('exercises')) {
      // _exerciseBox =  Hive.openBox('exercises');
      throw StateError('Please await ExerciseRepository initalize method');
    }
    var existingExercise = _exerciseBox.get(exercise.id);
    if (existingExercise != null) {
      return false;
    }
    _exerciseBox.put(exercise.id, exercise.serialize());
    return true;
  }

  @override
  Exercise? read(String id) {
    var serialized = _exerciseBox.get(id);
    return serialized != null ? Exercise.deserialize(serialized) : null;
  }

  @override
  Exercise update({
    required Exercise exercise,
    String? name,
    String? description,
    int? repetitions,
    int? restTime,
    int? sets,
    double? weight,
  }) {
    var existingExercise = _exerciseBox.get(exercise.id);
    if (existingExercise == null) {
      throw Exception('Exercise not found');
    }
    final newExercise = Exercise(
      name: name ?? exercise.name,
      description: description ?? exercise.description,
      repetitions: repetitions ?? exercise.repetitions,
      restTime: restTime ?? exercise.restTime,
      sets: sets ?? exercise.sets,
      weight: weight ?? exercise.weight,
    );
    _exerciseBox.put(exercise.id, newExercise.serialize());
    return newExercise;
  }

  @override
  bool delete(String id) {
    var existingExercise = _exerciseBox.get(id);
    if (existingExercise != null) {
      _exerciseBox.delete(id);
      return true;
    }
    return false;
  }

  @override
  void clear() {
    _exerciseBox.clear();
  }

  @override
  List<Exercise> list() => _exerciseBox.values
      .map((serialized) => Exercise.deserialize(serialized))
      .toList();
}
