class User {
  final String prenom;
  final String nom;
  final String email;
  final String password;

  User({
    required this.prenom,
    required this.nom,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'prenom': prenom,
      'nom': nom,
      'email': email,
      'password': password,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      prenom: json['prenom'] ?? '',
      nom: json['nom'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
    );
  }
}