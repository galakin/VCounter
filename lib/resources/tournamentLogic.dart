/*TODO: add the possibility that the game's end with even score 0 - 0, 2 - 2, ...]
 *TODO: add the possibility to recalculate the games point by modifing the games result
 *TODO: add a byeRound list for history purpuse
 */
import 'dart:math';

class GameResult {
  String playerA, playerB;
  String winner;
  int playerAWingGame, playerBWingGame;

  GameResult(this.playerA, this.playerB, this.winner, this.playerAWingGame, this.playerBWingGame);

  @override String toString() => "winner: $winner\tplayer 1: $playerA\tplayer 2: $playerB";
}

class GameScore{
  int playerAScore, playerBScore;
}

class TournamentLogic{
  int currentRound = 1;
  int playersNum=2;
  int round=3;
  String byeRound;
  List playersNames;
  Map <String, int> playersPoints;
  Map tournamentResult; //the result of every game played during the turnament
  List seating;
  List playerPairing;
  List gameResult;
  List byeHistory;
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
    byeHistory = new List<String>();
    if ( byeRound != null ) byeHistory.add(byeRound);
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
    GameResult _oldRes ,_tmpres = new GameResult(playerA, playerB, winner, games1, games2);
    int tmpIndex = tournamentResult[round].indexWhere((game) => game.playerA == playerA && game.playerB == playerB);
    if ( tmpIndex == -1) tournamentResult[round].add(_tmpres);
    else {
      _oldRes = tournamentResult[round].removeAt(tmpIndex);
      tournamentResult[round].add(_tmpres);
    }
    _updateScores(_oldRes, _tmpres);
    parent.refresh();

  }

  /** Update the game's score based on the registered games results
   *  TODO: write body once the score are implemented
   */
  void _updateScores(GameResult _oldRes, GameResult _newRes){
    if (_oldRes != null){
      if (_oldRes.winner != 'draw') playersPoints[_oldRes.winner] -= 3;
      else{
        playersPoints[_newRes.playerA] -= 1;
        playersPoints[_newRes.playerB] -= 1;
      }
    }
    if (_newRes.winner != "draw") playersPoints[_newRes.winner] += 3;
    else{
      playersPoints[_newRes.playerA] += 1;
      playersPoints[_newRes.playerB] += 1;
    }
  }

  /** Check if every round is comleated, if so true is retourned, otherwise false
   *  is returned
   *  round: the current round, used to verify if every games are terminated
   */
  bool checkRoundComplete(){
    int _tmpPlayerNo = playersNum%2==0 ? playersNum : playersNum -1;
    if (tournamentResult[currentRound] != null && tournamentResult[currentRound].length == (_tmpPlayerNo/2)) return true;
    return false;
  }

  /** if all games of current round are ended a new round is initialized with
   *  pairing calculated from previous round.
   */
  void nextRound(){
    if (checkRoundComplete()){
      if (byeRound != null) playersPoints[byeRound] += 3;
      List _pointList =  playersPoints.entries.map((e) => {'name': e.key, 'points': e.value}).toList();
      _pointList.sort((a, b){
        if (a['points'] < b['points']) return 1;
        else return 0;
      });
      this.seating = _adjustSeating(_pointList);
      this.currentRound++;
      print(_pointList[_pointList.length-1]);
      byeRound=_pointList[_pointList.length-1]['name'];
      byeHistory.add(byeRound);
    } else print("end all games");
  }

  /** Adjust seating order by checking if two players have already play together
   *  if so, the player with the higher ranking is paired with the nearest (points
   *  wise) player available that has not already play against him/her
   */
  List _adjustSeating(List _pointList){
    /*BUG seating position are not correct*/
    List _tmpSeating = new List();
    int _length = playersNames.length;
    if (playersNames.length % 2 == 1) {                                         //find a bye player if necessary
      this.byeRound = playersNames[playersNames.length -1];
      _length--;
    }
    for (int i = 0; i < _length; i+=2 ){
      _tmpSeating.add([_pointList[i]['name'], _pointList[i+1]['name']]);
    }
    //verify if two player have already play toghether;
    for (int i  = 0; i < _tmpSeating.length; i++){
      //verify if i vs j is already appened
      if (_alreadyPlay(_tmpSeating[i])) ;
    }
    return _tmpSeating;
  }

  /** check if player A and player B already played together in this tournament
   *  by checking all previously games where player A or player B played
   */
  bool _alreadyPlay(List _playerList){
    bool _alreadyPlay = false;
    for (int i = 0; (i < currentRound) && ! _alreadyPlay; i++){
      var _oldGames = tournamentResult[i];
      if (_oldGames != null) {
        for (int i = 0; i < _oldGames.length; i++){
          if (_playerList.contains(_oldGames[i].playerA) && _playerList.contains(_oldGames[i].playerB)) _alreadyPlay=true;
        }
      }
    }

    print(_alreadyPlay);
    return _alreadyPlay;
  }
}
