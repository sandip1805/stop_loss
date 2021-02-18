import 'package:flutter/material.dart';
import 'package:stop_loss/components/custom_outlined_button.dart';
import 'package:stop_loss/components/custom_toggle_button.dart';
import 'package:stop_loss/components/result_box.dart';
import 'package:stop_loss/components/text_field.dart';
import 'package:stop_loss/config/size_config.dart';
import 'package:toggle_switch/toggle_switch.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Stop Loss',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'StopLoss'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool shouldShowResult = false;
  bool isQuantity = true;
  bool isStopLossPercentage = true;
  bool isTargetPercentage = true;
  double entryPrice = 0;
  double investedAmount = 0;
  double stopLossPrice = 0;
  double stopLossPercentage = 0;
  double targetPrice = 0;
  double targetPercentage = 0;
  double quantity = 0;
  double totalProfit = 0, totalLoss = 0;
  final _formKey = GlobalKey<FormState>();
  var qtyAmtData = [
    {'widget': Text('Qty'), 'isSelected': true},
    {'widget': Text('Amt'), 'isSelected': false}
  ];

  var stopLossPercentageAmountData = [
    {'widget': Text('%'), 'isSelected': true},
    {'widget': Text('\$'), 'isSelected': false}
  ];

  var targetPercentageAmountData = [
    {'widget': Text('%'), 'isSelected': true},
    {'widget': Text('\$'), 'isSelected': false}
  ];

  reset() {
    setState(() {
      shouldShowResult = false;
      _formKey.currentState.reset();
      isQuantity = true;
      isStopLossPercentage = true;
      isTargetPercentage = true;
      entryPrice = 0;
      investedAmount = 0;
      stopLossPrice = 0;
      stopLossPercentage = 0;
      targetPrice = 0;
      targetPercentage = 0;
      quantity = 0;
      totalProfit = 0;
      totalLoss = 0;
    });
  }

  void calculate() {
    if (_formKey.currentState.validate()) {
      setState(() {
        shouldShowResult = true;
        targetPrice = isTargetPercentage
            ? (entryPrice + ((targetPercentage / 100) * entryPrice))
            : targetPrice;
        print('targetPrice $targetPrice');

        targetPercentage = isTargetPercentage
            ? targetPercentage
            : calculatePercentage(targetPrice, entryPrice);
        print('targetPercentage $targetPercentage');

        stopLossPrice = isStopLossPercentage
            ? (entryPrice - ((stopLossPercentage / 100) * entryPrice))
            : stopLossPrice;
        print('stopLossPrice $stopLossPrice');

        investedAmount = isQuantity ? (quantity * entryPrice) : investedAmount;
        print('investedAmount $investedAmount');

        quantity = isQuantity ? quantity : (investedAmount / entryPrice);
        print('quantity $quantity');

        totalProfit = (targetPrice - entryPrice) * quantity;
        print('totalProfit $totalProfit');

        totalLoss = (entryPrice - stopLossPrice) * quantity;
        print('totalLoss $totalLoss');

        stopLossPercentage = isStopLossPercentage
            ? stopLossPercentage
            : calculatePercentage(entryPrice, stopLossPrice);
        print('stopLossPercentage $stopLossPercentage');
      });
    }
  }

  calculatePercentage(double a, double b) {
    return ((a - b) / b) * 100;
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.money_off_rounded),
            onPressed: () {},
          ),
        ],
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {},
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    12.0,
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.all(12.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          height: SizeConfig.safeBlockVertical * 1,
                        ),
                        CustomTextField(
                          onChanged: (value) {
                            setState(() {
                              entryPrice = double.parse(value);
                            });
                          },
                          hintText: 'Stock Entry Price',
                          labelText: 'Entry Price',
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter entry price';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: SizeConfig.safeBlockVertical * 2,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 2,
                              child: CustomTextField(
                                onChanged: (value) {
                                  setState(
                                    () {
                                      var parsedValue = double.parse(value);
                                      if (isQuantity) {
                                        quantity = parsedValue.ceilToDouble();
                                      } else {
                                        investedAmount =
                                            parsedValue.ceilToDouble();
                                      }
                                    },
                                  );
                                },
                                hintText: isQuantity
                                    ? 'Enter Stock Quantity'
                                    : 'Enter Your Investment Amount',
                                labelText: isQuantity ? 'Quantity' : 'Amount',
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter ' +
                                        (isQuantity ? 'Quantity' : 'Amount');
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: CustomToggleButton(
                                data: qtyAmtData,
                                onPressed: (index) {
                                  setState(() {
                                    qtyAmtData.asMap().forEach((i, x) {
                                      if (i == index) {
                                        x['isSelected'] = true;
                                      } else {
                                        x['isSelected'] = false;
                                      }
                                    });
                                    isQuantity = index == 0 ? true : false;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: SizeConfig.safeBlockVertical * 2,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 2,
                              child: CustomTextField(
                                onChanged: (value) {
                                  setState(() {
                                    if (isStopLossPercentage) {
                                      stopLossPercentage = double.parse(value);
                                    } else {
                                      stopLossPrice = double.parse(value);
                                    }
                                  });
                                },
                                hintText: isStopLossPercentage
                                    ? 'Enter StopLoss Percentage'
                                    : 'Enter StopLoss Price',
                                labelText: isStopLossPercentage
                                    ? 'StopLoss %'
                                    : 'StopLoss',
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter StopLoss';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              child: CustomToggleButton(
                                data: stopLossPercentageAmountData,
                                onPressed: (index) {
                                  setState(() {
                                    stopLossPercentageAmountData
                                        .asMap()
                                        .forEach((i, x) {
                                      if (i == index) {
                                        x['isSelected'] = true;
                                      } else {
                                        x['isSelected'] = false;
                                      }
                                    });
                                    isStopLossPercentage =
                                        index == 0 ? true : false;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: SizeConfig.safeBlockVertical * 2,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 2,
                              child: CustomTextField(
                                onChanged: (value) {
                                  setState(() {
                                    var parsedValue = double.parse(value);
                                    if (isTargetPercentage) {
                                      targetPercentage = parsedValue;
                                    } else {
                                      targetPrice = parsedValue;
                                    }
                                  });
                                },
                                hintText: isTargetPercentage
                                    ? 'Enter Target Percentage'
                                    : 'Enter Target Price',
                                labelText:
                                    isTargetPercentage ? 'Target %' : 'Target',
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter target amount';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(
                              width: SizeConfig.safeBlockHorizontal * 4,
                            ),
                            Expanded(
                              child: CustomToggleButton(
                                data: targetPercentageAmountData,
                                onPressed: (index) {
                                  setState(() {
                                    targetPercentageAmountData
                                        .asMap()
                                        .forEach((i, x) {
                                      if (i == index) {
                                        x['isSelected'] = true;
                                      } else {
                                        x['isSelected'] = false;
                                      }
                                    });
                                    isStopLossPercentage =
                                        index == 0 ? true : false;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: SizeConfig.safeBlockVertical * 2,
                        ),
                        CustomOutlinedButton(
                          buttonLabel: 'Calculate',
                          onPressed: calculate,
                        ),
                        SizedBox(
                          height: SizeConfig.safeBlockVertical * 1.5,
                        ),
                        CustomOutlinedButton(
                          buttonLabel: 'Reset',
                          onPressed: reset,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            shouldShowResult
                ? Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ResultBox(
                      entryPrice: entryPrice,
                      investedAmount: investedAmount,
                      quantity: quantity,
                      stopLossPercentage: stopLossPercentage,
                      targetPercentage: targetPercentage,
                      targetPrice: targetPrice,
                      totalLoss: totalLoss,
                      totalProfit: totalProfit,
                    ),
                  )
                : Container(),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
