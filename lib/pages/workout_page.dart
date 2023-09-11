import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:workout_tracker/data/workout_data.dart';
import 'package:workout_tracker/models/workout.dart';

class WorkoutPage extends StatefulWidget {

  final String workoutName;

  const WorkoutPage(
    {
      super.key,
      required this.workoutName,
    }
  );

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {

  final nameController = TextEditingController();
  final weightController = TextEditingController();
  final repsController = TextEditingController();
  final setsController = TextEditingController();

  // checkbox chnaged
  void onCheckBoxChanged(String workoutName, String exerciseName){
    Provider.of<WorkoutData>(context, listen: false).checkOffExercise(workoutName, exerciseName);
  }

  // save exercise
  void save(){
    Provider.of<WorkoutData>(context,listen: false).addExercise(widget.workoutName, nameController.text, weightController.text, repsController.text, setsController.text);
    cancel();
  }

  // cancel dialog
  void cancel(){
    Navigator.of(context).pop();
    clearAllTextController();
  }

  // clear controller utility method
  void clearAllTextController(){
    nameController.clear();
    weightController.clear();
    repsController.clear();
    setsController.clear();
  }


  // create exercise dialog
  void createExercise(){

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create New Exercise'),
        content: Column(  
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController,decoration: const InputDecoration(hintText: 'Exercise Name'),),
            TextField(controller: weightController,decoration: const InputDecoration(hintText: 'Weight'),),
            TextField(controller: repsController,decoration: const InputDecoration(hintText: 'No. of Reps'),),
            TextField(controller: setsController,decoration: const InputDecoration(hintText: 'No. of Sets'),),
          ],
        ),
        actions: [
          MaterialButton(
            onPressed: cancel,
            child: const Text('Cancel'),
          ),

          MaterialButton(
            onPressed: save,
            child: const Text('Save'),
          )
        ],
      )
    );
  }


  // deleting a exercise in a workout
  void deleteExerciseInWorkout(String exerciseName){
    Workout workout = Provider.of<WorkoutData>(context,listen: false).getRelevantWorkout(widget.workoutName);

    workout.exercises.removeWhere((element) => element.name == exerciseName);
    Provider.of<WorkoutData>(context, listen: false).runNotifyListner();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutData>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(  
          title: Text(widget.workoutName),
          elevation: 0,
        ),
        body: ListView.builder(
          itemCount: value.getLengthOfExercisesInWorkout(widget.workoutName),
          itemBuilder: (context,index) => Padding(
            padding: const EdgeInsets.only(top: 16,right: 16,left: 16),
            child: Container(
              decoration: BoxDecoration(  
                color: value.getRelevantWorkout(widget.workoutName).exercises[index].isCompleted ? Colors.green : Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(16),
              child: Slidable(
                endActionPane: ActionPane(  
                  motion: const StretchMotion(),
                  children: [

                    SlidableAction(
                      onPressed: (context) => deleteExerciseInWorkout(value.getRelevantWorkout(widget.workoutName).exercises[index].name),
                      icon: Icons.delete,
                      backgroundColor: Colors.red.shade400,
                      borderRadius: BorderRadius.circular(8),
                    ),

                  ],
                ),
                child: ListTile(
                  title: Text(value.getRelevantWorkout(widget.workoutName).exercises[index].name,
                    style: TextStyle(  
                      color: value.getRelevantWorkout(widget.workoutName).exercises[index].isCompleted ? Colors.white : Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  subtitle: Row(  
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Chip(label: Text("${value.getRelevantWorkout(widget.workoutName).exercises[index].weight}KG")),
                      Chip(label: Text("${value.getRelevantWorkout(widget.workoutName).exercises[index].reps} reps")),
                      Chip(label: Text("${value.getRelevantWorkout(widget.workoutName).exercises[index].sets} setss")),
                    ],
                  ),
                  trailing: Checkbox(  
                    value: value.getRelevantWorkout(widget.workoutName).exercises[index].isCompleted,
                    onChanged: (val) => onCheckBoxChanged(value.getRelevantWorkout(widget.workoutName).name , value.getRelevantWorkout(widget.workoutName).exercises[index].name),
                    activeColor: Colors.green[800],
                  ),
                ),
              ),
            ),
          )
        ),
        floatingActionButton: FloatingActionButton(   
          onPressed: createExercise,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}