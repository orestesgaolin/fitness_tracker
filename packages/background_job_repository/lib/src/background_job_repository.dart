// ignore_for_file: avoid_print, public_member_api_docs

import 'dart:io';

import 'package:background_fetch/background_fetch.dart';
import 'package:database_client/database_client.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';
import 'package:steps_client/steps_client.dart';

// BEWARE: this is still in-progress as I haven't achieved the expected
// workflow yet

/// [Android-only] This "Headless Task" is run when the Android app
/// is terminated with enableHeadless: true
Future<void> backgroundFetchHeadlessTask(HeadlessTask task) async {
  final taskId = task.taskId;
  final isTimeout = task.timeout;
  if (isTimeout) {
    // This task has exceeded its allowed running-time.
    // You must stop what you're doing and immediately .finish(taskId)
    print('[BackgroundFetch] Headless task timed-out: $taskId');
    BackgroundFetch.finish(taskId);
    return;
  }
  print('[BackgroundFetch] Headless event received.');
  final dbFolder = await getApplicationDocumentsDirectory();
  final file = DatabaseClient.defaultDatabaseFile(dbFolder.path);
  await updateStepsCount(taskId, file);

  BackgroundFetch.finish(taskId);
}

Future<void> updateStepsCount(String taskId, File databaseFile) async {
  // <-- Event handler
  // This is the fetch-event callback.
  print('[BackgroundFetch] Event received $taskId');
  try {
    final databaseClient = DatabaseClient(databaseFile);
    final stepsClient = StepsClient();

    final stepsValue = await stepsClient.latestStepCount().first;
    await databaseClient.stepsResource
        .saveSteps(stepsValue.steps, stepsValue.timeStamp);
    print('[BackgroundFetch] Steps: $stepsValue saving to database');

    const androidNotificationDetails = AndroidNotificationDetails(
      'fitness_debug',
      'Debug Fitness',
      channelDescription: 'Dev notifications',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );
    const notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    final t = stepsValue.timeStamp;
    await flutterLocalNotificationsPlugin.show(
      0,
      'Steps: ${stepsValue.steps}',
      'Date: ${t.year}-${t.month}-${t.day} ${t.hour}:${t.minute}',
      notificationDetails,
    );
  } catch (e) {
    print(e);
  }

  // IMPORTANT:  You must signal completion of your task or the OS
  // can punish your app
  // for taking too long in the background.
  BackgroundFetch.finish(taskId);
}

/// {@template background_job_repository}
/// Package accessing the background_job
/// {@endtemplate}
class BackgroundJobRepository {
  /// {@macro background_job_repository}
  BackgroundJobRepository(this.databaseFile) {
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    const initializationSettingsAndroid =
        AndroidInitializationSettings('ic_launch_image');

    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
    );
  }

  Future<void> onDidReceiveNotificationResponse(
    NotificationResponse notificationResponse,
  ) async {
    final payload = notificationResponse.payload;
    if (notificationResponse.payload != null) {
      print('[BackgroundFetch] notification payload: $payload');
    }
  }

  /// File referencing the database
  final File databaseFile;

  Future<void> schedulePedometerRegistration({
    Duration interval = const Duration(minutes: 15),
  }) async {
    final status = await BackgroundFetch.configure(
      BackgroundFetchConfig(
        minimumFetchInterval: interval.inMinutes,
        stopOnTerminate: false,
        enableHeadless: true,
        requiresBatteryNotLow: false,
        requiresCharging: false,
        requiresStorageNotLow: false,
        requiresDeviceIdle: false,
        requiredNetworkType: NetworkType.NONE,
        startOnBoot: true,
      ),
      (String taskId) async {
        return updateStepsCount(
          taskId,
          databaseFile,
        );
      },
      (String taskId) async {
        // <-- Task timeout handler.
        // This task has exceeded its allowed running-time.
        //You must stop what you're doing and immediately .finish(taskId)
        print('[BackgroundFetch] TASK TIMEOUT taskId: $taskId');
        BackgroundFetch.finish(taskId);
      },
    );
    print(status);
    await BackgroundFetch.start();
    await BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
  }
}
