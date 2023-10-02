sealed class Identifiable {
  String get id;
}

abstract interface class IExercise extends Identifiable {
  String get name;
  String get description;
  int? get repetitions;
  int? get restTime; // in seconds
  int? get sets;
  double? get weight; // in kgs
}

abstract interface class IExceriseRepository {
  IExercise? get exercise;
  bool create(IExercise exercise);
  IExercise read(String id);
  IExercise update(IExercise exercise);
  bool delete(String id);
  List<IExercise> list();
}
