import 'dart:math';

class GameResult {
  String playerA, playerB;
  String winner;
  int playerAWingGame, playerBWingGame;

  GameResult(this.playerA, this.playerB, this.winner, this.playerAWingGame, this.playerBWingGame);

  @override String toString() => winner;
}

class GameScore{
  int playerAScore, playerBScore;
}

class TournamentLogic{
  int playersNum=2;
  int currentRount = 1;
  int round=3;
  String byeRound;
  List playersNames;
  Map <String, int> playersPoints;
  Map tournamentResult; //the result of every game played during the turnament
  List seating;
  List playerPairing;
  List gameResult;
  var parent;

  TournamentLogic(this.parent, this.playersNum, this.round, this.playersNames){
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
    tournamentResult = new Map<int,List<GameResult>>();
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

  /**
   *
   */
  void addGameResult(int round, String playerA, String playerB, String winner, int games1, int games2){
    if (tournamentResult[round] == null) tournamentResult[round] = new List<GameResult>();
    GameResult tmpres = new GameResult(playerA, playerB, winner, games1, games2);
    int tmpIndex = tournamentResult[round].indexWhere((game) => game.playerA == playerA && game.playerB == playerB);
    print('\winner is: $winner\n\n');
    print(tournamentResult);
    if ( tmpIndex == -1) tournamentResult[round].add(tmpres);
    else {
      tournamentResult[round].removeAt(tmpIndex);
      tournamentResult[round].add(tmpres);
    }
    _updateScores();
    parent.refresh();
  }

  /** Update the game's score based on the registered games results
   *  TODO: write body once the score are implemented
   */
  void _updateScores(){
  }
}
