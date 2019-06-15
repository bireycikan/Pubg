import 'package:flutter/material.dart';

class MatchDetail extends StatelessWidget {
  MatchDetail(
      {@required this.isFetching,
      @required this.detailName,
      @required this.detailValue,
      this.additionalText = ''});

  final bool isFetching;
  final String detailName;
  final dynamic detailValue;
  final String additionalText;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text('$detailName: ', style: TextStyle(fontSize: 15.0)),
        Text('${isFetching ? '?' : detailValue} $additionalText',
            style: TextStyle(fontSize: 15.0)),
      ],
    );
  }
}
