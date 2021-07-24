import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:app/page/super_hero_page.dart';
import 'package:app/model/super_hero.dart';
import 'package:app/widget/filter_bottom_sheet.dart';
import 'package:app/widget/sort_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<SuperHero> futureSuperHeroDataBase = List.empty();
  List<SuperHero> futureSuperHeroFilteredDataBase = List.empty();
  List<String?> genderSet = List.empty();
  List<String?> alignmentSet = List.empty();
  Map<String?, bool> genderMap = Map();
  Map<String?, bool> alignmentMap = Map();
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    fetchSuperHeroList().then((value) => successCallback(value));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
          builder: (context) =>
              buildList(context, futureSuperHeroFilteredDataBase)),
      floatingActionButton: FloatingActionButton(
        onPressed: randomSuperHero,
        tooltip: 'Random Super hero',
        child: Icon(Icons.shuffle),
      ),
    );
  }

  // Build Widgets

  Widget buildList(BuildContext context, List<SuperHero> snapshot) {
    if (snapshot.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }

    return CustomScrollView(
      slivers: <Widget>[
        // Add the app bar to the CustomScrollView.
        SliverAppBar(
          title: buildAppBarTitle(),
          actions: buildAppBarActions(),
          floating: false,
        ),
        SliverToBoxAdapter(
          child: buildFilterBar(context),
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
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  snapshot.name ?? "Sem nome",
                  style: TextStyle(fontSize: 18),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  getFullname(snapshot),
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildFilterBar(BuildContext context) {
    return Wrap(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              Padding(
                padding:
                const EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
                child: ActionChip(
                  backgroundColor: Colors.transparent,
                  shape: StadiumBorder(
                      side: BorderSide(color: Colors.grey, width: 0.5)),
                  avatar: Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.grey,
                  ),
                  label: Text('Ordenar'),
                  onPressed: () {
                    showSortOptions(context);
                  },
                ),
              ),
              Padding(
                padding:
                const EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
                child: ActionChip(
                  backgroundColor: Colors.transparent,
                  shape: StadiumBorder(
                      side: BorderSide(color: Colors.grey, width: 0.5)),
                  avatar: Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.grey,
                  ),
                  label: Text('Gênero'),
                  onPressed: () {
                    showFilterOptions(context, 'Gênero', genderSet, genderMap);
                  },
                ),
              ),
              Padding(
                padding:
                const EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
                child: ActionChip(
                  backgroundColor: Colors.transparent,
                  shape: StadiumBorder(
                      side: BorderSide(color: Colors.grey, width: 0.5)),
                  avatar: Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.grey,
                  ),
                  label: Text('Orientação'),
                  onPressed: () {
                    showFilterOptions(
                        context, 'Orientação', alignmentSet, alignmentMap);
                  },
                ),
              ),
            ],
          ),
        ),
      ],
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

      genderSet = futureSuperHeroFilteredDataBase
          .map((e) => e.appearance?.gender)
          .toSet()
          .toList();

      alignmentSet = futureSuperHeroFilteredDataBase
          .map((e) => e.biography?.alignment)
          .toSet()
          .toList();

      genderSet.forEach((element) => genderMap[element] = false);
      alignmentSet.forEach((element) => alignmentMap[element] = false);
    });
  }

  void filterSuperHeroList(String value) {
    setState(() {
      futureSuperHeroFilteredDataBase = futureSuperHeroDataBase
          .where((item) =>
      item.name?.toLowerCase().contains(value.toLowerCase()) ?? false)
          .toList();
    });
  }

  void showFilterOptions(BuildContext context, String title,
      List<String?> optionsSet, Map<String?, bool> optionsMap) {
    showModalBottomSheet(
        context: context,
        builder: (context) =>
            FilterBottomSheet(
                title: title,
                optionsSet: optionsSet,
                optionsMap: optionsMap,
                onChange: (item, value) {
                  optionsMap[item] = value;
                }));
  }

  void showSortOptions(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) =>
            SortBottomSheet(onChange: (item) {
              print("$item");
            }));
  }

  String getFullname(SuperHero snapshot) {
    var isEmpty = snapshot.biography?.fullName?.isEmpty ?? true;
    return isEmpty ? "Desconhecido" : snapshot.biography!.fullName!;
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
