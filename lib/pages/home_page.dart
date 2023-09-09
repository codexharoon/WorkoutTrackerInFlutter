import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_tracker/data/workout_data.dart';
import 'package:workout_tracker/pages/workout_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

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



  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutData>(
      builder: (context,value,child) => Scaffold(
          appBar: AppBar(  
            title: const Text('Workout Tracker'),
            centerTitle: true,
          ),
          body: ListView.builder(
            itemCount: value.getWorkoutList().length,
            itemBuilder: (context,index) => Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Container(
                color: Colors.grey[200],
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
          floatingActionButton: FloatingActionButton(  
            onPressed: createNewWorkout,
            child: const Icon(Icons.add),
          ),
        )
    ); 
    
  }
}