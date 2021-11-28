import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TaskHome extends StatefulWidget {
  TaskHome({required this.title});

  final String title;

  @override
  State<TaskHome> createState() => _TaskHomeState();
}

class _TaskHomeState extends State<TaskHome> {
  List todos = List.empty();
  String title = "";
  String description = "";

  createToDo() {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("MyTodos").doc(title);

    Map<String, String> todoList = {
      "todoTitle": title,
      "todoDesc": description
    };

    documentReference
        .set(todoList)
        .whenComplete(() => print("Data stored successfully"));
  }

  deleteTodo(item) {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("MyTodos").doc(item);

    documentReference
        .delete()
        .whenComplete(() => print("Deleted successfully"));
  }

  @override
  void initState() {
    super.initState();
    todos = ["Test"];
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding:
            const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 4.0, right: 4.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection("MyTodos").snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            } else if (snapshot.hasData || snapshot.data != null) {
              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data?.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    QueryDocumentSnapshot<Object?>? documentSnapshot =
                        snapshot.data?.docs[index];
                    return Dismissible(
                        key: Key(index.toString()),
                        child: Card(
                          elevation: 4,
                          child: ListTile(
                            title: Text((documentSnapshot != null)
                                ? (documentSnapshot["todoTitle"])
                                : ""),
                            subtitle: Text((documentSnapshot != null)
                                ? ((documentSnapshot["todoDesc"] != null)
                                    ? documentSnapshot["todoDesc"]
                                    : "")
                                : ""),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              color: Colors.red,
                              onPressed: () async {
                                setState(() {
                                  todos.removeAt(index);
                                  deleteTodo((documentSnapshot != null)
                                      ? (documentSnapshot["todoTitle"])
                                      : "");
                                });
                              },
                            ),
                          ),
                        ));
                  });
            }
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Colors.amber,
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  title: const Text("Add Task"),
                  content: Container(
                    width: width,
                    height: height / 5,
                    child: Column(
                      children: [
                        TextField(
                          onChanged: (String value) {
                            title = value;
                          },
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Task Title'),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          onChanged: (String value) {
                            description = value;
                          },
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "Task Description"),
                        ),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            todos.add(title);
                            createToDo();
                          });
                          Navigator.of(context).pop();
                        },
                        child: const Text("Add"),
                        style: TextButton.styleFrom(
                          primary: Colors.white,
                          backgroundColor: Colors.amber,
                          textStyle: const TextStyle(
                            fontSize: 20,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              });
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 15,
        ),
      ),
    );
  }
}
