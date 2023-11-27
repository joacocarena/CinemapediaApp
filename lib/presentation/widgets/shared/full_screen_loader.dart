import 'package:flutter/material.dart';

class FullScreenLoader extends StatelessWidget {
  const FullScreenLoader({super.key});

  Stream<String> getLoadingMessages() {

    final messages = <String>[

      'Loading movies...',
      '¡Making popcorn!',
      'Calling my gf...',
      'this is taking too long >:v',

    ];

    return Stream.periodic(const Duration(milliseconds: 1600), (step) { //? "step" es un indice para la iteración.
      return messages[step];
    }).take(messages.length); //? con take(hastaDonde) indico el fin de la iteración. 
  }

  @override
  Widget build(BuildContext context) {
    return Center(

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          const Text('Wait a second', style: TextStyle(fontSize: 20)),
          const SizedBox(height: 20),
          const CircularProgressIndicator(strokeWidth: 2, ),
          const SizedBox(height: 20),

          StreamBuilder(
          
            stream: getLoadingMessages(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const Text("Loading..."); //? si NO encuentra "data" devuelve "Loading...".
              return Text(snapshot.data!, style: TextStyle(fontSize: 15),); //? Si encuentra "data" que la devuelva.
            },
          
          )

        ],
      ),

    );
  }
}