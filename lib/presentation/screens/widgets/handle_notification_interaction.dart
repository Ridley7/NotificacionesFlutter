import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notificaciones_flutter/config/router/app_router.dart';
import 'package:notificaciones_flutter/presentation/blocs/notifications_bloc.dart';

class HandleNotificationInteraction extends StatefulWidget {
  const HandleNotificationInteraction({super.key, required this.child});
  final Widget child;

  @override
  State<HandleNotificationInteraction> createState() => _HandleNotificationInteractionState();
}

class _HandleNotificationInteractionState extends State<HandleNotificationInteraction> {

  Future<void> setupInteractedMessage() async{
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null){
      _handleMessage(initialMessage);
    }

    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);

  }

  void _handleMessage(RemoteMessage message){

    //Almacenamos mensaje en el bloc
    context.read<NotificationsBloc>().handleRemoteMessage(message);

    //Usamos appRouter por que es posible que go_router no este listo en el contexto
    final messageId = message.messageId?.replaceAll(':', '').replaceAll('%', '');
    appRouter.push('/push-details/$messageId');

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setupInteractedMessage();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
