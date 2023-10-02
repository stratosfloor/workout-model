sealed class Identifiable {
  String get id;
}

abstract class IExerciseDescription extends Identifiable {
  String get name;
  String get description;
}

abstract class IExerciseDescriptionRepository<T extends IExerciseDescription> {
  bool create(T exerciseDescription);
  T? read(String id);
  T update(
    T exerciseDescription,
    String? name,
    String? description,
  );
  bool delete(String id);
  void clear();
  List<T> list();
}

abstract interface class IExercise extends Identifiable
    implements IExerciseDescription {
  int? get repetitions;
  int? get restTime; // in seconds
  int? get sets;
  double? get weight; // in kgs
}

abstract interface class IExceriseRepository<T extends IExercise> {
  bool create(T exercise);
  T? read(String id);
  T update({
    required T exercise,
    String? name,
    String? description,
    int? repetitions,
    int? restTime,
    int? sets,
    double? weight,
  });
  bool delete(String id);
  void clear();
  List<T> list();
}
