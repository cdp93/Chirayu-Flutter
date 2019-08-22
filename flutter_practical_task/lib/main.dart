import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'ResponseData.dart';
import 'Database.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Practical Task'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ResponseData responseData;
  var isLoading = false;
  ScrollController scrollController = new ScrollController();

  _fetchData() async {
    setState(() {
      isLoading = true;
    });
    final response = await http.get("https://reqres.in/api/users?page=1");
    if (response.statusCode == 200) {
      /*list = (json.decode(response.body) as List)
          .map((data) => new ResponseData.fromJson(data))
          .toList();*/
      responseData = new ResponseData.fromJson(json.decode(response.body));

      responseData.data.forEach((f) => DBProvider.db.newClient(f));

      debugPrint('DATAAA: ${json.decode(response.body)}');

      setState(() {
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load photos');
    }
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: RaisedButton(
          child: new Text("Add Data"),
          onPressed: addNewStaticData,
        ),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : FutureBuilder<List<DataArr>>(
              future: DBProvider.db.getAllClients(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<DataArr>> snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    /*reverse: true,
                    shrinkWrap: true,*/
                    controller: scrollController,
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      DataArr item = snapshot.data[index];
                      return Dismissible(
                        key: UniqueKey(),
                        background: Container(color: Colors.red),
                        onDismissed: (direction) {
                          DBProvider.db.deleteClient(item.id);
                        },
                        child: ListTile(
                          contentPadding: EdgeInsets.all(10.0),
                          leading: new Text(item.id.toString()),
                          title: new Text(item.email),
                          subtitle:
                              new Text(item.first_name + " " + item.last_name),
                          trailing: new Image.network(
                            item.avatar,
                            fit: BoxFit.cover,
                            height: 40.0,
                            width: 40.0,
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
    );
  }

  addNewStaticData() {
    DBProvider.db.newClient(new DataArr.put(
        id: new Random().nextInt(100),
        email: "manual.testing@gmail.com",
        first_name: "Index is ",
        last_name: "Random Number",
        avatar:
            "https://lh3.googleusercontent.com/-kNtNozkgiiQ/XQdsL2kgZsI/AAAAAAAAIW8/ALaqF_vBSG0pUMgvNtsBgduB3EdMD5FTwCEwYBhgL/w140-h140-p/pp.jpg"));

    Timer(
        Duration(milliseconds: 100),
        () =>
            scrollController.jumpTo(scrollController.position.maxScrollExtent));
    setState(() {
      //scrollController.jumpTo(scrollController.position.maxScrollExtent);
      /* scrollController.animateTo(
        //100000000000000,
        0.0,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 1000),
      );*/
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
  }
}
