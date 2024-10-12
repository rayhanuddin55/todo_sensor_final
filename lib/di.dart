import 'package:get_it/get_it.dart';
import 'package:todo_sensor/data/respository/task_group_repository_impl.dart';
import 'package:todo_sensor/data/respository/task_repository_impl.dart';
import 'package:todo_sensor/repository/task_group_repository.dart';
import 'package:todo_sensor/repository/task_repository.dart';
import 'package:todo_sensor/utils/local_notification_service.dart';

final GetIt getIt = GetIt.instance;

void setupRepositories() {
  getIt.registerLazySingleton<ITaskGroupRepository>(() =>
      TaskGroupRepositoryImpl());
  getIt.registerLazySingleton<ITaskRepository>(() => TaskRepositoryImpl());

  getIt.registerSingleton<LocalNotificationService>(LocalNotificationService());
}


