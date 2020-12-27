/*TODO: add the possibility that the game's end with even score 0 - 0, 2 - 2, ...]
 *TODO: add the possibility to recalculate the games point by modifing the games result
 */
import 'dart:math';

class GameResult {
  String playerA, playerB;
  String winner;
  int playerAWingGame, playerBWingGame;

  GameResult(this.playerA, this.playerB, this.winner, this.playerAWingGame, this.playerBWingGame);

  bool samePlayer(String playerA, String playerB){
    if ((this.playerA == playerA || this.playerB == playerA) && (this.playerA == playerB || this.playerB == playerB)) return true;
    return false;
  }
  @override String toString() => "winner: $winner\tplayer 1: $playerA\tplayer 2: $playerB";

}

class GameScore{
  int playerAScore, playerBScore;
}

class TournamentLogic{
  int currentRound = 1;
  int playersNum=2;
  int round=3, maxRound;
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

    maxRound=_calculateMaxRound();
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
    if (currentRound < maxRound){
      if (checkRoundComplete()){
        if (byeRound != null) playersPoints[byeRound] += 3;
        List _pointList =  playersPoints.entries.map((e) => {'name': e.key, 'points': e.value}).toList();
        _pointList.sort((a, b){
          if (a['points'] < b['points']) return 1;
          else return 0;
        });
        this.seating = _adjustSeating(_pointList);
        this.currentRound++;
        if (playersNames.length % 2 == 1){
          byeRound=_pointList[_pointList.length-1]['name'];
          byeHistory.add(byeRound);
        }
      } else print("end all games");
    } else print("max no of round reached!");
  }

  /** Adjust seating order by checking if two players have already play together
   *  if so, the player with the higher ranking is paired with the nearest (points
   *  wise) player available that has not already play against him/her
   */
  List _adjustSeating(List _pointList){
    /*BUG seating position are not correct*/
    List _tmpSeating = new List();
    List _alreadyAssigned = new List<String>();
    int _length = playersNames.length;
    if (playersNames.length % 2 == 1) {                                                                                   //find a bye player if necessary
      this.byeRound = playersNames[playersNames.length -1];
      _length--;
    }
    print("Start calculating pairing...");
    print("length: $_length");
    for (int i = 0; i < _length; i++ ){
      bool _alreadyp = false;
      for (int j = 0; j < _length && !_alreadyp; j++){
        if (i != j ){
          if (!_alreadyAssigned.contains(_pointList[i]['name']) && !_alreadyAssigned.contains(_pointList[j]['name'])){    //check if i and j are already benn matched with someone
            if (_alreadyPlay([_pointList[i]['name'], _pointList[j]['name']])){                                            //verify if two player have already play toghether;
              _alreadyp=true;
              print("${_pointList[i]['name']}\t and ${_pointList[j]['name']} already played together!");
            } else {
              _alreadyAssigned.add(_pointList[i]['name']); _alreadyAssigned.add(_pointList[j]['name']);
              _tmpSeating.add([_pointList[i]['name'], _pointList[j]['name']]);
              _alreadyp = true;
              _alreadyAssigned.add(_pointList[i]['name']); _alreadyAssigned.add(_pointList[j]['name']);
            }
            print("$i vs $j");
          } else print("${_pointList[i]['name']} or ${_pointList[j]['name']} already match with someone");
        }
      }
    }
    print("... End calculating pairing");
    return _tmpSeating;
  }

  /** check if player A and player B already played together in this tournament
   *  by checking all previously games where player A or player B played
   */
  bool _alreadyPlay(List _playerList){
    bool _alreadyP=false;
    if (playersNum > 2 ){                                                                                                 //if we have only two player this method is useless
      for (int i = 1; (i <= currentRound) && !_alreadyP; i++){                                                            //round always start at 1
        var _oldGames = tournamentResult[i];
        for (int i = 0; _oldGames != null && i < _oldGames.length && !_alreadyP; i++){
          if (_playerList.contains(_oldGames[i].playerA) && _playerList.contains(_oldGames[i].playerB)) {
            _alreadyP=true;
          }
        }
      }
      return _alreadyP;
    }
  }

  /** Calculate the max no of round based on the no' of player, the round no
   *  are taken from the official Channel Fireball website
   *  https://strategy.channelfireball.com/all-strategy/mtg/channelmagic-articles/understanding-standings-part-i-tournament-structure-the-basics/
   */
  int _calculateMaxRound(){
    if (playersNum < 4) return 1;
    else if (playersNum > 3 && playersNum < 5) return 2;
    else if (playersNum >= 5 && playersNum  <= 8) return 3;
    else if (playersNum >= 9 && playersNum <= 16) return 4;
    else if (playersNum >= 17 && playersNum <= 32) return 5;
    else if (playersNum >= 33 && playersNum <= 64) return 6;
  }


  /** Generate the standing list, both partial and final standing based on the
   *  player points and previous game
   */
  generateStanding(bool _final){
    List _pointList =  playersPoints.entries.map((e) => {'name': e.key, 'points': e.value}).toList();
    _pointList.sort((a, b){
      if (a['points'] < b['points']) return 1;
      else return 0;
    });
    List _alreadyChecked = [];
    for (int i = 0; i < _pointList.length; i++){
      if (!_alreadyChecked.contains(_pointList[i]['name'])){                                                              //enter only if the player isn't checked yet
        _alreadyChecked.add(_pointList[i]['name']);
        List _samePointPlayer=[_pointList[i]['name']];

        for (int j = i+1; j < _pointList.length; j++){
          if (_pointList[j]['points'] == _pointList[i]['points']) {
            _alreadyChecked.add(_pointList[j]['name']);
            _samePointPlayer.add(_pointList[j]['name']);
          }
        }

        if (_samePointPlayer.length > 1) {                                                                                //if list have more than one elem order the sublit
          List _orderedSublist=[];
          _orderedSublist=_checkOrder(_samePointPlayer);                                                                  //check if the order is correct
          /*TODO swap sublist with list fragment*/
        }
        print("Some player point: $_samePointPlayer");
      }
    }
    return playersPoints;
  }

  /** check if player in the sublist are ordered, if not order the sublist in the
   *  correct way,
   *  _sublist: the sublist that need to be checked
   *  return the sublist correctly ordered if some player are misplaced, otherwise
   *    the empty list is returned
   */
  List _checkOrder(List _sublist) {
    for (int i = 0; i < _sublist.length; i++){
      for (int j = i+1; j < _sublist.length; j++){
        if (_lee(_sublist[i], _sublist[j])){
          String tmp=_sublist[i];
          _sublist[i]=_sublist[j];
          _sublist[j]=tmp;
        }
        /*NOTE check least greater common antagonist*/
      }
    }
    return _sublist;
  }

  /** least equal enemy, used to found the nearest, round wise, enemy that two
   *  player have batteled with, used to define the final/partial ranking of a
   *  tournament
   *  _playerA:
   *  _playerB:
   *  return true if player A have is higher in the ranking than player B, false
   *  otherwise
   */
  bool _lee(String _playerA, String _playerB){
    bool _find=false;
    int _tmpRound = round;
    while (_tmpRound > 0 && !_find){
      for (int i=0; i < tournamentResult[_tmpRound].length; i++){
        if (tournamentResult[_tmpRound][i].samePlayer(_playerA, _playerB)){
          _find=true;
          if (tournamentResult[_tmpRound][i].winner == _playerB) return true;
        }
      }
      print(tournamentResult[_tmpRound]);
      _tmpRound--;
    }
    return false;
  }
}
