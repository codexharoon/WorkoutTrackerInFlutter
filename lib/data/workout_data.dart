import 'package:flutter/material.dart';
import 'package:workout_tracker/models/exercise.dart';
import 'package:workout_tracker/models/workout.dart';

class WorkoutData extends ChangeNotifier{

  // contains workout name and list of exercises
  List<Workout> workoutList = [
    Workout(
      name: "Upper Body",
      exercises: [
        Exercise(name: 'Bicep', weight: '10', reps: '10', sets: '3'),
      ]
    ),
  ];


  // utility methods

  // get workout object by name
  Workout getRelevantWorkout(String workoutName){
    Workout relevantWorkout = workoutList.firstWhere((workout) => workout.name == workoutName);

    return relevantWorkout;
  }


  // get exercise object by workout and exercise name
  Exercise getRelevantExercise(String workoutName,String exerciseName){
    Workout relevantWorkout = getRelevantWorkout(workoutName);
    Exercise relevantExercise = relevantWorkout.exercises.firstWhere( (exercise) => exercise.name == exerciseName );

    return relevantExercise;
  }


  // get list of workouts
  List<Workout> getWorkoutList(){
    return workoutList;
  }

  // get length of exercises in given workout
  int getLengthOfExercisesInWorkout(String workoutName){
    Workout relevantWorkout = getRelevantWorkout(workoutName);

    return relevantWorkout.exercises.length;
  }


  // add workout
  void addWorkout(String workoutName){
    workoutList.add(Workout(name: workoutName, exercises: []));    

    notifyListeners();
  }

  // add exercxise into workout
  void addExercise(String workoutName, String exerciseName, String weight, String reps, String sets){

    Workout relevantWorkout = getRelevantWorkout(workoutName);

    relevantWorkout.exercises.add(Exercise(name: exerciseName, weight: weight, reps: reps, sets: sets));

    notifyListeners();
  }

  // check off exercises
  void checkOffExercise(String workoutName, String exerciseName){
    Exercise relevantExercise = getRelevantExercise(workoutName,exerciseName);

    relevantExercise.isCompleted = !relevantExercise.isCompleted;

    notifyListeners();
  }


}