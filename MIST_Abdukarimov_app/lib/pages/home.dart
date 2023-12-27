import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _userToDo = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      appBar: AppBar(
        title: Text('Список справ'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.menu_outlined),
            onPressed: _menuOpen,
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('items').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            var docs = snapshot.data!.docs;
            if (docs.isNotEmpty) {
              return ListView.builder(
                itemCount: docs.length,
                itemBuilder: (BuildContext context, int index) {
                  return Dismissible(
                    key: Key(docs[index].id),
                    child: Card(
                      child: ListTile(
                        title: Text(docs[index].get('item')),
                        trailing: IconButton(
                          icon: Icon(
                            Icons.delete_sweep,
                            color: Colors.deepOrange,
                          ),
                          onPressed: () {
                            FirebaseFirestore.instance.collection('items').doc(docs[index].id).delete();
                          },
                        ),
                      ),
                    ),
                    onDismissed: (direction) {
                      FirebaseFirestore.instance.collection('items').doc(docs[index].id).delete();
                    },
                  );
                },
              );
            } else {
              return Center(
                child: Text('Немає записів'),
              );
            }
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepOrange,
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Додати елемент'),
                content: TextField(
                  onChanged: (String value) {
                    _userToDo = value;
                  },
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      FirebaseFirestore.instance.collection('items').add({'item': _userToDo});

                      Navigator.of(context).pop();
                    },
                    child: Text('Додати'),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(
          Icons.add_box,
          color: Colors.white,
        ),
      ),
    );
  }

  void _menuOpen() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Меню'),
          ),
          body: Row(
            children: [
              SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Перейти на головну сторінку'),
                    Padding(padding: EdgeInsets.only(top: 15)),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushNamedAndRemoveUntil(
                            context, '/', (route) => false);
                      },
                      child: Text('На головну'),
                    ),
                    SizedBox(
                      height: 500,
                      width: 400,
                      child: Image.network(
                        'https://cdn.generalblue.com/calendar/2024-calendar-with-holidays-portrait-sunday-start-en-us-1071x1386.png',
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      }),
    );
  }
}
