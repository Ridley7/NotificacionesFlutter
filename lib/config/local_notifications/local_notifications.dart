import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:notificaciones_flutter/config/router/app_router.dart';

class LocalNotifications {

  static Future<void> requestPermissionLocalNotifications() async {

    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugins = FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugins.resolvePlatformSpecificImplementation
    <AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();
  }

  static Future<void> initializeLocalNotifications() async{
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    const initializationSettingsAndroid = AndroidInitializationSettings('bell');

    //Faltarina las de iOS
    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid
    );

    await flutterLocalNotificationsPlugin.initialize(
        settings: initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse
    );
  }

  static void showLocalNotification({
    required int id,
    String? title,
    String? body,
    String? data
  }){

    const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
        'channelId',
        'channelName',
      playSound: true,
      sound: RawResourceAndroidNotificationSound('notification_bell'),
      importance: Importance.max,
      priority: Priority.high
    );

    const notificationDetails = NotificationDetails(
      android: androidNotificationDetails
    );

    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.show(id: id, title: title, body: body, notificationDetails: notificationDetails, payload: data);

  }

  static void onDidReceiveNotificationResponse( NotificationResponse notificationResponse ){
    appRouter.push('/push-details/${notificationResponse.payload}');
  }

}