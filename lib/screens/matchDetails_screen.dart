import 'package:flutter/material.dart';
import 'package:pubg/services/match.dart';
import 'package:pubg/services/player.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class MatchDetailsScreen extends StatefulWidget {
  MatchDetailsScreen({@required this.player, @required this.matchId});
  final Player player;
  final String matchId;

  @override
  _MatchDetailsScreenState createState() => _MatchDetailsScreenState();
}

class _MatchDetailsScreenState extends State<MatchDetailsScreen> {
  bool _isFetching = false;
  List<FlatButton> _participants = [];
  Map _participantDetails = {};
  String _playedDate;
  String _gameMode;
  int _duration;

  void getSingleMatchDetails() async {
    var matchObject =
        await widget.player.getSingleMatch(matchId: widget.matchId);

    if (matchObject != null) {
      var match = Match(playerMatchObject: matchObject);
      setState(() {
        //** MATCH PARTICIPANTS */
        var participants = match.getMatchParticipants();

        for (var participant in participants) {
          _participants.add(
            FlatButton(
              color: Color(0xFFffc5a1),
              child: Text('${participant['attributes']['stats']['name']}'),
              onPressed: () {
                // //** PARTICIPANT DETAILS */
                setState(() {
                  _participantDetails =
                      match.getParticipantDetails(participant: participant);
                });
              },
            ),
          );
        }
        _playedDate = match.playedDate;
        _gameMode = match.gameMode;
        _duration = (match.duration ~/ 60).toInt();
        _isFetching = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _isFetching = true;
    getSingleMatchDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Match Details',
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: Text(
                  'Basics',
                  style: TextStyle(fontSize: 30.0),
                ),
              ),
              Column(
                children: <Widget>[
                  MatchDetail(
                    isFetching: _isFetching,
                    detailName: 'Match Duration',
                    detailValue: _duration,
                    additionalText: 'Minutes',
                  ),
                  MatchDetail(
                    isFetching: _isFetching,
                    detailName: 'Game Mode',
                    detailValue: _gameMode,
                  ),
                  MatchDetail(
                    isFetching: _isFetching,
                    detailName: 'Played Date',
                    detailValue: _playedDate,
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: Text(
                  'Participants',
                  style: TextStyle(fontSize: 30.0),
                ),
              ),
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.all(10.0),
                  children: _isFetching ? [] : _participants,
                ),
              ),
              Text('*select a player to see more detail...'),
              Padding(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: Text(
                  'Selected Participant Details',
                  style: TextStyle(fontSize: 30.0),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 10.0),
                child: Column(
                  children: <Widget>[
                    ParticipantDetails(
                      detailName: 'Name',
                      value: _participantDetails['name'],
                    ),
                    ParticipantDetails(
                      detailName: 'Placement',
                      value: _participantDetails['winPlace'],
                    ),
                    ParticipantDetails(
                      detailName: 'Survival Time',
                      value: _participantDetails['timeSurvived'],
                      additionalText: 'Minutes',
                    ),
                    ParticipantDetails(
                      detailName: 'Total Kills',
                      value: _participantDetails['kills'],
                    ),
                    ParticipantDetails(
                      detailName: 'Death Type',
                      value: _participantDetails['deathType'],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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
