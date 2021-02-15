import 'package:flutter/material.dart';
import 'package:stop_loss/components/custom_outlined_button.dart';
import 'package:stop_loss/components/display_label.dart';
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
  bool isQuantity = true;
  bool isStopLossPercentage = true;
  bool isTargetPercentage = true;
  double entryPrice = 0;
  double investmentAmountOrQuantity = 10;
  double stopLoss = 0;
  double target = 0;

  double entry = 0,
      profit = 0,
      loss = 0,
      quantity = 0,
      investedAmount = 0,
      profitPercentage = 0,
      lossPercentage = 0,
      exit = 0;

  final _formKey = GlobalKey<FormState>();

  reset() {
    setState(() {
      isQuantity = true;
      isStopLossPercentage = true;
      isTargetPercentage = true;
      entryPrice = 0;
      investmentAmountOrQuantity = 10;
      stopLoss = 0;
      target = 0;

      _formKey.currentState.reset();

      entry = 0;
      profit = 0;
      loss = 0;
      quantity = 0;
      investedAmount = 0;
      exit = 0;
      profitPercentage = 0;
      lossPercentage = 0;
    });
  }

  void calculate() {
    if(_formKey.currentState.validate()) {
      setState(() {
        entry = entryPrice;
        exit = isTargetPercentage
            ? (entryPrice + ((target / 100) * entryPrice))
            : target;
        print('exit $exit');
        investedAmount = isQuantity
            ? (investmentAmountOrQuantity * entryPrice)
            : investmentAmountOrQuantity;
        print('investedAmount $investedAmount');
        quantity = !isQuantity
            ? (investmentAmountOrQuantity / entryPrice)
            : investmentAmountOrQuantity;
        print('quantity $quantity');
        profit = (exit - entryPrice) * quantity;
        loss = (entryPrice -
            (isStopLossPercentage
                ? (entryPrice * (1 - (stopLoss / 100)))
                : stopLoss)) *
            quantity;
        print('loss $loss');
        profitPercentage =
        isTargetPercentage ? target : ((exit - entry) / entry) * 100;
        print('profitPercentage $profitPercentage');
        lossPercentage = isStopLossPercentage
            ? stopLoss
            : (entryPrice * (1 - (stopLoss / 100)));
        print('lossPercentage $lossPercentage');
      });
    }
  }

  calculatePercentage(double a, double b) {
    return ((a-b)/b) * 100;
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
        child: Container(
          padding: const EdgeInsets.all(15.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
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
                  height: SizeConfig.safeBlockVertical * 1.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: SizeConfig.safeBlockHorizontal * 60,
                      child: CustomTextField(
                        onChanged: (value) {
                          setState(
                            () {
                              investmentAmountOrQuantity = double.parse(value);
                              if (isQuantity) {
                                investmentAmountOrQuantity =
                                    investmentAmountOrQuantity.ceilToDouble();
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
                    SizedBox(
                      width: SizeConfig.safeBlockHorizontal * 4,
                    ),
                    ToggleSwitch(
                      initialLabelIndex: isQuantity ? 0 : 1,
                      labels: ['Qty', 'Amt'],
                      fontSize: 12,
                      minWidth: 55,
                      onToggle: (index) {
                        setState(() {
                          isQuantity = !isQuantity;
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: SizeConfig.safeBlockVertical * 1.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: SizeConfig.safeBlockHorizontal * 60,
                      child: CustomTextField(
                        onChanged: (value) {
                          setState(() {
                            stopLoss = double.parse(value);
                          });
                        },
                        hintText: isStopLossPercentage ? 'Enter StopLoss Percentage' : 'Enter StopLoss Price',
                        labelText: isStopLossPercentage ? 'StopLoss %' : 'StopLoss',
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter StopLoss';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      width: SizeConfig.safeBlockHorizontal * 4,
                    ),
                    ToggleSwitch(
                      initialLabelIndex: isStopLossPercentage ? 0 : 1,
                      labels: ['%', '\$'],
                      fontSize: 14,
                      minWidth: 55,
                      onToggle: (index) {
                        setState(() {
                          isStopLossPercentage = !isStopLossPercentage;
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: SizeConfig.safeBlockVertical * 1.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: SizeConfig.safeBlockHorizontal * 60,
                      child: CustomTextField(
                        onChanged: (value) {
                          setState(() {
                            target = double.parse(value);
                          });
                        },
                        hintText: isTargetPercentage ? 'Enter Target Percentage' : 'Enter Target Price',
                        labelText: isTargetPercentage ? 'Target %' : 'Target',
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
                    ToggleSwitch(
                      initialLabelIndex: isTargetPercentage ? 0 : 1,
                      labels: ['%', '\$'],
                      fontSize: 14,
                      minWidth: 55,
                      onToggle: (index) {
                        setState(() {
                          isTargetPercentage = !isTargetPercentage;
                        });
                      },
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
                SizedBox(
                  height: SizeConfig.safeBlockVertical * 1.5,
                ),
                Divider(
                  color: Colors.black54,
                  thickness: 0.5,
                ),
                Column(
                  children: [
                    DisplayLabel(
                      keyText: 'Entry',
                      valueText: entry.toStringAsFixed(2),
                    ),
                    DisplayLabel(
                      keyText: 'Exit',
                      valueText: exit.toStringAsFixed(2),
                    ),
                    DisplayLabel(
                      keyText: 'Invested Amount',
                      valueText: investedAmount.toStringAsFixed(2),
                    ),
                    DisplayLabel(
                      keyText: 'Quantity',
                      valueText: quantity.toStringAsFixed(0),
                    ),
                  ],
                ),
                SizedBox(
                  height: SizeConfig.safeBlockVertical * 1.5,
                ),
                Divider(
                  color: Colors.black54,
                  thickness: 0.5,
                ),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Profit',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.green,
                          ),
                        ),
                        Text(
                          profit.toStringAsFixed(2) +
                              ' / ' +
                              profitPercentage.toStringAsFixed(1) +
                              '%',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RichText(
                          text: TextSpan(
                            text: 'Total Loss',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.black54,
                            ),
                            children: [
                              TextSpan(
                                text: ' (If trade goes wrong)',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          loss.toStringAsFixed(2) +
                              ' / ' +
                              lossPercentage.toStringAsFixed(1) +
                              '%',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
