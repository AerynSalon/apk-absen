class Employee {
  final int? id;
  final String code; // unique code used in QR
  final String name;
  final String role;

  Employee({this.id, required this.code, required this.name, required this.role});

  Employee copyWith({int? id, String? code, String? name, String? role}) => Employee(
    id: id ?? this.id,
    code: code ?? this.code,
    name: name ?? this.name,
    role: role ?? this.role,
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'code': code,
    'name': name,
    'role': role,
  };

  factory Employee.fromMap(Map<String, dynamic> m) => Employee(
    id: m['id'] as int?,
    code: m['code'] as String,
    name: m['name'] as String,
    role: m['role'] as String? ?? 'Staff',
  );
}
