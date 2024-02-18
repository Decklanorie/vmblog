import 'package:flutter/cupertino.dart';
import 'package:vmblog/core/config/motion_toast.dart';
import 'package:vmblog/src/shared/domain/entities/post.dart';
import 'package:graphql/client.dart';

class HomeRemoteDataSource {
  final GraphQLClient graphQLClient;
  BuildContext context;

  HomeRemoteDataSource({required this.graphQLClient, required this.context});

  Future<List<Post>> getPosts() async {
    final result = await graphQLClient.query(
        QueryOptions(
          document: gql('''
            query fetchAllBlogs {
              allBlogPosts {
                id
                title
                subTitle
                body
                dateCreated
              }
            }
          '''
          ),
        )
    );

        if (result.hasException) {
      print(result.exception.toString());
    }
    final List<Post> posts = (result.data!['allBlogPosts'] as List<dynamic>).map((postMap) => Post.fromMap(postMap)).toList();

    return posts;
  }

  Future<Post> getPostById(String blogId) async {
    final result = await graphQLClient.query(
        QueryOptions(
          document: gql('''
            query getBlog($blogId)  {
              blogPost(blogId: $blogId)  {
                id
                title
                subTitle
                body
                dateCreated
              }
            }
          '''
          ),
        )
    );

        if (result.hasException) {
      print(result.exception.toString());
      MToast().error(context, 'Can not get post, are you offline?');
    }

    final Post post = Post.fromMap(result.data??{});

    return post;
  }

  Future<Post> updatePost(Post updatedPost) async {
    final result = await graphQLClient.mutate(
        MutationOptions(
          document: gql('''
            mutation updateBlogPost(\$blogId: String!, \$title: String!, \$subTitle: String!, \$body: String!) {
            updateBlog(blogId: \$blogId, title: \$title, subTitle: \$subTitle, body: \$body) {
                success
                blogPost {
                  id
                  title
                  subTitle
                  body
                  dateCreated
                }
              }
            }
          '''
          ),
          variables: {
            'blogId': updatedPost.id,
            'title': updatedPost.title,
            'subTitle': updatedPost.subTitle,
            'body': updatedPost.body,
          },
        ),
    );
    if (result.hasException) {
      print(result.exception.toString());
    }

    final Post post = Post.fromMap(result.data??{});

    return post;
  }

  Future<Post> createPost(Post post) async {
    final result = await graphQLClient.mutate(
        MutationOptions(
          document: gql('''
            mutation createBlogPost(\$title: String!, \$subTitle: String!, \$body: String!) {
            createBlog(title: \$title, subTitle: \$subTitle, body: \$body) {
                success
                blogPost {
                  id
                  title
                  subTitle
                  body
                  dateCreated
                }
              }
            }
          '''
          ),
          variables: {
            'title': post.title,
            'subTitle': post.subTitle,
            'body': post.body,
          },
        )
    );
    if (result.hasException) {
      print(result.exception.toString());
    }

    final Post newPost = Post.fromMap(result.data??{});

    return newPost;
  }

  Future<bool> deletePost(String postId) async {
    final result = await graphQLClient.mutate(
        MutationOptions(
          document: gql('''
          mutation deleteBlogPost(\$blogId: String!) {
          deleteBlog(blogId: \$blogId) {
              success
            }
          }
        '''),
          variables: {
            'blogId': postId,
          },
        )
    );
    if (result.hasException) {
      print(result.exception.toString());
      MToast().error(context, 'Can not delete post, are you offline?');
      return false;
    }

    return true;
  }
}
