class UserModel {
  final String name;
  final double height;
  final String email;
  final List<String> weight;

  UserModel({this.name, this.email, this.height, this.weight});

  factory UserModel.fromMap(Map data) {
    return UserModel(
        height: double.parse(data['height']),
        name: data['name'],
        email: data['email'],
        weight: data['weight']);
  }
}
