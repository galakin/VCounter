import 'dart:math';

class TournamentLogic{
  int playersNum=2;
  int round=3;
  String byeRound;
  List playersNames;
  Map <String, int> playersPoints;
  List seating;
  List playerPairing;
  List gameResult;

  TournamentLogic(this.playersNum, this.round, this.playersNames){
    if (playersNames.length != playersNum) throw "Players num and subscribet tournament player mismatch";

    seating = new List<List>();
    playersNames = _shuffle(playersNames);
    int _length = playersNames.length;
    if (playersNames.length % 2 == 1) {
      byeRound = playersNames[playersNames.length -1];
      _length--;
    }
    for (int i = 0; i < _length; i+=2 ){
      seating.add([playersNames[i], playersNames[i+1]]);
    }

    playersPoints = new Map();
    for (int i = 0; i < playersNames.length; i++)playersPoints[playersNames[i]] = 0;

    gameResult = ['1 - 0', '2 - 0', '2 - 1'];
  }

  /** taken from https://stackoverflow.com/questions/13554129/list-shuffle-in-dart
   *  pseudo-randomly shuffle the player lisf for the seating couple purpuse,
   *  if the no of players is odd the last one ((2n) +1)th is the one with the bye
   */
  List _shuffle(List items) {
    var random = new Random();
    // Go through all elements.
    for (var i = items.length - 1; i > 0; i--) {
      // Pick a pseudorandom number according to the list length
      var n = random.nextInt(i + 1);
      var temp = items[i];
      items[i] = items[n];
      items[n] = temp;
    }
    return items;
  }

}
