class User {
  int? id;
  String name;
  String email;

  User({this.id, required this.name, required this.email});

  // แปลงจาก Map เป็น User object
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      email: map['email'],
    );
  }

  // แปลงจาก User object เป็น Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
    };
  }
}