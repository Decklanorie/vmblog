import 'package:vmblog/src/shared/domain/entities/post.dart';

abstract class PostRepository {
  Future<List<Post>> getPosts();
  Future<Post> getPostById(String postId);
  Future<Post> createPost(Post updatedPost);
  Future<Post> updatePost(Post updatedPost);
  Future<bool> deletePost(String postId);
}
