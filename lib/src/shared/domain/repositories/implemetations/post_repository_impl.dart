import 'package:flutter/cupertino.dart';
import 'package:vmblog/core/config/motion_toast.dart';
import 'package:vmblog/src/shared/domain/entities/post.dart';
import 'package:vmblog/src/shared/domain/repositories/post_repository.dart';
import 'package:vmblog/src/shared/data/post.dart';

class PostRepositoryImpl implements PostRepository {
  final HomeRemoteDataSource remoteDataSource;
  BuildContext context;

  PostRepositoryImpl({required this.remoteDataSource, required this.context});

  @override
  Future<List<Post>> getPosts() async {
    try {
      return await remoteDataSource.getPosts();
    } catch (e) {
      MToast().error(context, 'Cannot Connect, are you offline?');
      throw Exception('Failed to fetch posts: $e');
    }
  }

  @override
  Future<Post> getPostById(String postId) async {
    try {
      return await remoteDataSource.getPostById(postId);
    } catch (e) {
      MToast().error(context, 'Cannot Connect, are you offline?');
      throw Exception('Failed to fetch post by ID: $e');
    }
  }

  @override
  Future<Post> createPost(Post post) async {
    try {
      return await remoteDataSource.createPost(post);
    } catch (e) {
      MToast().error(context, 'Cannot Connect, are you offline?');
      throw Exception('Failed to create post: $e');
    }
  }

  @override
  Future<Post> updatePost(Post updatedPost) async {
    try {
      return await remoteDataSource.updatePost(updatedPost);
    } catch (e) {
      MToast().error(context, 'Cannot Connect, are you offline?');
      throw Exception('Failed to update post: $e');
    }
  }

  @override
  Future<bool> deletePost(String postId) async {
    try {
      return await remoteDataSource.deletePost(postId);
    } catch (e) {
      MToast().error(context, 'Cannot Connect, are you offline?');
      throw Exception('Failed to delete post: $e');
    }
  }
}
