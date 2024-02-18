import 'package:vmblog/src/shared/domain/entities/post.dart';
import 'package:vmblog/src/shared/domain/repositories/post_repository.dart';

class UpdatePost {
  final PostRepository repository;

  UpdatePost(this.repository);

  Future<Post> call(Post post) async {
    return repository.updatePost(post);
  }
}