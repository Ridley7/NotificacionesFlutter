import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notificaciones_flutter/domain/entities/push_message.dart';
import 'package:notificaciones_flutter/presentation/blocs/notifications_bloc.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key, required this.pushMessageId});

  final String pushMessageId;

  @override
  Widget build(BuildContext context) {
    
    final PushMessage? pushMessage = context.read<NotificationsBloc>().getMessageById(pushMessageId);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detalles Push"),
      ),

      body: pushMessage != null
      ? _DetailsView(message: pushMessage)
      : const Center(child: Text("No existe notificacion"),)
    );
  }
}

class _DetailsView extends StatelessWidget {

  final PushMessage message;

  const _DetailsView({ required this.message });

  @override
  Widget build(BuildContext context) {

    final textStyles = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Column(
        children: [

          if ( message.imageUrl != null )
            Image.network(message.imageUrl!),

          const SizedBox( height: 30 ),

          Text( message.title, style: textStyles.titleMedium ),
          Text( message.body ),

          const Divider(),
          Text( message.data.toString()),

        ],
      ),
    );
  }
}
