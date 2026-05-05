import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:notificaciones_flutter/presentation/blocs/notifications_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: context.select((NotificationsBloc bloc ) => Text('${bloc.state.status}')),
        actions: [
          IconButton(
          onPressed: (){
            context.read<NotificationsBloc>().requestPermissions();
          },
            icon: Icon(
                Icons.settings
            )
          )
        ],
      ),
      body: HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {

    final listNotifications = context.watch<NotificationsBloc>().state.notifications;

    return ListView.builder(
      itemCount: listNotifications.length,
        itemBuilder:  (BuildContext context, int index){

        final notification = listNotifications[index];

          return ListTile(
            title: Text(notification.title),
            subtitle: Text(notification.body),
            leading: notification.imageUrl != null
            ? Image.network(notification.imageUrl!)
                : null,

            onTap: (){
              context.push('/push-details/${ notification.messageId }');
            },
          );
        }
    );
  }
}

