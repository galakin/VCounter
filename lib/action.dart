enum CounterAction {INCREMENT, DECREMENT}

class BaseAction{
  String toString() => "BaseAction";
}
class SaveGameID extends BaseAction{
  String id = null;

  SaveGameID(String id){
    this.id = id;
  }

  String toString() => "SaveGameID";
}

class ChangeNightMode extends BaseAction{
  String toString() => "ChangeNightMode";
}

class SetNightMode extends BaseAction{
  bool _baseValue;
  String toString() => "SetNightMode";

  SetNightMode(this._baseValue);

  bool getBaseValue() => _baseValue;
}
