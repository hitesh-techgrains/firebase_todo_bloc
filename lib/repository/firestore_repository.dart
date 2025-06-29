import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_todo_bloc/models/task.dart';
import 'package:get_storage/get_storage.dart';

class FireStoreRepository {
  // Example method to add data
  static Future<void> create({Task? task}) async {
    // Implement Firestore adding logic here
    try {
      await FirebaseFirestore.instance.collection(GetStorage().read('email')).doc(task!.id).set(task.toMap());
    } catch (e) {
      // Handle any errors that occur during the add operation
      print('Error adding data: $e');
    }
  }

  //Get Tasks
  Future<List<Task>> getTasks() async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection(GetStorage().read('email')).get();
      return snapshot.docs.map((doc) => Task.fromMap(doc.data())).toList();
    } catch (e) {
      // Handle any errors that occur during the fetch operation
      print('Error fetching tasks: $e');
      return [];
    }
  }

  //Update Task
  static Future<void> update({required Task task}) async {
    try {
      await FirebaseFirestore.instance.collection(GetStorage().read('email')).doc(task.id).update(task.toMap());
    } catch (e) {
      // Handle any errors that occur during the update operation
      print('Error updating task: $e');
    }
  }

  //Delete Task
  static Future<void> delete({required Task task}) async {
    try {
      await FirebaseFirestore.instance.collection(GetStorage().read('email')).doc(task.id).delete();
    } catch (e) {
      // Handle any errors that occur during the delete operation
      print('Error deleting task: $e');
    }
  }

  //Delete All Tasks
  static Future<void> deleteAllTasks({required List<Task> taskList}) async {
    try {
      final data = FirebaseFirestore.instance.collection(GetStorage().read('email'));
      for (var task in taskList) {
        data.doc(task.id).delete();
      }
    } catch (e) {
      // Handle any errors that occur during the delete all operation
      print('Error deleting all tasks: $e');
    }
  }
}
