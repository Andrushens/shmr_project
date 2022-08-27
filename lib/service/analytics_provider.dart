import 'package:firebase_analytics/firebase_analytics.dart';

enum AnalyticsEvent {
  onHomePage,
  onTaskPage,
  createTask,
  deleteTask,
  updateTask,
}

enum AnalyticsErrorEvent {
  createTaskError,
  deleteTaskError,
  updateTaskError,
}

abstract class AnalyticsProvider {
  Future<void> logEvent(AnalyticsEvent event, {dynamic data});
  Future<void> logErrorEvent(AnalyticsErrorEvent event, {dynamic data});
}

class AnalyticsProviderImpl implements AnalyticsProvider {
  AnalyticsProviderImpl(this.firebaseAnalytics);

  final FirebaseAnalytics firebaseAnalytics;

  @override
  Future<void> logEvent(AnalyticsEvent event, {dynamic data}) async {
    switch (event) {
      case AnalyticsEvent.onHomePage:
        await _handleOnHomePageEvent();
        break;
      case AnalyticsEvent.onTaskPage:
        await _handleOnTaskPageEvent();
        break;
      case AnalyticsEvent.createTask:
        await _handleCreateTaskEvent();
        break;
      case AnalyticsEvent.deleteTask:
        await _handleDeleteTaskEvent();
        break;
      case AnalyticsEvent.updateTask:
        await _handleUpdateTaskEvent();
        break;
    }
  }

  Future<void> _handleOnHomePageEvent() async {
    await firebaseAnalytics.logEvent(
      name: 'shmr_on_home_page',
    );
  }

  Future<void> _handleOnTaskPageEvent() async {
    await firebaseAnalytics.logEvent(
      name: 'shmr_on_task_page',
    );
  }

  Future<void> _handleCreateTaskEvent() async {
    await firebaseAnalytics.logEvent(
      name: 'shmr_task_create',
    );
  }

  Future<void> _handleDeleteTaskEvent() async {
    await firebaseAnalytics.logEvent(
      name: 'shmr_task_delete',
    );
  }

  Future<void> _handleUpdateTaskEvent() async {
    await firebaseAnalytics.logEvent(
      name: 'shmr_task_update',
    );
  }

  @override
  Future<void> logErrorEvent(AnalyticsErrorEvent event, {dynamic data}) async {
    switch (event) {
      case AnalyticsErrorEvent.createTaskError:
        await _handleCreateTaskErrorEvent(data as String);
        break;
      case AnalyticsErrorEvent.deleteTaskError:
        await _handleDeleteTaskErrorEvent(data as String);
        break;
      case AnalyticsErrorEvent.updateTaskError:
        await _handleUpdateTaskErrorEvent(data as String);
        break;
    }
  }

  Future<void> _handleCreateTaskErrorEvent(String? stacktrace) async {
    await firebaseAnalytics.logEvent(
      name: 'shmr_task_create_error',
      parameters: {
        if (stacktrace != null) 'stacktrace': stacktrace,
      },
    );
  }

  Future<void> _handleDeleteTaskErrorEvent(String? stackTrace) async {
    await firebaseAnalytics.logEvent(
      name: 'shmr_task_delete_error',
      parameters: {
        if (stackTrace != null) 'stacktrace': stackTrace,
      },
    );
  }

  Future<void> _handleUpdateTaskErrorEvent(String? stackTrace) async {
    await firebaseAnalytics.logEvent(
      name: 'shmr_task_update_error',
      parameters: {
        if (stackTrace != null) 'stacktrace': stackTrace,
      },
    );
  }
}
