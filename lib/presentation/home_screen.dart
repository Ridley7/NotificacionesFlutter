import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Permisos"),
        actions: [
          IconButton(
          onPressed: (){},
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

