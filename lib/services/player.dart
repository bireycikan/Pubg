import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:pubg/utilities/constants.dart';
import 'dart:convert' show json;
import 'package:flutter/services.dart' show rootBundle;

class Player {
  Player({@required this.playerName});
  final String playerName;

  String _errorMessage;

  String get errorMessage => _errorMessage;
  String get getPlayerName => this.playerName;

  Future<dynamic> getPlayer() async {
    var secret = await SecretLoader(secretPath: 'secrets.json').load();

    if (secret != null) {
      var response = await http.get(
          '$endpointURL/steam/players?filter[playerNames]=$playerName',
          headers: {
            'Authorization': 'Bearer ${secret.apiKey}',
            'Accept': 'application/vnd.api+json'
          });

      if (response.statusCode == 200) {
        var playerObject = convert.jsonDecode(response.body);

        return playerObject;
      } else {
        var error = convert.jsonDecode(response.body);
        _errorMessage = error['errors'][0]['detail'];
      }
    } else {
      throw Error().stackTrace;
    }
  }

  //! To get matches information, you have to call first getPlayer method
  Future<dynamic> getPlayerMatches({@required dynamic playerObject}) async {
    var secret = await SecretLoader(secretPath: 'secrets.json').load();

    if (secret != null) {
      String playerId = playerObject['data'][0]['id'];
      var response = await http.get('$endpointURL/steam/players/$playerId',
          headers: {
            'Authorization': 'Bearer ${secret.apiKey}',
            'Accept': 'application/vnd.api+json'
          });

      if (response.statusCode == 200) {
        var singlePlayer = convert.jsonDecode(response.body);
        var matches = singlePlayer['data']['relationships']['matches']['data'];

        return matches;
      } else {
        print(response.statusCode);
        print('something failed!');
      }
    } else {
      throw Error().stackTrace;
    }
  }

  //! To get single match information, you have to call first getPlayerMatches method
  Future<dynamic> getSingleMatch({@required String matchId}) async {
    //** Authorization is not required for the /matches endpoint because it is not rate-limited. */
    var response = await http.get('$endpointURL/steam/matches/$matchId',
        headers: {'Accept': 'application/vnd.api+json'});

    if (response.statusCode == 200) {
      var matchObject = convert.jsonDecode(response.body);

      return matchObject;
    } else {
      print(response.statusCode);
      print('something failed!');
    }
  }
}

class Secret {
  Secret({this.apiKey});
  final String apiKey;

  factory Secret.fromJson(Map<String, dynamic> jsonMap) {
    return Secret(apiKey: jsonMap['api-key']);
  }
}

class SecretLoader {
  SecretLoader({this.secretPath});
  final String secretPath;

  Future<Secret> load() {
    return rootBundle.loadStructuredData<Secret>(this.secretPath,
        (jsonStr) async {
      final secret = Secret.fromJson(json.decode(jsonStr));
      return secret;
    });
  }
}
