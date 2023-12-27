import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      appBar: AppBar(
        title: Text('Список справ'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('↓Перехід до створення нотаток↓', style: TextStyle(color: Colors.white)),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(context, '/todo', (route) => true);
            },
            child: Text('Створити'),
          ),
          Container(
            height: 200, // Збільшив висоту зображення
            width: double.infinity,
            child: Image(
              image: NetworkImage('https://cognitivescience.ceu.edu/sites/cognitivescience.ceu.hu/files/styles/panopoly_image_full/public/mainimage/basicpage/9/calendar.jpg?itok=6o4rTEpO'),
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}
