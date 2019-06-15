import 'package:flutter/material.dart';
import 'package:pubg/screens/matchDetails_screen.dart';
import 'package:pubg/services/player.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:pubg/components/playerMatches.dart';

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
  bool _anyMatch = false;

  void getMatches() async {
    List<dynamic> playerMatches =
        await widget.player.getPlayerMatches(playerObject: widget.playerObject);

    if (playerMatches.isNotEmpty) {
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
        _anyMatch = true;
        _isFetching = false;
      });
    } else {
      setState(() {
        _anyMatch = false;
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
              child: _anyMatch
                  ? PlayerMatches(
                      isFetching: _isFetching,
                      playerName: _playerName,
                      generatedMatchList: _generatedMatchList)
                  : Center(
                      child: Padding(
                        padding: EdgeInsets.only(right: 10.0, left: 10.0),
                        child: Text(
                          '${_isFetching ? '' : 'There is no any played matches in 14 days for this player...'}',
                          style: TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )),
        ),
      ),
    );
  }
}
