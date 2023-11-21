
class Client {
  final String name;
  final String cpf;
  final String phone;
  final String email;
  final String password;
  final String photo;
  final String address;
  final DateTime createdAt;
  final DateTime updatedAt;
  List<String?>? token = [];

  Client({
    required this.name,
    required this.cpf,
    required this.phone,
    required this.email,
    required this.password,
    required this.photo,
    required this.address,
    required this.createdAt,
    required this.updatedAt,
    this.token
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'cpf': cpf,
      'phone': phone,
      'email': email,
      'password': password,
      'photo': photo,
      'address': address,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'token': token,
    };
  }

  Client.fromMap(Map<String, dynamic> map):
    name = map['name'],
    cpf = map['cpf'],
    phone = map['phone'],
    email = map['email'],
    password = map['password'],
    photo = map['photo'],
    address = map['address'],
    createdAt = map['createdAt'],
    updatedAt = map['updatedAt'],
    token = map['token'];
}