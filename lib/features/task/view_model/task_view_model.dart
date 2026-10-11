import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tikdone_app/data/models/category_model.dart';
import 'package:tikdone_app/data/models/todo_model.dart';
import 'package:tikdone_app/features/task/model/task_model.dart';

class TaskViewModel extends GetxController {
  final RxBool isLoading = RxBool(false);
  final RxBool isLoadingUpdate = RxBool(false);
  final isActiveNote = RxBool(false);
  final RxBool isEditing = RxBool(false);
  final TextEditingController todoEditingController = TextEditingController();
  final TextEditingController descEditingController = TextEditingController();
  late TaskModel _model;
  int todoIndex = 0;
  late TodoModel todoModel;
  TaskModel get model => _model;

  TaskViewModel() {
    _model = TaskModel();
  }

  void deleteTodo(TodoModel todo) async {
    isLoadingUpdate(true);
    var res =
        await _model.deleteTodo(id: todo.id, isCompleted: todo.completed);
    res.fold(
      (l) {
        isLoadingUpdate(false);
      },
      (r) {
        isLoadingUpdate(false);
        update();
      },
    );
  }

  void updateTodo() async {
    var response = await _model.updateTodo(
        documentId: todoModel.id,
        title: todoModel.title,
        isCompleted: todoModel.completed,
        index: todoIndex);
    response.fold(
      (l) {
        isLoadingUpdate(false);
      },
      (r) {
        isLoadingUpdate(false);
        update();
      },
    );
  }

  clearSingleTodoAfterAdd() {
    todoEditingController.clear();
    descEditingController.clear();
    isActiveNote(false);

    _model.description.value = '';
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
    _model.description.value = todoModel.description ?? '';
  }

  setCategory(CategoryModel category) {
    _model.categoryModel = category;
    log(_model.categoryModel.id);
    update();
  }

  void getTodos() async {
    isLoading(true);
    var res = await _model.getTodoList();
    res.fold(
      (l) {
        isLoading(false);
      },
      (r) {
        isLoading(false);
        update();
      },
    );
  }

  void updateIsCompleted(String id, bool isComplete) async {
    log(isComplete.toString());
    isLoadingUpdate(true);
    var res = await _model.updateIsCompleted(id: id, isComplete: isComplete);
    res.fold(
      (l) {
        isLoadingUpdate(false);
      },
      (r) {
        isLoadingUpdate(false);
        update();
      },
    );
  }

  void addTodo() async {
    isLoading(true);
    var res = await _model.addTodo(
        title: todoEditingController.text,completed: false);
    res.fold(
      (failure) {
        isLoading(false);
        log(failure.message);
      },
      (document) {
        isLoading(false);

        update();
        clearSingleTodoAfterAdd();
       
      },
    );
  }
}
