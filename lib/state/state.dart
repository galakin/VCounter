class AppState{
  int counterValue = 0;

  AppState();

  AppState.fromAnother(AppState state){
    counterValue = state.counterValue;
  }

  int getCounterValue(){ return counterValue; }

  void incrementCounter(){ counterValue++; }

  void decrementCounter(){ counterValue--; }
}
