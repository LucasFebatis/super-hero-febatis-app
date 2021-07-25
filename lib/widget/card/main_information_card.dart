import 'package:app/model/super_hero.dart';
import 'package:flutter/material.dart';

class MainInformationCard extends StatelessWidget {
  const MainInformationCard({Key? key, required this.superHero}) : super(key: key);

  final SuperHero superHero;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Row(
          children: [
            Container(
              width: 64.0,
              height: 64.0,
              decoration: new BoxDecoration(
                shape: BoxShape.circle,
                image: new DecorationImage(
                  fit: BoxFit.fill,
                  image: new NetworkImage(superHero.images?.md ?? ""),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        superHero.name ?? "Sem nome",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        getFullname(superHero),
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getFullname(SuperHero snapshot) {
    var isEmpty = snapshot.biography?.fullName?.isEmpty ?? true;
    return isEmpty ? "Desconhecido" : snapshot.biography!.fullName!;
  }
}
