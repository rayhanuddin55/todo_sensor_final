import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_sensor/ui/group_details/task_group_details.dart';
import 'package:todo_sensor/ui/sensor_app/sensor_tracking_screen.dart';
import 'package:todo_sensor/ui/task_details/task_details.dart';
import 'package:todo_sensor/ui/todo_home.dart';
import 'package:todo_sensor/ui/todo_splash.dart';
import 'package:todo_sensor/ui/welcome_screen.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const WelcomeScreen(),
    ),
    GoRoute(
      name: "todoSplash",
      path: '/todoSplash',
      builder: (context, state) => const TodoSplash(),
    ),
    GoRoute(
      name: "todoHome",
      path: '/todoHome',
      builder: (context, state) => const TodoHome(),
    ),
    GoRoute(
      name: "sensorTrackingPage",
      path: '/sensorTrackingPage',
      builder: (context, state) => SensorTrackingPage(),
    ),
    GoRoute(
      name: "taskListDetails",
      path: '/taskListDetails/:groupId',
      builder: (context, state) => TaskGroupDetails(
        groupId: int.parse(state.pathParameters["groupId"] ?? "-1"),
      ),
    ),
    GoRoute(
      name: "taskDetails",
      path: '/taskDetails/:taskId',
      builder: (context, state) => TaskDetails(
        taskId: int.parse(state.pathParameters["taskId"] ?? "-1"),
      ),
    ),
  ],
);
