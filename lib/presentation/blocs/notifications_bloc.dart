import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:notificaciones_flutter/domain/entities/push_message.dart';
import 'package:notificaciones_flutter/firebase_options.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';

//Gestión de las notificaciones push cuando esta está terminated
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async{
  await Firebase.initializeApp();
}

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {

  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  int numberId = 0;

  final Future<void> Function()? requestPermissionLocalNotifications;
  final void Function({required int id, String? title, String? body, String? data})? showLocalNotification;

  NotificationsBloc({
    this.requestPermissionLocalNotifications,
    this.showLocalNotification
}) : super( const NotificationsState()) {

    on<NotificationStatusChanged>( _notificationStatusChanged );
    on<NotificationReceived>( _notificationReceived );

    _initialStatusCheck();
    _onForegroundMessage();
  }

  static Future<void> initializeFCM() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform
    );
  }

  void _notificationReceived( NotificationReceived event, Emitter<NotificationsState> emit){
    emit(
      state.copyWith(
        notifications: [ event.pushMessage, ...state.notifications ]
      )
    );
  }

  void _notificationStatusChanged( NotificationStatusChanged event, Emitter<NotificationsState> emit){

    emit(
      state.copyWith(
        status: event.status
      )
    );

    //Enseñamos token para FCM por consola
    _getFCMToken();

  }

  void handleRemoteMessage(RemoteMessage message){

    if(message.notification == null) return;

    final notification = PushMessage(
      messageId: message.messageId
          ?.replaceAll(':', '').replaceAll('%', '')
          ?? '',
      title: message.notification!.title ?? '',
      body: message.notification!.body ?? '',
      sentDate: message.sentTime ?? DateTime.now(),
      data: message.data,
      imageUrl: Platform.isAndroid
        ? message.notification!.android?.imageUrl
          : message.notification!.apple?.imageUrl
    );

    if(showLocalNotification != null){
      showLocalNotification!(
          id: ++numberId,
          body: notification.body,
          data: notification.messageId,
          title: notification.title
      );
    }

    add( NotificationReceived(notification));

  }

  //Con esto gestiono las notificaciones en foreground y background
  void _onForegroundMessage(){
    FirebaseMessaging.onMessage.listen(handleRemoteMessage);
  }

  void _initialStatusCheck () async {

    //Obtenemos las settings actuales
    final settings = await firebaseMessaging.getNotificationSettings();
    //Y las indicamos mediante evento
    add(NotificationStatusChanged(settings.authorizationStatus));

  }

  void _getFCMToken() async {
    //Si no estoy autorizado no obtenemos el token
    if( state.status != AuthorizationStatus.authorized ) return;

    final token = await firebaseMessaging.getToken();

    print("Token:");
    print(token);
  }

  void requestPermissions() async {

    NotificationSettings notificationSettings = await firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: true,
      provisional: false,
      sound: true
    );

    //Pedimos permisos para notificaciones locales.
    //Segun Fernando, no hace falta ya que son los mismo permisos que para las
    //notificaciones push
    if(requestPermissionLocalNotifications != null){
      await requestPermissionLocalNotifications!();
    }

    add(NotificationStatusChanged(notificationSettings.authorizationStatus));



  }

  PushMessage? getMessageById(String id){
    final exist = state.notifications.any((element) => element.messageId == id);
    if( !exist ) return null;
    
    return state.notifications.firstWhere((element) => element.messageId == id );
  }



}
