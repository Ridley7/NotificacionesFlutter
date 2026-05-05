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

  NotificationsBloc() : super( const NotificationsState()) {

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

  void _handleRemoteMessage(RemoteMessage message){

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

    add( NotificationReceived(notification));

  }

  //Con esto gestiono las notificaciones en foreground y background
  void _onForegroundMessage(){
    FirebaseMessaging.onMessage.listen(_handleRemoteMessage);
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


    add(NotificationStatusChanged(notificationSettings.authorizationStatus));
  }



}
