import 'package:vmblog/src/shared/domain/entities/post.dart';
import 'package:vmblog/src/shared/domain/repositories/post_repository.dart';

class CreatePost {
  final PostRepository repository;

  CreatePost(this.repository);

  Future<Post> call(Post post) async {
    return repository.createPost(post);
  }
}