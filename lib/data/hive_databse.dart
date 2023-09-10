import 'package:hive_flutter/adapters.dart';
import 'package:workout_tracker/datetime/date_time.dart';
import 'package:workout_tracker/models/exercise.dart';
import '../models/workout.dart';

class HiveDatabase{

  // reference the hive box
  final _box = Hive.box('mybox');


  // heck if there already data store, if not, store the start date
  bool previousDataExist(){
    if(_box.isEmpty){
      _box.put('startdate', getTodaysDateTime());
      return false;
    }
    else{
      return true;
    }
  }

  // return start date
  String getStartDate(){
    return _box.get('startdate');
  }


  // save the data into databse
  void saveData(List<Workout> workout){
    // convert obj into list of string
    final workoutList = convertObjIntoWorkoutList(workout);
    final exerciseList = convertObjIntoExerciseList(workout);

    _box.put('workouts', workoutList);
    _box.put('exercises', exerciseList);


    // eg: exerciseCompleted20230910 = 1 or 0
    if(isExerciseCompleted(workout)){
      _box.put('exerciseCompleted${getTodaysDateTime()}', 1);
    }
    else{
      _box.put('exerciseCompleted${getTodaysDateTime()}', 0);
    }
  }


  // get the data
  List<Workout> getData(){

    final workoutNames = _box.get('workouts');
    final exercises = _box.get('exercises');

    List<Workout> workoutList = [];

    for(int i=0; i<workoutNames.length; i++){

      List<Exercise> exercisesInWorkout = [];

      for(int j=0; j<exercises[i].length; j++){

        exercisesInWorkout.add(
          Exercise(
            name: exercises[i][j][0],
            weight: exercises[i][j][1],
            reps: exercises[i][j][2],
            sets: exercises[i][j][3],
            isCompleted: exercises[i][j][4] == 'true' ? true : false
          )
        );
      }

      Workout workout = Workout(name: workoutNames[i], exercises: exercisesInWorkout);

      workoutList.add(workout);
    }

    return workoutList;
  }

  // check if exercise complete or not
  bool isExerciseCompleted(List<Workout> workouts){

    for(var workout in workouts){
      for(var exercise in workout.exercises){
        if(exercise.isCompleted){
          return true;
        }
      }
    }
    return false;
  }


  // return completion status of exercise of a given date
  int getCompletionStatus(String yyyymmdd){
    int completionStatus = _box.get('exerciseCompleted$yyyymmdd') ?? 0;

    return completionStatus;
  }



}


// convert obj into workout list
List<String> convertObjIntoWorkoutList(List<Workout> workout){
  List<String> workoutList = [

  ];

  for(int i=0; i<workout.length; i++){
    workoutList.add(workout[i].name);
  }

  return workoutList;
}


// convert the exercises in workout obj into a list

List<List<List<String>>> convertObjIntoExerciseList(List<Workout> workout){

  List<List<List<String>>> exerciseList = [];

  for(int i=0; i<workout.length; i++){
    List<Exercise> exercises = workout[i].exercises;

    List<List<String>> individualWorkout = [];

    for(int j=0; j < exercises.length; j++){
      List<String> individualExercises = [];

      individualExercises.addAll(
        [
          exercises[j].name,
          exercises[j].weight,
          exercises[j].reps,
          exercises[j].sets,
          exercises[j].isCompleted.toString(),
        ]
      );

      individualWorkout.add(individualExercises);
    }

    exerciseList.add(individualWorkout);

  }

  return exerciseList;

}