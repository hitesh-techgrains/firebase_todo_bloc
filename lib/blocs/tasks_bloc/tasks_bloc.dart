import 'package:equatable/equatable.dart';
import 'package:firebase_todo_bloc/repository/firestore_repository.dart';
import '../../models/task.dart';
import '../bloc_exports.dart';

part 'tasks_event.dart';

part 'tasks_state.dart';

class TasksBloc extends Bloc<TasksEvent, TasksState> {
  TasksBloc() : super(const TasksState()) {
    on<AddTask>(_onAddTask);
    on<GetAllTasks>(onGetAllTasks);
    on<UpdateTask>(_onUpdateTask);
    on<DeleteTask>(_onDeleteTask);
    on<RemoveTask>(_onRemoveTask);
    on<MarkFavoriteOrUnfavoriteTask>(_onMarkFavoriteOrUnfavoriteTask);
    on<EditTask>(_onEditTask);
    on<RestoreTask>(_onRestoreTask);
    on<DeleteAllTasks>(_onDeleteAllTask);
  }

  void _onAddTask(AddTask event, Emitter<TasksState> emit) async {
    await FireStoreRepository.create(task: event.task);
  }

  void onGetAllTasks(GetAllTasks event, Emitter<TasksState> emit) async {
    try {
      List<Task> pendingTasks = [];
      List<Task> completedTasks = [];
      List<Task> favoriteTasks = [];
      List<Task> removedTasks = [];

      final tasks = await FireStoreRepository().getTasks();
      for (var task in tasks) {
        if (task.isDeleted == true) {
          removedTasks.add(task);
        } else {
          if (task.isFavorite == true) {
            favoriteTasks.add(task);
          }
          if (task.isDone == true) {
            completedTasks.add(task);
          } else {
            pendingTasks.add(task);
          }
        }
      }
      emit(TasksState(pendingTasks: pendingTasks, completedTasks: completedTasks, favoriteTasks: favoriteTasks, removedTasks: removedTasks));
    } catch (e) {
      print(e);
    }
  }

  void _onUpdateTask(UpdateTask event, Emitter<TasksState> emit) async {
    Task updatedTask = event.task.copyWith(isDone: !event.task.isDone!);
    await FireStoreRepository.update(task: updatedTask);
  }

  void _onDeleteTask(DeleteTask event, Emitter<TasksState> emit) async {
    await FireStoreRepository.delete(task: event.task);
  }

  void _onRemoveTask(RemoveTask event, Emitter<TasksState> emit) async {
    Task removedTask = event.task.copyWith(isDeleted: true);
    await FireStoreRepository.update(task: removedTask);
  }

  void _onMarkFavoriteOrUnfavoriteTask(MarkFavoriteOrUnfavoriteTask event, Emitter<TasksState> emit) async {
    Task updatedTask = event.task.copyWith(isFavorite: !event.task.isFavorite!);
    await FireStoreRepository.update(task: updatedTask);
  }

  void _onEditTask(EditTask event, Emitter<TasksState> emit) {}

  void _onRestoreTask(RestoreTask event, Emitter<TasksState> emit) async {
    Task restoredTask = event.task.copyWith(isDeleted: false, isDone: false, date: DateTime.now().toString(), isFavorite: false);
    await FireStoreRepository.update(task: restoredTask);
  }

  void _onDeleteAllTask(DeleteAllTasks event, Emitter<TasksState> emit) async {
    await FireStoreRepository.deleteAllTasks(taskList: state.removedTasks);
  }
}
