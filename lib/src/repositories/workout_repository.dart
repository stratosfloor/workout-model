import 'dart:io';

import 'package:hive/hive.dart';

import '../models/workout_model.dart';

class WorkoutRepository {
  late Box _workoutBox;

  WorkoutRepository() {
    Directory directory = Directory.current;
    Hive.init(directory.path);
    // Hive.initFlutter(directory.path);
  }

  Future<void> initalize() async {
    if (!Hive.isBoxOpen('workouts')) {
      _workoutBox = await Hive.openBox('workouts');
    }
    /*

      Empty box every time we initalize
      Only for testing
    */
    _workoutBox.clear();
    print('Box is open');
  }

  // TODO: Change to return created workout
  bool create(Workout workout) {
    if (!Hive.isBoxOpen('workouts')) {
      throw StateError('Please await WorkoutRepository initalize method');
    }
    var exisitingWorkout = _workoutBox.get(workout.id);
    if (exisitingWorkout != null) {
      return false;
    }
    _workoutBox.put(workout.id, workout.serialize());
    return true;
  }

  Workout? read(String id) {
    var serialized = _workoutBox.get(id);
    return serialized != null ? Workout.deserialize(serialized) : null;
  }

  // TODO: Should add/remove exercises be here?
  //
  Workout update({
    required Workout workout,
    String? name,
    String? description,
  }) {
    var existingWorkout = _workoutBox.get(workout.id);
    if (existingWorkout == null) {
      throw Exception('Workout not found');
    }
    final newWorkout = Workout(
      name: name ?? workout.name,
      description: description ?? workout.description,
    );
    _workoutBox.put(workout.id, newWorkout.serialize());
    return newWorkout;
  }

  bool delete(String id) {
    var existingWorkout = _workoutBox.get(id);
    if (existingWorkout != null) {
      _workoutBox.delete(id);
      return true;
    }
    return false;
  }

  List<Workout> list() => _workoutBox.values
      .map((serialized) => Workout.deserialize(serialized))
      .toList();
}
