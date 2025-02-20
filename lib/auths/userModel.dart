class User {
  int? id;
  String? name;
  String? email;
  String? phone;
  String? address;
  String? age;
  String? role;

  User({this.id, this.name, this.email, this.phone, this.address, this.age, this.role});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'age': age,
      'role': role
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  User.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    email = map['email'];
    phone = map['phone'];
    address = map['address'];
    age = map['age'];
    role = map['role'];
  }
}