import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:notificaciones_flutter/firebase_options.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {

  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  NotificationsBloc() : super( const NotificationsState()) {
    on<NotificationsEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<NotificationStatusChanged>( _notificationStatusChanged );
  }

  static Future<void> initializeFCM() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform
    );
  }

  void _notificationStatusChanged( NotificationStatusChanged event, Emitter<NotificationsState> emit){

    emit(
      state.copyWith(
        status: event.status
      )
    );

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
