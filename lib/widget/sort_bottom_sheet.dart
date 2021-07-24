import 'package:flutter/material.dart';

class SortBottomSheet extends StatefulWidget {
  const SortBottomSheet(
      {Key? key,
      required this.onChange})
      : super(key: key);

  final Function(String) onChange;

  @override
  _SortBottomSheetState createState() => _SortBottomSheetState();
}

class _SortBottomSheetState extends State<SortBottomSheet> {

  bool isAzSelected = true;
  bool isZaSelected = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              "Sort",
              style: TextStyle(fontSize: 24),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 2.0, horizontal: 8.0),
                    child: ChoiceChip(
                      onSelected: (value) => setSelected("A-Z"),
                      selected: isAzSelected,
                      label: Text(
                        "A-Z",
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 2.0, horizontal: 8.0),
                    child: ChoiceChip(
                      onSelected: (value) => setSelected("Z-A"),
                      selected: isZaSelected,
                      label: Text(
                        "Z-A",
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void setSelected(value) {
    switch(value) {
      case "A-Z":
        isAzSelected = true;
        isZaSelected = false;
        break;
      case "Z-A":
        isAzSelected = false;
        isZaSelected = true;
        break;
    }

    setState(() {});
  }
}
