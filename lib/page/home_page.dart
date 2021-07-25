import 'dart:math';

import 'package:app/controller/home_controller.dart';
import 'package:app/dialogs/error_dialog.dart';
import 'package:app/page/super_hero_page.dart';
import 'package:app/model/super_hero.dart';
import 'package:app/widget/bottomsheet/filter_bottom_sheet.dart';
import 'package:app/widget/card/main_information_card.dart';
import 'package:app/widget/bottomsheet/sort_bottom_sheet.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomeController homeController = HomeController();

  List<SuperHero> futureSuperHeroDataBase = List.empty();
  List<SuperHero> futureSuperHeroFilteredDataBase = List.empty();
  List<String?> genderSet = <String?>[];
  List<String?> alignmentSet = <String?>[];
  Map<String?, bool> genderMap = Map();
  Map<String?, bool> alignmentMap = Map();
  bool isSearching = false;

  String nameToFilter = "";
  List<String?> genderToFilter = <String?>[];
  List<String?> alignmentToFilter = <String?>[];

  bool sortAz = true;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchSuperHero();

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
    if (isLoading) {
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
              nameToFilter = value;
              applyFilter();
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
                  nameToFilter = "";
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
      child: MainInformationCard(
        superHero: snapshot,
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
                    showFilterOptions(context, 'Gênero', genderSet, genderMap,
                        genderToFilter);
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
                    showFilterOptions(context, 'Orientação', alignmentSet,
                        alignmentMap, alignmentToFilter);
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

  void applyFilter() {
    setState(() {
      futureSuperHeroFilteredDataBase = futureSuperHeroDataBase
          .where((item) => filterFunction(item))
          .toList();

      if (sortAz) {
        futureSuperHeroFilteredDataBase
            .sort((a, b) => a.name?.compareTo(b.name ?? "") ?? 0);
      } else {
        futureSuperHeroFilteredDataBase
            .sort((a, b) => b.name?.compareTo(a.name ?? "") ?? 0);
      }
    });
  }

  void showFilterOptions(
      BuildContext context,
      String title,
      List<String?> optionsSet,
      Map<String?, bool> optionsMap,
      List<String?> filterList) {
    showModalBottomSheet(
        context: context,
        builder: (context) => FilterBottomSheet(
            title: title,
            optionsSet: optionsSet,
            optionsMap: optionsMap,
            onChange: (item, value) {
              optionsMap[item] = value;
              if (value) {
                filterList.add(item);
              } else {
                filterList.remove(item);
              }
              applyFilter();
            }));
  }

  void showSortOptions(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) => SortBottomSheet(
            initalSortAz: sortAz,
            onChange: (item) {
              sortAz = item == "A-Z";
              applyFilter();
            }));
  }

  Future<void> showErrorDialog(Object error) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return ErrorDialog(error: error, listener: fetchSuperHero);
      },
    );
  }

  bool filterFunction(SuperHero item) {
    final bool isToApplyGender = genderToFilter.isNotEmpty;
    final bool isToApplyAlignment = alignmentToFilter.isNotEmpty;

    bool containsGender = true;
    bool containsAlignment = true;

    bool containsText =
        item.name?.toLowerCase().contains(nameToFilter.toLowerCase()) ?? false;

    if (isToApplyGender) {
      containsGender = genderToFilter.contains(item.appearance?.gender);
    }

    if (isToApplyAlignment) {
      containsAlignment = alignmentToFilter.contains(item.biography?.alignment);
    }

    return containsGender && containsAlignment && containsText;
  }

  void updateLoading(value) {
    isLoading = value;
    setState(() {});
  }

  void fetchSuperHero() {
    homeController.getAll().then(successCallback).catchError(errorCallback);
  }

  // Requests Callback

  void successCallback(List<SuperHero> value) {
    updateLoading(false);

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

  void errorCallback(Object error) {
    updateLoading(false);
    showErrorDialog(error);
  }
}
