import 'package:flutter/material.dart';

class ParticipantDetails extends StatelessWidget {
  ParticipantDetails(
      {@required this.detailName,
      @required this.value,
      this.additionalText = ''});
  final String detailName;
  final dynamic value;
  final String additionalText;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text('$detailName: ', style: TextStyle(fontSize: 15.0)),
        Text('${value ?? '...'} $additionalText',
            style: TextStyle(fontSize: 15.0)),
      ],
    );
  }
}
