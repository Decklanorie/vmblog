import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graphql/client.dart';
import 'package:vmblog/core/config/motion_toast.dart';
import 'package:vmblog/core/data/graphql_client.dart';
import 'package:vmblog/src/features/edit_post/presentation/bloc.dart';
import 'package:vmblog/src/features/view_post/presentation/post_screen.dart';
import 'package:vmblog/src/shared/application/post_usecases/update_post_usecase.dart';
import 'package:vmblog/src/shared/data/post.dart';
import 'package:vmblog/src/shared/domain/repositories/implemetations/post_repository_impl.dart';
import 'package:vmblog/src/shared/utils/colors.dart';
import 'package:vmblog/src/shared/domain/entities/post.dart';
import 'package:vmblog/src/shared/utils/date.dart';
import 'package:vmblog/src/shared/widgets/CustomBottomNavigation.dart';

class EditPostScreen extends StatefulWidget {
  final Post post;
  const EditPostScreen({required this.post,super.key});

  @override
  State<EditPostScreen> createState() => _EditPostScreenState();
}

class _EditPostScreenState extends State<EditPostScreen> {
  late TextEditingController _titleController;
  late TextEditingController _subtitleController;
  late TextEditingController _bodyController;
  late EditBloc editBloc;
  late GraphQLClient client;


  @override
  void initState() {
    client = GraphQLClientService().getClient();
    editBloc = EditBloc(UpdatePost(PostRepositoryImpl(remoteDataSource: HomeRemoteDataSource(graphQLClient: client, context: context), context: context)));
   
    _titleController = TextEditingController(text: widget.post.title);
    _subtitleController = TextEditingController(text: widget.post.subTitle);
    _bodyController = TextEditingController(text: widget.post.body);
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    _subtitleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var wh = MediaQuery.of(context).size.width;
    var hh = MediaQuery.of(context).size.height;
    return BlocProvider(create: (BuildContext context)=>editBloc,
        child: BlocBuilder<EditBloc, EditState>(
        builder: (context, state) {
          if(state is DoneEditing){
            Timer(Duration(seconds: 1), () {
              MToast().pop(context, 'Post Updated Successfully');
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => PostScreen(post: state.post,from: 'update',)),
              );
            });
          }
          return Scaffold(
      appBar: AppBar(
        backgroundColor: white,
        leading: BackButton(),
        centerTitle: true,
        title: Text('Edit Post', style: GoogleFonts.poppins(textStyle: TextStyle(fontWeight: FontWeight.w800, color: brown)),maxLines: 1,
          overflow: TextOverflow.ellipsis,),
      ),
      body: Container(
        width: wh,
        height: hh,
        padding: EdgeInsets.only(top: 5),
        child: Stack(
          children: [
            ListView(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 15,vertical: 15),
                  width:double.infinity,
                  child: Text('Title', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500,  color: grey)),
                ),
                Container(
                  padding: EdgeInsets.only(left: 15,right:15,bottom: 5),
                  child: Container(
                    padding: EdgeInsets.only(left: 8,right:8,),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: lightGrey
                    ),
                    child:CupertinoTextField(
                      controller: _titleController,
                      style: GoogleFonts.poppins(textStyle: TextStyle(color: black)),
                      placeholder: 'Enter title',
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                      ),
                      placeholderStyle: GoogleFonts.poppins(textStyle: TextStyle(color: grey)),
                    ),
                  ),
                ),
                SizedBox(height: 15,),

                Container(
                  margin: EdgeInsets.symmetric(horizontal: 15,vertical: 15),
                  width:double.infinity,
                  child: Text('Subtitle', style: GoogleFonts.poppins(
                      textStyle:TextStyle(fontSize: 15, fontWeight: FontWeight.w500,  color: grey))
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 15,right:15,bottom: 5),
                  child: Container(
                    padding: EdgeInsets.only(left: 8,right:8,),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: lightGrey
                    ),
                    child:CupertinoTextField(
                      controller: _subtitleController,
                      style: GoogleFonts.poppins(textStyle: TextStyle(color: black)),
                      placeholder: 'Enter subtitle',
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                      ),
                      placeholderStyle: GoogleFonts.poppins(textStyle: TextStyle(color: grey)),
                    ),
                  ),
                ),
                SizedBox(height: 15,),



                Container(
                  margin: EdgeInsets.symmetric(horizontal: 15,vertical: 15),
                  decoration: BoxDecoration(
                      color: white,
                      borderRadius: BorderRadius.circular(5)
                  ),
                  child: Text('Body', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500,  color: grey),),
                ),
                Container(
                  padding: EdgeInsets.only(left: 15,right:15,bottom: 5),
                  child: Container(
                    padding: EdgeInsets.only(left: 8,right:8,),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: lightGrey
                    ),
                    child:CupertinoTextField(
                      controller: _bodyController,
                      style: GoogleFonts.poppins(textStyle: TextStyle(color: black)),
                      placeholder: 'Enter body',
                      minLines: 5,
                      maxLines: 6,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                      ),
                      placeholderStyle: GoogleFonts.poppins(textStyle: TextStyle(color: grey)),
                    ),
                  ),
                ),
                SizedBox(height: 15,),

              ],
            ),
            if(state is Loading)Container(
                width: wh,
                height: hh,
                color: Colors.black.withOpacity(.4),
                padding: EdgeInsets.only(top: 5),
                child: Center(
                  child: Container(
                    height: 300,
                    width: 200,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 10),
                          width: 50,
                          height: 30,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(300),
                              color: yellow.withOpacity(.2)
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                  width: 15,height: 15,
                                  child: LinearProgressIndicator()
                              )

                            ],
                          ),
                        ),
                        SizedBox(height: 15,),
                        Center(
                          child: Text('Saving edit...',textAlign: TextAlign.center,),
                        ),
                        SizedBox(height: 150,),
                      ],
                    ),
                  ),
                )
            ),
          ],
        )
      ),
      bottomNavigationBar:state is Loading?null:FloatingActionButton(onPressed: ()async{
        try{
          final response = await http.get(Uri.parse('https://google.com'));
        if(_titleController.text.trim().isEmpty){
          MToast().error(context, 'Title can not be empty');
          return;
        }
        if(_subtitleController.text.trim().isEmpty){
          MToast().error(context, 'Subtitle can not be empty');
          return;
        }
        if(_bodyController.text.trim().isEmpty){
          MToast().error(context, 'Body can not be empty');
          return;
        }
        var newPost = Post.fromMap({
          'title':_titleController.text,
          'subTitle':_subtitleController.text,
          'body':_bodyController.text,
          'id': widget.post.id.toString()
        });
        
        editBloc.add(EditPost(newPost));


          }catch(e){
          MToast().error(context, 'You are offline');
          }
      }, child: Text('Save'),),
    );
          }
        )
    );
  }
}
