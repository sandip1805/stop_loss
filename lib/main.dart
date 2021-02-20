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
  bool _shouldShowResult = false;
  bool _isQuantity = true;
  bool _isStopLossPercentage = true;
  bool _isTargetPercentage = true;
  double _entryPrice = 0;
  double _investedAmount = 0;
  double _stopLossPrice = 0;
  double _stopLossPercentage = 0;
  double _targetPrice = 0;
  double _targetPercentage = 0;
  double _quantity = 0;
  double _totalProfit = 0, _totalLoss = 0;
  final _formKey = GlobalKey<FormState>();
  var _qtyAmtData = [
    {'widget': Text('Qty'), 'isSelected': true},
    {'widget': Text('Amt'), 'isSelected': false}
  ];
  var _stopLossPercentageAmountData = [
    {'widget': Text('%'), 'isSelected': true},
    {'widget': Text('\$'), 'isSelected': false}
  ];
  var _targetPercentageAmountData = [
    {'widget': Text('%'), 'isSelected': true},
    {'widget': Text('\$'), 'isSelected': false}
  ];

  initializeToggleButtonData() {
    _qtyAmtData = [
      {'widget': Text('Qty'), 'isSelected': true},
      {'widget': Text('Amt'), 'isSelected': false}
    ];

    _stopLossPercentageAmountData = [
      {'widget': Text('%'), 'isSelected': true},
      {'widget': Text('\$'), 'isSelected': false}
    ];

    _targetPercentageAmountData = [
      {'widget': Text('%'), 'isSelected': true},
      {'widget': Text('\$'), 'isSelected': false}
    ];
  }

  reset() {
    setState(() {
      _formKey.currentState.reset();
      initializeToggleButtonData();
      _shouldShowResult = false;
      _isQuantity = true;
      _isStopLossPercentage = true;
      _isTargetPercentage = true;
      _entryPrice = 0;
      _investedAmount = 0;
      _stopLossPrice = 0;
      _stopLossPercentage = 0;
      _targetPrice = 0;
      _targetPercentage = 0;
      _quantity = 0;
      _totalProfit = 0;
      _totalLoss = 0;
    });
  }

  void calculate() {
    if (_formKey.currentState.validate()) {
      setState(() {
        _shouldShowResult = true;
        _targetPrice = _isTargetPercentage
            ? (_entryPrice + ((_targetPercentage / 100) * _entryPrice))
            : _targetPrice;
        print('targetPrice $_targetPrice');

        _targetPercentage = _isTargetPercentage
            ? _targetPercentage
            : calculatePercentage(_targetPrice, _entryPrice);
        print('targetPercentage $_targetPercentage');

        _stopLossPrice = _isStopLossPercentage
            ? (_entryPrice - ((_stopLossPercentage / 100) * _entryPrice))
            : _stopLossPrice;
        print('stopLossPrice $_stopLossPrice');

        _investedAmount =
            _isQuantity ? (_quantity * _entryPrice) : _investedAmount;
        print('investedAmount $_investedAmount');

        _quantity = _isQuantity ? _quantity : (_investedAmount / _entryPrice);
        print('quantity $_quantity');

        _totalProfit = (_targetPrice - _entryPrice) * _quantity;
        print('totalProfit $_totalProfit');

        _totalLoss = (_entryPrice - _stopLossPrice) * _quantity;
        print('totalLoss $_totalLoss');

        _stopLossPercentage = _isStopLossPercentage
            ? _stopLossPercentage
            : calculatePercentage(_entryPrice, _stopLossPrice);
        print('stopLossPercentage $_stopLossPercentage');
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
                              _entryPrice = double.parse(value);
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
                        CustomTextField(
                          onChanged: (value) {
                            setState(
                              () {
                                var parsedValue = double.parse(value);
                                if (_isQuantity) {
                                  _quantity = parsedValue.ceilToDouble();
                                } else {
                                  _investedAmount = parsedValue.ceilToDouble();
                                }
                              },
                            );
                          },
                          hintText: _isQuantity
                              ? 'Enter Stock Quantity'
                              : 'Enter Your Investment Amount',
                          labelText: _isQuantity ? 'Quantity' : 'Amount',
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter ' +
                                  (_isQuantity ? 'Quantity' : 'Amount');
                            }
                            return null;
                          },
                          suffix: CustomToggleButton(
                            data: _qtyAmtData,
                            onPressed: (index) {
                              setState(() {
                                _qtyAmtData.asMap().forEach((i, x) {
                                  if (i == index) {
                                    x['isSelected'] = true;
                                  } else {
                                    x['isSelected'] = false;
                                  }
                                });
                                _isQuantity = index == 0 ? true : false;
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          height: SizeConfig.safeBlockVertical * 2,
                        ),
                        CustomTextField(
                          onChanged: (value) {
                            setState(() {
                              if (_isStopLossPercentage) {
                                _stopLossPercentage = double.parse(value);
                              } else {
                                _stopLossPrice = double.parse(value);
                              }
                            });
                          },
                          hintText: _isStopLossPercentage
                              ? 'Enter StopLoss Percentage'
                              : 'Enter StopLoss Price',
                          labelText:
                              _isStopLossPercentage ? 'StopLoss %' : 'StopLoss',
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter StopLoss';
                            }
                            return null;
                          },
                          suffix: CustomToggleButton(
                            data: _stopLossPercentageAmountData,
                            onPressed: (index) {
                              setState(() {
                                _stopLossPercentageAmountData
                                    .asMap()
                                    .forEach((i, x) {
                                  if (i == index) {
                                    x['isSelected'] = true;
                                  } else {
                                    x['isSelected'] = false;
                                  }
                                });
                                _isStopLossPercentage =
                                    index == 0 ? true : false;
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          height: SizeConfig.safeBlockVertical * 2,
                        ),
                        CustomTextField(
                          onChanged: (value) {
                            setState(() {
                              var parsedValue = double.parse(value);
                              if (_isTargetPercentage) {
                                _targetPercentage = parsedValue;
                              } else {
                                _targetPrice = parsedValue;
                              }
                            });
                          },
                          hintText: _isTargetPercentage
                              ? 'Enter Target Percentage'
                              : 'Enter Target Price',
                          labelText:
                              _isTargetPercentage ? 'Target %' : 'Target',
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter target amount';
                            }
                            return null;
                          },
                          suffix: CustomToggleButton(
                            data: _targetPercentageAmountData,
                            onPressed: (index) {
                              setState(() {
                                _targetPercentageAmountData
                                    .asMap()
                                    .forEach((i, x) {
                                  if (i == index) {
                                    x['isSelected'] = true;
                                  } else {
                                    x['isSelected'] = false;
                                  }
                                });
                                _isTargetPercentage = index == 0 ? true : false;
                              });
                            },
                          ),
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
                          height: SizeConfig.safeBlockVertical * 1,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            _shouldShowResult
                ? Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ResultBox(
                      entryPrice: _entryPrice,
                      investedAmount: _investedAmount,
                      quantity: _quantity,
                      stopLossPercentage: _stopLossPercentage,
                      targetPercentage: _targetPercentage,
                      targetPrice: _targetPrice,
                      totalLoss: _totalLoss,
                      totalProfit: _totalProfit,
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
