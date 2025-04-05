class MyUser {
  final String id;
  final String email;
  final String? name;
  final String? photoUrl;

  const MyUser({
    required this.id,
    required this.email,
    this.name,
    this.photoUrl,
  });

  static const empty = MyUser(id: '', email: '');

  bool get isEmpty => this == MyUser.empty;
  
  bool get isNotEmpty => this != MyUser.empty;

  MyUser copyWith({
    String? id,
    String? email,
    String? name,
    String? photoUrl,
  }) {
    return MyUser(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }
}