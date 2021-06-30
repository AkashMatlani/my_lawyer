class StateModel {
  final int id;
  final String name;

  StateModel(this.id, this.name);

  Map<String, dynamic> toMap() {
    return {
      'stateId': id,
      'name': name,
    };
  }


  // StateModel.fromMapObject(Map<String, dynamic> map) {
  //
  //   this.id = map['id'];
  //   this.name = map['title'];
  // }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'State{id: $id, name: $name}';
  }
}
