import 'dart:io';

import 'package:hive/hive.dart';
import 'package:workout_model/src/interfaces/workout_interface.dart';

import '../models/workout_model.dart';

class WorkoutRepository implements IWorkoutRepository<Workout> {
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
  @override
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

  @override
  Workout? read(String id) {
    var serialized = _workoutBox.get(id);
    return serialized != null ? Workout.deserialize(serialized) : null;
  }

  // TODO: Should add/remove exercises be here?
  //
  @override
  Workout? update(
    Workout workout,
    String? name,
    String? description,
  ) {
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

  @override
  bool delete(String id) {
    var existingWorkout = _workoutBox.get(id);
    if (existingWorkout != null) {
      _workoutBox.delete(id);
      return true;
    }
    return false;
  }

  @override
  void clear() {
    _workoutBox.clear();
  }

  @override
  List<Workout> list() => _workoutBox.values
      .map((serialized) => Workout.deserialize(serialized))
      .toList();
}
