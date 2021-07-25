import 'package:flutter/material.dart';

class SortBottomSheet extends StatefulWidget {
  const SortBottomSheet({Key? key, required this.initalSortAz, required this.onChange}) : super(key: key);

  final bool initalSortAz;
  final Function(String) onChange;

  @override
  _SortBottomSheetState createState() => _SortBottomSheetState();
}

class _SortBottomSheetState extends State<SortBottomSheet> {
  bool sortAz = true;

  @override
  void initState() {
    super.initState();
    sortAz = widget.initalSortAz;
  }

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
                      selected: sortAz,
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
                      selected: !sortAz,
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
    widget.onChange(value);
    switch (value) {
      case "A-Z":
        sortAz = true;
        break;
      case "Z-A":
        sortAz = false;
        break;
    }

    setState(() {});
  }
}
