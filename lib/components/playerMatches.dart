import 'package:flutter/material.dart';

class PlayerMatches extends StatelessWidget {
  PlayerMatches({
    @required this.isFetching,
    @required this.playerName,
    @required this.generatedMatchList,
  });

  final bool isFetching;
  final String playerName;
  final List<FlatButton> generatedMatchList;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          height: 20.0,
        ),
        Text(
          '${isFetching ? '' : 'Played matches by $playerName'}',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Flexible(
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.all(10.0),
            children: isFetching ? [] : generatedMatchList,
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 10.0, bottom: 20.0),
              child: Text(
                '${isFetching ? '' : '*tap on a match to see more detail...'}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
