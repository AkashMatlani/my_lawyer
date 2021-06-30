class CountyModel {
  final int countyId;
  final String name;
  final int stateId;

  CountyModel(this.countyId, this.name, this.stateId);

  Map<String, dynamic> toMap() {
    return {
      'countyId': countyId,
      'name': name,
      'stateId': stateId,
    };
  }

  @override
  String toString() {
    return 'County{stateId: $stateId, countyId: $countyId, name:$name}';
  }
}
