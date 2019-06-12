import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';

class Match {
  Match({@required this.playerMatchObject});
  final dynamic playerMatchObject;

  String get playedDate {
    var date = DateTime.tryParse(
        this.playerMatchObject['data']['attributes']['createdAt']);

    if (date != null) {
      var localFormat = date.toLocal();
      return formatDate(
          localFormat, [dd, '/', mm, '/', yyyy, ' - ', HH, ':', nn]);
    }

    return 'Date object returned null!';
  }

  String get gameMode => playerMatchObject['data']['attributes']['gameMode'];
  int get duration => playerMatchObject['data']['attributes']['duration'];

  List<dynamic> getMatchParticipants() {
    var matchParticipants = [];
    var includes = playerMatchObject['included'];
    for (var include in includes) {
      if (include['type'] == 'participant') {
        matchParticipants.add(include);
      }
    }

    return matchParticipants;
  }

  Map<String, dynamic> getParticipantDetails({@required dynamic participant}) {
    return {
      'name': participant['attributes']['stats']['name'],
      'winPlace': participant['attributes']['stats']['winPlace'],
      'timeSurvived':
          (participant['attributes']['stats']['timeSurvived'] ~/ 60).toInt(),
      'kills': participant['attributes']['stats']['kills'],
      'deathType': participant['attributes']['stats']['deathType']
    };
  }
}
