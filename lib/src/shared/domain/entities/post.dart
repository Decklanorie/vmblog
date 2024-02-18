class Post {
  final String id;
  final String title;
  final String subTitle;
  final String body;
  final String dateCreated;

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      id: map['id']??'',
      title: map['title']??'',
      subTitle: map['subTitle']??'',
      body: map['body']??'',
      dateCreated: map['dateCreated']??'',
    );
  }

  Post({required this.id, required this.title, required this.subTitle, required this.body,
    required this.dateCreated});
}