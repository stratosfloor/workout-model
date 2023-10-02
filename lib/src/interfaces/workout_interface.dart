import 'exercise_interface.dart';

sealed class Identifiable {
  String get id;
}

abstract interface class IWorkout extends Identifiable {
  String get name;
  String get description;
  List<IExercise> get exercises;
}

abstract interface class IWorkoutRepository {
  IWorkout? get workout;
  bool create(IWorkout workout);
  IWorkout read(String id);
  IWorkout update(IWorkout workout);
  bool delete(String id);
  List<IWorkout> list();
}

abstract interface class IWorkoutManager {
  IWorkout get workout;
  startWorkout(IWorkout workout);
  pausWorkout(IWorkout workout);
  resumeWorkout(IWorkout workout);
  addExerciseToWorkout(IWorkout workout, IExercise exercise);
  /* Add performence field to IWorkout 
  {
    int? get performenceRepetitions;
    int? get performenceSets;
    double? get performenceWeight; 
  }
   */
  registerPerformance(IWorkout workout, IExercise exercise);
  overviewWorkout(IWorkout workout);
  endWorkout(IWorkout workout);
}
