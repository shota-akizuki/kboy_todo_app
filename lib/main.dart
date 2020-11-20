import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/main_model.dart';

import 'add/add_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false, title: 'TODOアプリ', home: HomePage());
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MainModel>(
      create: (_) => MainModel()..getTodoListRealTime(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('TODOアプリ'),
          actions: [
            Consumer<MainModel>(builder: (context, model, child) {
              final isActive = model.checkShouldActiveCompleteButton();
              return FlatButton(
                child: Text(
                  '完了',
                  style: TextStyle(
                    color:
                        isActive ? Colors.white : Colors.white.withOpacity(0.5),
                  ),
                ),
                onPressed: isActive
                    ? () {
                        model.deleteCheckedItems();
                      }
                    : null,
              );
            }),
          ],
        ),
        body: Consumer<MainModel>(
          builder: (context, model, child) {
            final todoList = model.todoList;
            return ListView(
              children: todoList
                  .map((todo) => CheckboxListTile(
                        title: Text(todo.title),
                        value: todo.isDone,
                        onChanged: (bool value) {
                          todo.isDone = !todo.isDone;
                          model.reload();
                        },
                      ))
                  .toList(),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.orange,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                fullscreenDialog: true,
                builder: (context) => AddPage(),
              ),
            );
          },
          tooltip: 'Increment',
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
