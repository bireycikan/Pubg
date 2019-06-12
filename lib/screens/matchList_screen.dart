import 'package:flutter/material.dart';
import 'package:pubg/screens/matchDetails_screen.dart';
import 'package:pubg/services/player.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class MatchListScreen extends StatefulWidget {
  MatchListScreen({@required this.player, @required this.playerObject});
  final Player player;
  final dynamic playerObject;

  @override
  _MatchListScreenState createState() => _MatchListScreenState();
}

class _MatchListScreenState extends State<MatchListScreen> {
  bool _isFetching = false;
  List<FlatButton> _generatedMatchList = [];
  String _playerName;

  void getMatches() async {
    List<dynamic> playerMatches =
        await widget.player.getPlayerMatches(playerObject: widget.playerObject);

    if (playerMatches != null) {
      setState(() {
        for (var i = 0; i < playerMatches.length; i++) {
          _generatedMatchList.add(FlatButton(
            color: Color(0xFFffc5a1),
            child:
                Text('Last played match number: ${playerMatches.length - i}'),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MatchDetailsScreen(
                            player: widget.player,
                            matchId: '${playerMatches[i]['id']}',
                          )));
            },
          ));
        }
        _playerName = widget.player.getPlayerName;
        _isFetching = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _isFetching = true;
    getMatches();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Played Matches',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30.0,
          ),
        ),
        backgroundColor: Color(0xFFF2A900),
      ),
      body: SafeArea(
        child: ModalProgressHUD(
          inAsyncCall: _isFetching,
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  'Played matches by ${_isFetching ? '...' : _playerName}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    padding: EdgeInsets.all(10.0),
                    children: _isFetching ? [] : _generatedMatchList,
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 10.0, bottom: 20.0),
                      child: Text(
                        '*tap on a match to see more detail...',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
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
