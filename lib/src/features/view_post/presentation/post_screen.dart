import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graphql/client.dart';
import 'package:vmblog/core/config/motion_toast.dart';
import 'package:vmblog/core/data/graphql_client.dart';
import 'package:vmblog/src/features/edit_post/presentation/edit_screen.dart';
import 'package:vmblog/src/features/home/presentation/HomeScreen.dart';
import 'package:vmblog/src/features/view_post/presentation/bloc.dart';
import 'package:vmblog/src/shared/application/post_usecases/delete_post_usecase.dart';
import 'package:vmblog/src/shared/data/post.dart';
import 'package:vmblog/src/shared/domain/repositories/implemetations/post_repository_impl.dart';
import 'package:vmblog/src/shared/utils/colors.dart';
import 'package:vmblog/src/shared/domain/entities/post.dart';
import 'package:vmblog/src/shared/utils/date.dart';
import 'package:vmblog/src/shared/widgets/CustomBottomNavigation.dart';

class PostScreen extends StatefulWidget {
  final Post post;
  final String? from;
  const PostScreen({required this.post,super.key, this.from});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  bool deletePost = false;
  late DeleteBloc deleteBloc;
  late GraphQLClient client;


  @override
  void initState() {
    client = GraphQLClientService().getClient();
    deleteBloc = DeleteBloc(DeletePost(PostRepositoryImpl(remoteDataSource: HomeRemoteDataSource(graphQLClient: client, context: context), context: context)));

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    var wh = MediaQuery.of(context).size.width;
    var hh = MediaQuery.of(context).size.height;

    return BlocProvider(create: (BuildContext context)=>deleteBloc,
        child: BlocBuilder<DeleteBloc, DeleteState>(
            builder: (context, state) {
              if(state is Deleted){
                Timer(Duration(seconds: 1), () {
                  MToast().pop(context, 'Post Deleted Successfully');
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                        (route) => false, // Replace all routes
                  );
                });
              }

    return WillPopScope(child: Scaffold(
      appBar: AppBar(
        backgroundColor: white,
        leading: BackButton(onPressed: (){
          if(widget.from == null){
            Navigator.pop(context);
          }else{
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
                  (route) => false, // Replace all routes
            );
          }
        },),
        centerTitle: true,
        title: Text(widget.post.title, style: GoogleFonts.poppins(textStyle: TextStyle(fontWeight: FontWeight.w800, color: brown)),maxLines: 1,
          overflow: TextOverflow.ellipsis,),
        actions: [
          if(widget.from != 'create')Center(
              child:InkWell(
                child:Container(
                  width: 35, height: 35,
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(30)
                  ),
                  child: Center(
                    child: Icon(Icons.delete, color: white,),
                  ),
                ),
                onTap: (){
                  setState(() {
                    deletePost = true;
                  });
                },
              )
          ),
          SizedBox(width: 15,)
        ],
      ),
      body: Container(
          width: wh,
          height: hh,
          padding: EdgeInsets.only(top: 5),
          child:Stack(
            children: [
              ListView(
                children: <Widget>[



                  Container(
                    width: wh,
                    height: 100,
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                        color: yellow,
                        border: Border.all(color: yellow.withOpacity(.1), width: 5),
                        image: DecorationImage(image: NetworkImage('https://t3.ftcdn.net/jpg/02/77/30/98/360_F_277309825_h8RvZkoyBGPDocMtippdfe3497xTrOXO.jpg'),
                            fit: BoxFit.cover),
                        borderRadius: BorderRadius.circular(15)
                    ),
                    alignment: Alignment.center,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 4,vertical: 4),
                      padding: EdgeInsets.symmetric(horizontal: 8,vertical: 4),
                      decoration: BoxDecoration(
                          color: white,
                          borderRadius: BorderRadius.circular(30)
                      ),
                      child: Text(widget.post.title, style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 15)),),
                    ),
                  ),

                  SizedBox(height: 8,),

                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    width:double.infinity,
                    child: Text(DateClass().toWDF(widget.post.dateCreated), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500,  color: grey)),
                  ),
                  SizedBox(height: 15,),

                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    width:double.infinity,
                    child: Text('Subtitle: '+widget.post.subTitle, style: GoogleFonts.poppins(
                        textStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: black))
                    ),
                  ),
                  SizedBox(height: 8,),

                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    width:double.infinity,
                    child: Text(widget.post.body, style:
                    GoogleFonts.poppins(textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w300, color: black))
                    ),
                  ),


                ],
              ),
              if(deletePost && !(state is Deleted))Container(
                  width: wh,
                  height: hh,
                  color: Colors.black.withOpacity(.4),
                  padding: EdgeInsets.only(top: 5),
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: white,
                      ),
                      height: 200,
                      width: 250,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if(state is Deleting) Container(
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
                          if(!(state is Deleting))Center(
                            child: Text('Are you sure you want to delete this post?',textAlign: TextAlign.center,),
                          ),
                          if(!(state is Deleting))SizedBox(height: 20,),

                          if(!(state is Deleting))Container(
                            margin: EdgeInsets.only(left: 10),
                            width: 200,
                            height: 55,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(300),
                                color: yellow.withOpacity(.2)
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                InkWell(
                                  child:Container(
                                    width: 35, height: 35,
                                    decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius: BorderRadius.circular(30)
                                    ),
                                    child: Center(
                                      child: Icon(CupertinoIcons.reply_thick_solid, color: white,),
                                    ),
                                  ),
                                  onTap: (){
                                    setState(() {
                                      deletePost = false;
                                    });
                                  },
                                ),
                                InkWell(
                                  child:Container(
                                    width: 35, height: 35,
                                    decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(30)
                                    ),
                                    child: Center(
                                      child: Icon(Icons.check, color: white,),
                                    ),
                                  ),
                                  onTap: ()async{
                                    try{
                                      final response = await http.get(Uri.parse('https://google.com'));
                                      deleteBloc.add(Delete(widget.post.id));
                                    }catch(e){
                                      MToast().error(context, 'You are offline');
                                    }
                                  },
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
              ),
            ],
          )
      ),
      floatingActionButton: widget.from != 'create'? FloatingActionButton(onPressed: (){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => EditPostScreen(post: widget.post)),
        );
      }, child: Text('Edit'),):null,
    ), onWillPop: ()async{
      if(widget.from == null){
        Navigator.pop(context);
      }else{
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
              (route) => false, // Replace all routes
        );
      }
      return false;
    });
    }));
  }
}
