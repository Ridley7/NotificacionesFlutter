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

    on<NotificationStatusChanged>( _notificationStatusChanged );

    _initialStatusCheck();
    _onForegroundMessage();
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

    //Enseñamos token para FCM por consola
    _getFCMToken();

  }

  void _handleRemoteMessage(RemoteMessage message){
    print("Tengo un mensaje en foreground");
    print("Los datos el mensaje son:  ${message.data}");

    if(message.notification == null) return;

    print("El mensaje tambien contiene una notificacion ${message.notification}");
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
