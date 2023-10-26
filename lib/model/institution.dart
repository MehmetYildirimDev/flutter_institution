class Institution {
  final String code;
  final String title;
  final String link;
  final String tel;
  final String email;
  final String adres;

  Institution({
    required this.code,
    required this.title,
    required this.link,
    required this.tel,
    required this.email,
    required this.adres,
  });

  factory Institution.fromMap(Map<String, dynamic> map) {
    return Institution(
      code: map['code'] ?? '',
      title: map['title'] ?? '',
      link: map['link'] ?? '',
      tel: map['tel'] ?? '',
      email: map['email'] ?? '',
      adres: map['adres'] ?? '',
    );
  }
}
