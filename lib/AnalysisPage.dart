import 'package:flutter/material.dart';
import 'CategoriesDatabaseHelper.dart';
import 'CategoryPage.dart';

class AnalysisPage extends StatefulWidget {
  final String ingredientsExtractedText;
  final String tableExtractedText;
  final Map<String, List<String>> dataset = {
    '451': [
      'Description\n\nIs a common food additive found in many types of processed foods, such as cereals, cheeses, soda, and baked goods.\n\nSide Effects\n\nHigh levels of sodium phosphate can harm the body',
      '-1'
    ],
    '508': ['Description\n\nasf\n\nSide Effect\n\nngvd', '1']
  };

  AnalysisPage({
    Key? key,
    required this.ingredientsExtractedText,
    required this.tableExtractedText,
  }) : super(key: key);

  @override
  State<AnalysisPage> createState() => _AnalysisPageState();
}

class _AnalysisPageState extends State<AnalysisPage> {
  Set<String> expandedIngredients = Set<String>();
  late final _sodiumTextcontroller;
  late final _carbsTextcontroller;
  late final _sugarTextcontroller;

  static const sodium = [
    "sodium",
    "sodlum",
    "s0dium",
    "s0dlum",
    "5odium",
    "5odlum",
    "50dium",
    "50dlum"
  ];

  static const sugar = ["sugar", "5ugar", "sucar", "5ucar"];

  static const carbohydates = ["carbohydrates", "carbohydrate"];

