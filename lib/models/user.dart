class User {
  User({
    this.id,
    this.name,
    this.email,
    this.rating,
    this.rate_length,
  });

  factory User.fromMap(Map<String, dynamic> data) {
    return User(
        id: data['id'],
        name: data['name'],
        email: data['email'],
        rating: data['rating'],
        rate_length: data['rate_length']);
  }

  final String id;
  final String name;
  final String email;
  final num rating;
  final num rate_length;
}
