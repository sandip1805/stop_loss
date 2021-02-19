import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stop_loss/components/display_label.dart';
import 'package:stop_loss/config/size_config.dart';

class ResultBox extends StatelessWidget {
  final double entryPrice;
  final double targetPrice;
  final double investedAmount;
  final double quantity;
  final double totalProfit;
  final double targetPercentage;
  final double totalLoss;
  final double stopLossPercentage;

  const ResultBox(
      {Key key,
      this.entryPrice,
      this.targetPrice,
      this.investedAmount,
      this.quantity,
      this.totalProfit,
      this.targetPercentage,
      this.totalLoss,
      this.stopLossPercentage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          12.0,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Column(
              children: [
                DisplayLabel(
                  keyText: 'Entry',
                  valueText: entryPrice.toStringAsFixed(2),
                ),
                DisplayLabel(
                  keyText: 'Exit',
                  valueText: targetPrice.toStringAsFixed(2),
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
                      'Profit',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.green,
                      ),
                    ),
                    Text(
                      totalProfit.toStringAsFixed(2) +
                          ' / ' +
                          targetPercentage.toStringAsFixed(1) +
                          '%',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Risk',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.red,
                      ),
                    ),
                    Text(
                      totalLoss.toStringAsFixed(2) +
                          ' / ' +
                          stopLossPercentage.toStringAsFixed(1) +
                          '%',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.red[400],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
