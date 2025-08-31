import 'package:flutter/material.dart';
import 'package:todo_app/firebase_functions.dart';

import '../../models/task_model.dart';
import '../../models/user_model.dart';

class UserProvider with ChangeNotifier {
  UserModel? currentUser;

  void updateUser(UserModel user) {
    currentUser = user;
    notifyListeners();
  }
}