  double? extractQuantity(String string) {
    RegExpMatch? match = RegExp(r'\d+\.\d+').firstMatch(string);
    RegExpMatch? match2 = RegExp(r'\d+').firstMatch(string);
    if (match != null) {
      return double.parse(match.group(0)!);
    } else if (match2 != null) {
      return double.parse(match2.group(0)!);
    } else {
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    
    // create a array of all the words in the table text
    List<String> tableWords = widget.tableExtractedText.split(' ');

    // find sodium in the table text, get the index of the word and get the next double after it
    int sodiumIndex = tableWords.indexWhere((element) => sodium.contains(element.toLowerCase()));
    if (sodiumIndex != -1) {
      _sodiumTextcontroller = TextEditingController(text: extractQuantity(tableWords[sodiumIndex + 1])?.toString());
    } else {
      _sodiumTextcontroller = TextEditingController(text: '0');
    }

    // find sugar in the table text, get the index of the word and get the next double after it
    int sugarIndex = tableWords.indexWhere((element) => sugar.contains(element.toLowerCase()));
    if (sugarIndex != -1) {
      _sugarTextcontroller = TextEditingController(text: extractQuantity(tableWords[sugarIndex + 1])?.toString());
    } else {
      _sugarTextcontroller = TextEditingController(text: '0');
    }

    // find carbohydrates in the table text, get the index of the word and get the next double after it
    int carbohydratesIndex = tableWords.indexWhere((element) => carbohydates.contains(element.toLowerCase()));
    if (carbohydratesIndex != -1) {
      _carbsTextcontroller = TextEditingController(text: extractQuantity(tableWords[carbohydratesIndex + 1])?.toString());
    } else {
      _carbsTextcontroller = TextEditingController(text: '0');
    }


  }

  @override
  Widget build(BuildContext context) {
    List<String> ingredientsMatches =
        compareWithDataset(widget.ingredientsExtractedText, widget.dataset);

    return Scaffold(
      appBar: AppBar(
        title: Text('Analysis Page'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Ingredients Text: ${widget.ingredientsExtractedText}'),
            Text('Table Text: ${widget.tableExtractedText}'),
            SizedBox(height: 20),
            Text('Matching Ingredients:'),
            Column(
              children: ingredientsMatches.map((match) {
                return Column(
                  children: [
                    InkWell(
                      onTap: () {
                        _toggleIngredient(match);
                      },
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              match,
                              style: TextStyle(
                                color: getColorForHealthAdvisory(
                                  widget.dataset[match]![1],
                                ),
                              ),
                            ),
                            Icon(Icons.arrow_forward),
                          ],
                        ),
                      ),
                    ),
                    Divider(),
                  ],
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            Text('Categories Present:'),
            FutureBuilder<List<Map<String, dynamic>>?>(
              future: CategoriesDatabaseHelper.readCheckedCategories(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Text('No categories found');
                } else {
                  List<String> checkedCategories = snapshot.data!
                      .where((category) => category['checked'] == 1)
                      .map((category) => category['name'] as String)
                      .toList();

                  return Column(
                    children: checkedCategories
                        .map(
                          (category) => Text(
                            category,
                            style: TextStyle(
                              color: widget.ingredientsExtractedText
                                      .toLowerCase()
                                      .contains(category.toLowerCase())
                                  ? Colors.green
                                  : Colors.transparent,
                            ),
                          ),
                        )
                        .toList(),
                  );
                }
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CategoryPage(),
                  ),
                );
              },
              child: Text('Edit Categories'),
            ),
            // Display quantity input for Sodium
            _buildQuantityWidget('Sodium Quantity', _sodiumTextcontroller),
            Quantity(
              percent: double.parse(_sodiumTextcontroller.text ?? '0') / 23,
              max: 2300,
              amount: double.parse(_sodiumTextcontroller.text ?? '0') / 23,
              name: 'Sodium',
            ),
            // Display quantity input for Sugar
            _buildQuantityWidget('Sugar Quantity', _sugarTextcontroller),
            Quantity(
              percent: double.parse(_sugarTextcontroller.text ?? '0') / 0.3,
              max: 30,
              amount: double.parse(_sugarTextcontroller.text ?? '0') / 0.3,
              name: 'Sugar',
            ),
            // Display quantity input for Carbs
            _buildQuantityWidget('Carbs Quantity', _carbsTextcontroller),
            Quantity(
              percent: double.parse(_carbsTextcontroller.text ?? '0') / 3.25,
              max: 325,
              amount: double.parse(_carbsTextcontroller.text ?? '0') / 3.25,
              name: 'Carbs',
            ),
          ],
        ),
      ),
    );
  }

  void _toggleIngredient(String ingredient) {
    setState(() {
      if (expandedIngredients.contains(ingredient)) {
        expandedIngredients.remove(ingredient);
      } else {
        expandedIngredients.add(ingredient);
      }
    });
  }

  Widget _buildQuantityWidget(
      String labelText, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 130),
      child: TextFormField(
        onFieldSubmitted: (value) {
          setState(() {
            print(controller.text);
          });
        },
        textAlign: TextAlign.center,
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: labelText,
        ),
      ),
    );
  }

  List<String> compareWithDataset(
    String extractedText,
    Map<String, List<String>> dataset,
  ) {
    List<String> matches = [];

    for (String key in dataset.keys) {
      if (extractedText.toLowerCase().contains(key)) {
        matches.add(key);
      }
    }

    return matches;
  }

  Color getColorForHealthAdvisory(String healthAdvisory) {
    int advisoryValue = int.tryParse(healthAdvisory) ?? 0;

    if (advisoryValue == 1) {
      return Colors.green;
    } else if (advisoryValue == -1) {
      return Colors.red;
    } else {
      return Colors.transparent;
    }
  }
}

class Quantity extends StatefulWidget {
  final double percent;
  final double max;
  final double amount;
  final String name;

  const Quantity({
    Key? key,
    required this.percent,
    required this.max,
    required this.amount,
    required this.name,
  }) : super(key: key);

  @override
  State<Quantity> createState() => _QuantityState();
}

class _QuantityState extends State<Quantity> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text(widget.name),
          LinearProgressIndicator(
            value: widget.percent / 100,
          ),
          Text(widget.amount.toString() + "%"),
        ],
      ),
    );
  }
}
