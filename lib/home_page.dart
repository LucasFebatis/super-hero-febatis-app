import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:app/page/super_hero_page.dart';
import 'package:app/super_hero.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<SuperHero> futureSuperHeroDataBase;
  List<SuperHero> futureSuperHeroFilteredDataBase;
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    fetchSuperHeroList().then((value) => successCallback(value));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildList(futureSuperHeroFilteredDataBase),
      floatingActionButton: FloatingActionButton(
        onPressed: randomSuperHero,
        tooltip: 'Random Super hero',
        child: Icon(Icons.shuffle),
      ),
    );
  }

  // Build Widgets

  Widget buildList(List<SuperHero> snapshot) {
    if (snapshot == null) {
      return Center(child: CircularProgressIndicator());
    }

    return CustomScrollView(
      slivers: <Widget>[
        // Add the app bar to the CustomScrollView.
        SliverAppBar(
          title: buildAppBarTitle(),
          actions: buildAppBarActions(),
          floating: true,
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => buildItemList(snapshot[index]),
            childCount: snapshot.length,
          ),
        ),
      ],
    );
  }

  Widget buildErrorMessage(AsyncSnapshot<List<SuperHero>> snapshot) {
    return Center(child: Text("${snapshot.error}"));
  }

  Widget buildAppBarTitle() {
    return !isSearching
        ? Text(widget.title)
        : TextField(
            onChanged: (value) {
              filterSuperHeroList(value);
            },
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
                icon: Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                hintText: "Search for name",
                hintStyle: TextStyle(color: Colors.white)),
          );
  }

  List<Widget> buildAppBarActions() {
    return <Widget>[
      isSearching
          ? IconButton(
              icon: Icon(Icons.cancel),
              onPressed: () {
                setState(() {
                  isSearching = false;
                  futureSuperHeroFilteredDataBase = futureSuperHeroDataBase;
                });
              },
            )
          : IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                setState(() {
                  isSearching = true;
                });
              },
            )
    ];
  }

  Widget buildItemList(SuperHero snapshot) {
    return GestureDetector(
      onTap: () {
        goToSuperHero(snapshot);
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: Text(
            snapshot.name,
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }

  Widget _buildPanel() {
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          // advFilterIsExpanded = !isExpanded;
        });
      },
      children: [
        ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              title: Text("Advanced Filters"),
            );
          },
          body: ListTile(
            title: Text("Chips de filtragem"),
            subtitle:
                const Text('To delete this panel, tap the trash can icon'),
            trailing: const Icon(Icons.delete),
          ),
          // isExpanded: advFilterIsExpanded,
        )
      ],
    );
  }

// Page Methods

  void goToSuperHero(SuperHero snapshot) {
    Navigator.of(context)
        .pushNamed(SuperHeroPage.routeName, arguments: snapshot);
  }

  void randomSuperHero() {
    var randomHero = Random().nextInt(futureSuperHeroDataBase.length);
    goToSuperHero(futureSuperHeroDataBase[randomHero]);
  }

  void successCallback(List<SuperHero> value) {
    setState(() {
      futureSuperHeroDataBase = value;
      futureSuperHeroFilteredDataBase = value;
    });
  }

  void filterSuperHeroList(String value) {
    setState(() {
      futureSuperHeroFilteredDataBase = futureSuperHeroDataBase
          .where(
              (item) => item.name.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

//Requests

  Future<List<SuperHero>> fetchSuperHeroList() async {
    final response = await http
        .get(Uri.parse('https://akabab.github.io/superhero-api/api/all.json'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      Iterable l = jsonDecode(response.body);
      return List<SuperHero>.from(l.map((model) => SuperHero.fromJson(model)));
      // return SuperHero.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }
}
