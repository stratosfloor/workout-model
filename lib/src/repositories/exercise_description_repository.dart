import 'dart:io';

import 'package:hive/hive.dart';
import 'package:workout_model/src/interfaces/exercise_interface.dart';
import 'package:workout_model/src/models/exercise_description_model.dart';

class ExerciseDescriptionRepository
    implements IExerciseDescriptionRepository<ExerciseDescription> {
  late Box _exerciseDescriptionBox;

  ExerciseDescriptionRepository() {
    Directory directory = Directory.current;
    Hive.init(directory.path);
  }

  Future<void> initalize() async {
    if (!Hive.isBoxOpen('exercises-desc')) {
      _exerciseDescriptionBox = await Hive.openBox('exercises-desc');
    }
    /*
      Empty box every time we initalize
      Only for testing
    */
    _exerciseDescriptionBox.clear();
    print('Box is open');
  }

  @override
  bool create(ExerciseDescription exercise) {
    if (!Hive.isBoxOpen('exercises-desc')) {
      throw StateError(
          'Please await ExerciseDescriptionRepository initalize method');
    }
    var existingExercise = _exerciseDescriptionBox.get(exercise.id);
    if (existingExercise != null) {
      return false;
    }
    _exerciseDescriptionBox.put(exercise.id, exercise.serialize());
    return true;
  }

  @override
  ExerciseDescription? read(String id) {
    var serialized = _exerciseDescriptionBox.get(id);
    return serialized != null
        ? ExerciseDescription.deserialize(serialized)
        : null;
  }

  @override
  ExerciseDescription update(
    ExerciseDescription exerciseDescription,
    String? name,
    String? description,
  ) {
    var existingExercise = _exerciseDescriptionBox.get(exerciseDescription.id);
    if (existingExercise == null) {
      throw Exception('Exercise not found');
    }
    final newExercise = ExerciseDescription(
      name: name ?? exerciseDescription.name,
      description: description ?? exerciseDescription.description,
    );
    _exerciseDescriptionBox.put(
        exerciseDescription.id, newExercise.serialize());
    return newExercise;
  }

  @override
  bool delete(String id) {
    var existingExercise = _exerciseDescriptionBox.get(id);
    if (existingExercise != null) {
      _exerciseDescriptionBox.delete(id);
      return true;
    }
    return false;
  }

  @override
  void clear() {
    _exerciseDescriptionBox.clear();
  }

  @override
  List<ExerciseDescription> list() => _exerciseDescriptionBox.values
      .map((serialized) => ExerciseDescription.deserialize(serialized))
      .toList();
}
