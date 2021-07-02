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

  @override
  String toString() {
    return 'State{id: $id, name: $name}';
  }
}
