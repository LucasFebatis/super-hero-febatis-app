import 'package:app/model/super_hero.dart';
import 'package:flutter/material.dart';

class SuperHeroPage extends StatelessWidget {
  static const routeName = '/super-hero';

  @override
  Widget build(BuildContext context) {
    final SuperHero superHero = ModalRoute.of(context).settings.arguments;
    return CustomScrollView(
      slivers: <Widget>[
        // Add the app bar to the CustomScrollView.
        SliverAppBar(
          title: Text(superHero.name),
          floating: true,
        ),
      ],
    );
  }
}
