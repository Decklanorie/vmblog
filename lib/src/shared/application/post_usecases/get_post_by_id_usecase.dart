import 'package:vmblog/src/shared/domain/entities/post.dart';
import 'package:vmblog/src/shared/domain/repositories/post_repository.dart';

class GetPostById {
  final PostRepository repository;

  GetPostById(this.repository);

  Future<Post> call(String postId) async {
    return repository.getPostById(postId);
  }
}