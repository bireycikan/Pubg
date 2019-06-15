import 'package:flutter/material.dart';
import 'package:pubg/services/player.dart';
import 'package:pubg/screens/matchList_screen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class SearchPlayerScreen extends StatefulWidget {
  @override
  _SearchPlayerScreenState createState() => _SearchPlayerScreenState();
}

class _SearchPlayerScreenState extends State<SearchPlayerScreen> {
  bool _isFetching = false;
  String _writtenName;
  String _errorMessage;

  void submit() async {
    if (_writtenName != null) {
      final player = Player(playerName: _writtenName);
      var singlePlayer = await player.getPlayer();

      if (singlePlayer != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MatchListScreen(
                  playerObject: singlePlayer,
                  player: player,
                ),
          ),
        );
      } else {
        _errorMessage = player.errorMessage;
      }
    } else {
      _errorMessage = "Player name cannot be empty!";
    }
    setState(() {
      _isFetching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'PUBG Player Search Engine',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25.0,
          ),
        ),
        backgroundColor: Color(0xFFF2A900),
      ),
      body: SafeArea(
        child: ModalProgressHUD(
          opacity: 0.5,
          inAsyncCall: _isFetching,
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 40.0,
                ),
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.only(left: 30.0, right: 30.0),
                    child: Text(
                      'Search Your Favourite Player...',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 30.0, right: 30.0, top: 10.0),
                  child: TextField(
                    cursorColor: Colors.black,
                    autocorrect: false,
                    keyboardType: TextInputType.text,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      errorText: _errorMessage,
                      hintText: 'Enter a player nickname...',
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(30.0)),
                      fillColor: Colors.amber,
                      filled: true,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    onChanged: (value) {
                      _writtenName = value;
                    },
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),
                Flexible(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(right: 30.0),
                        child: RaisedButton(
                          splashColor: Color(0xFFF2A900),
                          onPressed: () {
                            setState(() {
                              _isFetching = true;
                            });
                            submit();
                          },
                          child: Text(
                            'Search player...',
                            textAlign: TextAlign.center,
                          ),
                          elevation: 10.0,
                          highlightElevation: 5.0,
                          disabledElevation: 5.0,
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.all(40.0),
                    child: Text(
                      '*Only available for steam platform. Other platforms will be added!',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
