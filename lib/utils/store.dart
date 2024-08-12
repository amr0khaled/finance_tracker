typedef StoreType = Map<String, dynamic>;
typedef StateType = StoreType;

class Store {
  Map<String, Function> _store = {};
  String name = '';
  Store(String name, value) {
    _store[name] = () => value;
  }
  void remove(String name) {
    var oldStore = _store;
    oldStore.removeWhere((item, v) => item == name);
    _store = oldStore;
  }

  set(value) {
    _store[name] = () => value;
  }

  dynamic Function() get() {
    print(name);
    dynamic Function() state = _store[name] as Function();
    return state;
  }
}

// class StoreState {
//   final StateType _state = {};
//   String name;
//   dynamic value;
//   StoreState(this.name, this.value) {
//     _state[name] = value;
//   }
//   dynamic get() {
//     return _state[name];
//   }
// 
//   void set(dynamic newValue) {
//     _state[name] = newValue;
//   }
// }
