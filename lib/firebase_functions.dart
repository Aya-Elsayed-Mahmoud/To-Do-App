import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'models/task_model.dart';
import 'models/user_model.dart';

class FirebaseFunctions {
  static CollectionReference<UserModel> getUsersCollection() =>
      FirebaseFirestore
      .instance
          .collection('users')
          .withConverter<UserModel>(
        fromFirestore:
            (docSnapshot, _) => UserModel.fromJson(docSnapshot.data()!),
        toFirestore: (userModel, _) => userModel.toJson(),
      );

  static CollectionReference<TaskModel> getTaskCollection(String userId) =>
      getUsersCollection().doc(userId)
      .collection('tasks')
      .withConverter<TaskModel>(
        fromFirestore:
            (docSnapshot, _) => TaskModel.fromJson(docSnapshot.data()!),
        toFirestore: (taskModel, _) => taskModel.toJson(),
      );

  static Future<void> addTaskToFirestore(TaskModel task, String userId) async {
    CollectionReference<TaskModel> taskCollection = getTaskCollection(userId);
    DocumentReference<TaskModel> docRef = taskCollection.doc();
    task.id = docRef.id;
    return docRef.set(task);
  }

  static Future<List<TaskModel>> getAllTasksFromFirestore(String userId) async {
    CollectionReference<TaskModel> taskCollection = getTaskCollection(userId);
    QuerySnapshot<TaskModel> querySnapshot = await taskCollection.get();
    return querySnapshot.docs.map((docSnapshot) => docSnapshot.data()).toList();
  }

  static Future<void> deleteTaskToFirestore(String taskId,
      String userId) async {
    CollectionReference<TaskModel> taskCollection = getTaskCollection(userId);
    return taskCollection.doc(taskId).delete();
  }

  static Future<void> updateTask(TaskModel task, String userId) async {
    CollectionReference<TaskModel> taskCollection = getTaskCollection(userId);
    return taskCollection.doc(task.id).set(task);
  }

  static Future <UserModel> register({
    required String name,
    required String email,
    required String password}) async {
    final credantials = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
        email: email,
        password: password);
    final user = UserModel(name: name,
        email: email,
        id: credantials.user!.uid
    );
    final usersCollection = getUsersCollection();
    await usersCollection.doc(user.id).set(user);
    return user;
  }

  static Future <UserModel> login({
    required String email,
    required String password}) async {
    final credantials = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password);
    final usersCollection = getUsersCollection();
    final docSnapshot = await usersCollection.doc(credantials.user!.uid).get();
    return docSnapshot.data()!;
  }

  static Future <void> logout() => FirebaseAuth.instance.signOut();
}

