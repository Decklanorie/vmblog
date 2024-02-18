import 'package:bloc/bloc.dart';
import 'package:vmblog/src/shared/application/post_usecases/create_post_usecase.dart';
import 'package:vmblog/src/shared/domain/entities/post.dart';

// Create Events
abstract class CreateEvent {}

class Create extends CreateEvent {
  Post post;
  Create(this.post);
}


// Create States
abstract class CreateState {}

class Defaults extends CreateState {}
class Loading extends CreateState {}
class DoneCreating extends CreateState {
  Post post;
  DoneCreating(this.post);
}
class CreateError extends CreateState {
  String error;
  CreateError(this.error);
}




// BLoC class
class CreateBloc extends Bloc<CreateEvent, CreateState> {
  final CreatePost createPost;

  CreateBloc(this.createPost) : super(Defaults()){
    on<Create>((event, emit) async{
      emit(Loading());
      try {
       await createPost(event.post);
        emit(DoneCreating(event.post));
      } catch (e) {
        print(e);
        emit(CreateError('Failed to create post, try again later'));
      }
    });

  }

  // @override
  // Stream<CreateState> mapEventToState(
  //     CreateEvent event,
  //     ) async* {
  //   if (event is Create) {
  //     yield Loading();
  //     try {
  //       await createPost(event.post);
  //       yield DoneCreating(event.post);
  //     } catch (e) {
  //       print(e);
  //       yield CreateError('Failed to create post, try again later');
  //     }
  //   }
  // }
}