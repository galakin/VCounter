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
