import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:workout_tracker/data/workout_data.dart';
import 'package:workout_tracker/datetime/date_time.dart';
import 'package:workout_tracker/pages/heatmap.dart';
import 'package:workout_tracker/pages/workout_page.dart';

import '../models/workout.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  // when the app run for the first ever time
  @override
  void initState() {
    Provider.of<WorkoutData>(context,listen: false).initWorkoutList();

    super.initState();
  }


  // text controller for workoutname
  final workoutFieldController = TextEditingController();

  //create new workout
  void createNewWorkout(){
    showDialog(context: context,
     builder: (context) => AlertDialog(  
      title: const Text('Create New Workout'),
      content: TextField(
        controller: workoutFieldController,
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

  // workout cancel method
  void cancel(){
    Navigator.of(context).pop();
    workoutFieldController.clear();
  }
  // workout save method
  void save(){
    Provider.of<WorkoutData>(context,listen: false).addWorkout(workoutFieldController.text);
    cancel();
  }


  // go to workout page
  void goToWorkoutPage(String workoutName){
    Navigator.push(context, MaterialPageRoute(builder: (context) => WorkoutPage(workoutName: workoutName)));
  }

  // delete workout
  void deleteWorkout(int index){
    List<Workout> workouts = Provider.of<WorkoutData>(context,listen: false).getWorkoutList();

    for(int i=0; i<workouts.length; i++){
      if(i == index){
        workouts.removeAt(index);
      }
    }

    Provider.of<WorkoutData>(context,listen: false).runNotifyListner();
  }



  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutData>(
      builder: (context,value,child) => Scaffold(
          appBar: AppBar(  
            title: const Text('Workout Tracker'),
            centerTitle: true,
          ),
          body: ListView(
            children: [
              // heta map
              MyHeatMap(startDate: convertStringIntoDateTime(Provider.of<WorkoutData>(context,listen: false).getStartDate()) , datasets: Provider.of<WorkoutData>(context,listen: false).dataset),

              // workout list
              ListView.builder(
                shrinkWrap: true,  
                physics: const NeverScrollableScrollPhysics(),

                itemCount: value.getWorkoutList().length,
                itemBuilder: (context,index) => Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      color: Colors.grey[200],
                      child: Slidable(
                          endActionPane: ActionPane(  
                          motion: const StretchMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (context) => deleteWorkout(index),
                              icon: Icons.delete,
                              backgroundColor: Colors.red.shade400,
                              borderRadius: BorderRadius.circular(8),
                            )
                          ],
                        ),
                        child: ListTile(
                          title: Text(value.getWorkoutList()[index].name),
                          trailing: IconButton(  
                            icon: const Icon(Icons.arrow_forward_ios),
                            onPressed: () => goToWorkoutPage(value.getWorkoutList()[index].name),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          floatingActionButton: FloatingActionButton(  
            onPressed: createNewWorkout,
            child: const Icon(Icons.add),
          ),
        )
    ); 
  }
}