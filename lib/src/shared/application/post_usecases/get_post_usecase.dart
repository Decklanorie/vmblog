import 'package:vmblog/src/shared/domain/entities/post.dart';
import 'package:vmblog/src/shared/domain/repositories/post_repository.dart';

class GetPosts {
  final PostRepository repository;

  GetPosts(this.repository);

  Future<List<Post>> call() async {
    return repository.getPosts();
  }
}