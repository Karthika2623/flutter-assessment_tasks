class AppUser {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String company;

  const AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.company,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    final companyData = json['company'];
    final rawId = json['id'];
    final rawName = json['name'];
    final rawEmail = json['email'];
    final rawPhone = json['phone'];
    final rawCompanyName = companyData is Map ? companyData['name'] : null;

    return AppUser(
      id: rawId is int ? rawId : int.tryParse('$rawId') ?? 0,
      name: rawName is String && rawName.trim().isNotEmpty
          ? rawName.trim()
          : 'Unknown user',
      email: rawEmail is String && rawEmail.trim().isNotEmpty
          ? rawEmail.trim()
          : 'No email available',
      phone: rawPhone is String && rawPhone.trim().isNotEmpty
          ? rawPhone.trim()
          : 'No phone available',
      company: rawCompanyName is String && rawCompanyName.trim().isNotEmpty
          ? rawCompanyName.trim()
          : 'Unknown company',
    );
  }
}
