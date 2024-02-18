import 'package:bloc/bloc.dart';
import 'package:vmblog/core/config/motion_toast.dart';
import 'package:vmblog/src/shared/application/post_usecases/update_post_usecase.dart';
import 'package:vmblog/src/shared/domain/entities/post.dart';

// Edit Events
abstract class EditEvent {}

class EditPost extends EditEvent {
  Post post;
  EditPost(this.post);
}


// Edit States
abstract class EditState {}

class Defaults extends EditState {}
class Loading extends EditState {}
class DoneEditing extends EditState {
  Post post;
  DoneEditing(this.post);
}
class EditError extends EditState {
  String error;
  EditError(this.error);
}




// BLoC class
class EditBloc extends Bloc<EditEvent, EditState> {
  final UpdatePost updatePost;

  EditBloc(this.updatePost) : super(Defaults()){
    on<EditPost>((event, emit) async{
      emit(Loading());
      try {
        await updatePost(event.post);
        emit(DoneEditing(event.post));
      } catch (e) {
        print(e);
        emit(EditError('Failed to edit post, try again later'));
      }
    });

  }

  // @override
  // Stream<EditState> mapEventToState(
  //     EditEvent event,
  //     ) async* {
  //   if (event is EditPost) {
  //     yield Loading();
  //     try {
  //       await updatePost(event.post);
  //       yield DoneEditing(event.post);
  //     } catch (e) {
  //       print(e);
  //       yield EditError('Failed to edit post, try again later');
  //     }
  //   }
  // }
}