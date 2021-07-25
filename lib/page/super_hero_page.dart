import 'package:app/model/super_hero.dart';
import 'package:app/widget/card/main_information_card.dart';
import 'package:flutter/material.dart';

class SuperHeroPage extends StatelessWidget {
  static const routeName = '/super-hero';

  @override
  Widget build(BuildContext context) {
    final SuperHero superHero =
        ModalRoute.of(context)!.settings.arguments as SuperHero;
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          // Add the app bar to the CustomScrollView.
          SliverAppBar(
            title: Text(superHero.name ?? "Sem nome"),
            floating: true,
          ),
          SliverToBoxAdapter(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                buildMainCard(context, superHero),
                buildPowerstatsCard(context, superHero),
                buildAppearanceCard(context, superHero),
                buildBiographyCard(context, superHero),
                buildWorkCard(context, superHero),
                buildConnectionsCard(context, superHero),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Build Core

  buildTitle(BuildContext context, String s) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Text(
        s.toUpperCase(),
        style: TextStyle(
            fontSize: 24,
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold),
      ),
    );
  }

  buildInfo(String desc, dynamic info) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(width: double.infinity, child: Text("$desc: $info")),
    );
  }

  // Build Cards

  buildMainCard(BuildContext context, SuperHero superHero) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: MainInformationCard(superHero: superHero,),
    );
  }

  buildPowerstatsCard(BuildContext context, SuperHero superHero) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: double.infinity,
            child: Column(
              children: [
                buildTitle(context, "Powerstats"),
                buildInfo("Durability", superHero.powerstats?.durability),
                buildInfo("Combat", superHero.powerstats?.combat),
                buildInfo("Power", superHero.powerstats?.power),
                buildInfo("Speed", superHero.powerstats?.speed),
                buildInfo("Intelligence", superHero.powerstats?.intelligence),
                buildInfo("Strength", superHero.powerstats?.strength),
              ],
            ),
          ),
        ),
      ),
    );
  }

  buildAppearanceCard(BuildContext context, SuperHero superHero) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: double.infinity,
            child: Column(
              children: [
                buildTitle(context, "Appearance"),
                buildInfo("Gender", superHero.appearance?.gender),
                buildInfo("EyeColor", superHero.appearance?.eyeColor),
                buildInfo("HairColor", superHero.appearance?.hairColor),
                buildInfo("Race", superHero.appearance?.race),
                //TODO: Repensar listas
                buildInfo("Height", superHero.appearance?.height),
                buildInfo("Weight", superHero.appearance?.weight),
              ],
            ),
          ),
        ),
      ),
    );
  }

  buildBiographyCard(BuildContext context, SuperHero superHero) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: double.infinity,
            child: Column(
              children: [
                buildTitle(context, "Biography"),
                buildInfo("Alignment", superHero.biography?.alignment),
                buildInfo("Alter Egos", superHero.biography?.alterEgos),
                buildInfo(
                    "First Appearance", superHero.biography?.firstAppearance),
                buildInfo("Full Name", superHero.biography?.fullName),
                buildInfo("Place Of Birth", superHero.biography?.placeOfBirth),
                buildInfo("Publisher", superHero.biography?.publisher),
                //TODO: Repensar listas
                buildInfo("Aliases", superHero.biography?.aliases),
              ],
            ),
          ),
        ),
      ),
    );
  }

  buildWorkCard(BuildContext context, SuperHero superHero) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: double.infinity,
            child: Column(
              children: [
                buildTitle(context, "Work"),
                buildInfo("Base", superHero.work?.base),
                buildInfo("Occupation", superHero.work?.occupation),
              ],
            ),
          ),
        ),
      ),
    );
  }

  buildConnectionsCard(BuildContext context, SuperHero superHero) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: double.infinity,
            child: Column(
              children: [
                buildTitle(context, "Connections"),
                buildInfo("Relatives", superHero.connections?.relatives),
                buildInfo("Group Affiliation",
                    superHero.connections?.groupAffiliation),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
