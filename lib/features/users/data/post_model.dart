class UserPost {
  final int id;
  final String title;
  final String body;

  const UserPost({required this.id, required this.title, required this.body});

  factory UserPost.fromJson(Map<String, dynamic> json) => UserPost(
    id: json['id'] is int ? json['id'] as int : int.tryParse('${json['id']}') ?? 0,
    title: json['title'] as String? ?? 'Untitled post',
    body: json['body'] as String? ?? '',
  );
}
