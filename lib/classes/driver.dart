class Driver {
  final String name;
  final String cpf;
  String phone;
  final String email;
  final String password;
  String photo;
  final String cnh;
  String address;
  final DateTime createdAt;
  DateTime updatedAt;
  List<dynamic?>? token = [];

  Driver({
    required this.name,
    required this.cpf,
    required this.phone,
    required this.email,
    required this.password,
    required this.photo,
    required this.cnh,
    required this.address,
    required this.createdAt,
    required this.updatedAt,
    this.token,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'cpf': cpf,
      'phone': phone,
      'email': email,
      'password': password,
      'photo': photo,
      'cnh': cnh,
      'address': address,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'token': token,
    };
  }

  Driver.fromMap(Map<String, dynamic> map):
    name = map['name'],
    cpf = map['cpf'],
    phone = map['phone'],
    email = map['email'],
    password = map['password'],
    photo = map['photo'],
    cnh = map['cnh'],
    address = map['address'],
    createdAt = map['createdAt'].runtimeType == String ? DateTime.parse(map['createdAt']) : map['createdAt'],
    updatedAt = map['updatedAt'].runtimeType == String ? DateTime.parse(map['updatedAt']) : map['updatedAt'],
    token = map['token'];
}