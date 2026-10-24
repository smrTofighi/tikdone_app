import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tikdone_app/data/models/category_model.dart';
import 'package:tikdone_app/data/models/todo_model.dart';

import '../repository/task_repository.dart';

class TaskViewModel extends GetxController {
  final RxBool isLoading = RxBool(false);
  final RxBool isLoadingUpdate = RxBool(false);
  final isActiveNote = RxBool(false);
  final RxBool isEditing = RxBool(false);
  final TextEditingController todoEditingController = TextEditingController();
  final TextEditingController descEditingController = TextEditingController();
  late TaskRepository _model;
  int todoIndex = 0;
  late TodoModel todoModel;
  TaskRepository get model => _model;

  TaskViewModel() {
    _model = TaskRepository();
  }

  void deleteTodo(TodoModel todo) async {
    isLoadingUpdate(true);

  }

  void updateTodo() async {

  }

  void clearSingleTodoAfterAdd() {
    todoEditingController.clear();
    descEditingController.clear();
    isActiveNote(false);
  }

  void clearTodos() {
    _model.categoryModel.unActiveTodos!.clear();
    _model.categoryModel.activeTodos!.clear();

    update();
  }

  void setTodo(TodoModel todo, int index) {
    todoModel = todo;
    todoIndex = index;
    todoEditingController.text = todoModel.title;
    descEditingController.text = todoModel.description ?? '';
  }

  void setCategory(CategoryModel category) {
    _model.categoryModel = category;
    log(_model.categoryModel.id);
    update();
  }

  void getTodos() async {

  }

  void updateIsCompleted(String id, bool isComplete) async {

  }

  void addTodo() async {

  }
}
