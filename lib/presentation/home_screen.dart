import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    return ListView.builder(
        itemBuilder:  (BuildContext context, int index){
          return ListTile(

          );
        }
    );
  }
}

