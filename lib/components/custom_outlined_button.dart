import 'package:flutter/material.dart';
import 'package:stop_loss/config/size_config.dart';

class CustomOutlinedButton extends StatelessWidget {
  final Function onPressed;
  final String buttonLabel;

  const CustomOutlinedButton({Key key, this.onPressed, this.buttonLabel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      width: SizeConfig.safeBlockHorizontal * 100,
      height: SizeConfig.safeBlockVertical * 7,
      child: OutlinedButton(
        child: Text(buttonLabel),
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }
}
