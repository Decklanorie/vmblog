import 'package:bloc/bloc.dart';
import 'package:vmblog/src/features/home/presentation/bloc.dart';
import 'package:vmblog/src/shared/application/post_usecases/get_post_by_id_usecase.dart';
import 'package:vmblog/src/shared/application/post_usecases/get_post_usecase.dart';
import 'package:vmblog/src/shared/application/post_usecases/delete_post_usecase.dart';
import 'package:vmblog/src/shared/application/post_usecases/update_post_usecase.dart';
import 'package:vmblog/src/shared/application/post_usecases/create_post_usecase.dart';
import 'package:vmblog/src/shared/domain/entities/post.dart';

// Post Events
abstract class DeleteEvent {}

class Delete  extends DeleteEvent {
  final String postId;
  Delete(this.postId);
}



// Post States
abstract class DeleteState {}

class Defaults extends DeleteState {}
class Deleting extends DeleteState {}
class Deleted extends DeleteState {}
class DeleteError extends DeleteState {
  String error;
  DeleteError(this.error);
}




// BLoC class
class DeleteBloc extends Bloc<DeleteEvent, DeleteState> {
  final DeletePost deletePost;

  DeleteBloc(this.deletePost) : super(Defaults()){
    on<Delete>((event, emit) async{
      emit(Deleting());
      try {
        await deletePost(event.postId);
        emit(Deleted());
      } catch (e) {
        print(e);
        emit(DeleteError('Failed to delete post, try again later'));
      }
    });

  }

  @override
  Stream<DeleteState> mapEventToState(
      DeleteEvent event,
      ) async* {
    if (event is Delete) {
      yield Deleting();
      try {
        await deletePost(event.postId);
        yield Deleted();
      } catch (e) {
        print(e);
        yield DeleteError('Failed to delete post, try again later');
      }
    }
  }
}