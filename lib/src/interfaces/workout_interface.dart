import 'exercise_interface.dart';

sealed class Identifiable {
  String get id;
}

abstract interface class IWorkout<T extends IExercise> extends Identifiable {
  String get name;
  String get description;
  List<T> get exercises;
}

abstract interface class IWorkoutRepository<T extends IWorkout> {
  bool create(T workout);
  T? read(String id);
  T? update(T workout, String name, String description);
  bool delete(String id);
  void clear();
  List<T> list();
}

abstract interface class IWorkoutManager<T extends IWorkout,
    V extends IExercise> {
  T? get currentWorkout;
  startWorkout(T workout);
  pausWorkout(T workout);
  resumeWorkout(T workout);
  addExerciseToWorkout(T workout, V exercise);
  removeExerciseFromWorkout(T workout, V exercise);
  /* Add performence field to IWorkout 
  {
    int? get performenceRepetitions;
    int? get performenceSets;
    double? get performenceWeight; 
  }
   */
  registerPerformance(T workout, V exercise);
  overviewWorkout(T workout);
  endWorkout(T workout);
}
