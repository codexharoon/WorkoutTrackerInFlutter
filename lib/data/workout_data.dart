import 'package:flutter/material.dart';
import 'package:workout_tracker/data/hive_databse.dart';
import 'package:workout_tracker/datetime/date_time.dart';
import 'package:workout_tracker/models/exercise.dart';
import 'package:workout_tracker/models/workout.dart';
import 'package:flutter/foundation.dart';

class WorkoutData extends ChangeNotifier{


  // for heatmap
  final Map<DateTime,int> dataset = {};

  // instance of hive database
  final db = HiveDatabase();

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

  void initWorkoutList(){
    if(db.previousDataExist()){
      workoutList = db.getData();
    }
    else{
      db.saveData(workoutList);
    }

    //load hetamap
    loadHeatMap();
  }

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

  // notify listner
  void runNotifyListner(){
    notifyListeners();
  }


  // add workout
  void addWorkout(String workoutName){
    workoutList.add(Workout(name: workoutName, exercises: []));   

    db.saveData(workoutList); 

    notifyListeners();
  }

  // add exercxise into workout
  void addExercise(String workoutName, String exerciseName, String weight, String reps, String sets){

    Workout relevantWorkout = getRelevantWorkout(workoutName);

    relevantWorkout.exercises.add(Exercise(name: exerciseName, weight: weight, reps: reps, sets: sets));

    db.saveData(workoutList); 

    notifyListeners();
  }

  // check off exercises
  void checkOffExercise(String workoutName, String exerciseName){
    Exercise relevantExercise = getRelevantExercise(workoutName,exerciseName);

    relevantExercise.isCompleted = !relevantExercise.isCompleted;

    db.saveData(workoutList); 

    loadHeatMap();

    notifyListeners();
  }


  // utility methods for heat map

  // get startdate
  String getStartDate(){
    return db.getStartDate();
  }

  // load heat map
  void loadHeatMap(){
    // get strat date
    DateTime startDate = convertStringIntoDateTime(getStartDate());

    // count no. of days to load
    int daysInBetween = DateTime.now().difference(startDate).inDays;

    // go from start date to today, and add each completion status to the dataset

    for(int i=0; i<daysInBetween +1; i++){

      String yyyymmdd = convertDateTimeIntoString(startDate.add(Duration(days: i)));

      // get

      // completition status
      int completionStatus = db.getCompletionStatus(yyyymmdd);

      // year
      int year = startDate.add(Duration(days: i)).year;
      // month
      int month = startDate.add(Duration(days: i)).month;
      // day
      int day = startDate.add(Duration(days: i)).day;


      final percentForEachDay = <DateTime,int>{
        DateTime(year,month,day) : completionStatus
      };
      
      dataset.addEntries(percentForEachDay.entries);

    }
  }


}