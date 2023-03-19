import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(home: MyApp()));

  //runApp(HomeScreen());
  //runApp(Details());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print("sth wrong in future builder by tec");
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            title: "my app",
            debugShowCheckedModeBanner: false,
            home: Login(),
          );
        }
        return CircularProgressIndicator();
      },
    );
  }
}

class Login extends StatelessWidget {
  final _formkey = GlobalKey<FormState>();

  var name = "";
  var password = "";
  var age = "";
  var sex = "";
  var occupation = "";

  dynamic nameController = TextEditingController();
  dynamic passwordController = TextEditingController();
  dynamic ageController = TextEditingController();
  dynamic sexController = TextEditingController();
  dynamic occupationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("login page", style: TextStyle(fontSize: 40)),
          backgroundColor: Color.fromARGB(235, 0, 0, 0),
          titleSpacing: 25,
          toolbarHeight: 100,
        ),
        body: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 40,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Enter username",
                    ),
                    controller: nameController,
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Enter password",
                    ),
                    controller: passwordController,
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  ElevatedButton(
                    child: Text("Login", style: TextStyle(fontSize: 30)),
                    style: TextButton.styleFrom(minimumSize: Size(200, 80)),
                    onPressed: () {
                      if (nameController.text == "mizuhara" &&
                          passwordController.text == "123") {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => HomeScreen()));
                      } else {
                        return null;
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  var name = "";
  var password = "";
  var age = "";
  var sex = "";
  var occupation = "";

  dynamic nameController = TextEditingController();
  dynamic passwordController = TextEditingController();
  dynamic ageController = TextEditingController();
  dynamic sexController = TextEditingController();
  dynamic occupationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: Text("FINDER", style: TextStyle(fontSize: 40)),
            backgroundColor: Color.fromARGB(235, 0, 0, 0),
            titleSpacing: 55,
            toolbarHeight: 100,
          ),
          drawer: Drawer(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 50),
              child: Column(
                children: [
                  SizedBox(
                    height: 10.0,
                  ),
                  CircleAvatar(
                    radius: 100, // set the radius of the CircleAvatar
                    backgroundImage: NetworkImage(
                      'https://e1.pxfuel.com/desktop-wallpaper/446/538/desktop-wallpaper-mizuhara-chizuru-iphone-mizuhara-chizuru-thumbnail.jpg', // set the URL of the image
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    "Mizuhara",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            ),
          ),
          body: Container(
              child: Column(
            children: [
              SizedBox(
                height: 10.0,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "userID ",
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                ),
                controller: nameController,
              ),
              SizedBox(
                height: 10.0,
              ),
              ElevatedButton(
                child: Text("Search"),
                style: TextButton.styleFrom(minimumSize: Size(150, 40)),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => Details(x: nameController.text)));
                },
              ),
              SizedBox(
                height: 10.0,
              ),
              Image.network(
                'https://images.pexels.com/photos/2365457/pexels-photo-2365457.jpeg?auto=compress&cs=tinysrgb&w=600',
                fit: BoxFit.scaleDown,
              ),
            ],
          ))),
    );
  }
}

class Details extends StatelessWidget {
  dynamic x;
  int i = 0;

  Details({@required this.x});

  final Stream<QuerySnapshot> studentsStream =
      FirebaseFirestore.instance.collection('DATA').snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: studentsStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          print("has error in last widget by tec");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        final List storedocs = [];
        snapshot.data!.docs.map((DocumentSnapshot document) {
          Map a = document.data() as Map<String, dynamic>;
          storedocs.add(a);
        }).toList();

        for (i = 0; i < storedocs.length; i++) {
          print(i);
          if (storedocs[i]['name'] == x) {
            break;
          }
        }
        return MaterialApp(
          home: Scaffold(
            body: Padding(
              padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 50),
              child: Column(
                children: [
                  SizedBox(
                    height: 10.0,
                  ),
                  CircleAvatar(
                    radius: 100, // set the radius of the CircleAvatar
                    backgroundImage: NetworkImage(
                      storedocs[i]['image'], // set the URL of the image
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Name",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        storedocs[i]['name'],
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 50.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Age",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        storedocs[i]['age'],
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 50.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Sex",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        storedocs[i]['sex'],
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 50.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Occupation",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        storedocs[i]['occupation'],
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 50.0,
                  ),
                  ElevatedButton(
                    child: Text("Back", style: TextStyle(fontSize: 30)),
                    style: TextButton.styleFrom(minimumSize: Size(200, 80)),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
