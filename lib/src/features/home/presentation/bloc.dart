import 'package:bloc/bloc.dart';
import 'package:vmblog/src/shared/application/post_usecases/get_post_by_id_usecase.dart';
import 'package:vmblog/src/shared/application/post_usecases/get_post_usecase.dart';
import 'package:vmblog/src/shared/application/post_usecases/delete_post_usecase.dart';
import 'package:vmblog/src/shared/application/post_usecases/update_post_usecase.dart';
import 'package:vmblog/src/shared/application/post_usecases/create_post_usecase.dart';
import 'package:vmblog/src/shared/domain/entities/post.dart';

// Home Events
abstract class HomeEvent {}

class FetchPosts extends HomeEvent {}

class FilterPost extends HomeEvent {
  final String query;
  FilterPost(this.query);
}

class ChangeCategory extends HomeEvent {
  final String category;
  ChangeCategory(this.category);
}


// Home States
abstract class HomeState {}

class Defaults extends HomeState {}
class PostLoading extends HomeState {}
class PostLoaded extends HomeState {
  List<Post> posts;
  PostLoaded(this.posts);
}
class HomeError extends HomeState {
  String error;
  HomeError(this.error);
}




// BLoC class
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetPosts getPosts;

  HomeBloc(this.getPosts) : super(Defaults()){
    on<FetchPosts>((event, emit) async{
      emit(PostLoading());
      try {
        final posts = await getPosts();
        await Future.delayed(Duration(milliseconds: 1000));
        emit(PostLoaded(posts));
      } catch (e) {
        print(e);
        emit(HomeError('Failed to fetch posts, try again later'));
      }
    });

    on<FilterPost>((event, emit) async{
      emit(PostLoading());
      try {
      final posts = (await getPosts()).where((element) => element.title.toLowerCase().contains(event.query.toLowerCase()) || element.subTitle.toLowerCase().contains(event.query.toLowerCase())).toList();
        emit(PostLoaded(posts));
      } catch (e) {
        print(e);
        emit(PostLoaded([]));
      }
    });

  }

  // @override
  // Stream<HomeState> mapEventToState(
  //     HomeEvent event,
  //     ) async* {
  //   if (event is FetchPosts) {
  //     yield PostLoading();
  //     try {
  //       final posts = await getPosts();
  //       yield PostLoaded(posts);
  //     } catch (e) {
  //       print(e);
  //       yield HomeError('Failed to fetch posts, try again later');
  //     }
  //   }
  //   else if (event is FilterPost) {
  //     yield PostLoading();
  //     try {
  //       final posts = (await getPosts()).where((element) => element.title.contains(event.query)) as List<Post>;
  //       yield PostLoaded(posts);
  //     } catch (e) {
  //       print(e);
  //       yield PostLoaded([]);
  //     }
  //   }
  // }
}