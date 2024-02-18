import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graphql/client.dart';
import 'package:vmblog/core/config/motion_toast.dart';
import 'package:vmblog/src/features/home/presentation/bloc.dart';
import 'package:vmblog/src/features/view_post/presentation/post_screen.dart';
import 'package:vmblog/src/shared/data/post.dart';
import 'package:vmblog/src/shared/domain/repositories/implemetations/post_repository_impl.dart';
import 'package:vmblog/core/data/graphql_client.dart';
import 'package:vmblog/src/shared/utils/colors.dart';
import 'package:vmblog/src/shared/utils/date.dart';
import 'package:vmblog/src/shared/widgets/CustomBottomNavigation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vmblog/src/shared/application/post_usecases/get_post_usecase.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController _searchController = TextEditingController();
  late HomeBloc homeBloc;
  late GraphQLClient client;


  @override
  void initState() {
    client = GraphQLClientService().getClient();
    homeBloc = HomeBloc(GetPosts(PostRepositoryImpl(remoteDataSource: HomeRemoteDataSource(graphQLClient: client, context: context), context: context)))
    ..add(FetchPosts());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var wh = MediaQuery.of(context).size.width;
    var hh = MediaQuery.of(context).size.height;
    return BlocProvider(create: (BuildContext context)=>homeBloc,
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state){
          return Scaffold(
            appBar: AppBar(
              backgroundColor: white,
              leading: Center(
                child: InkWell(
                  child: Container(
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
                        state is PostLoading?Container(
                            width: 15,height: 15,
                            child: LinearProgressIndicator()
                        ):
                        Icon(CupertinoIcons.refresh, color: black,size: 14,)

                      ],
                    ),
                  ),
                  onTap: (){
                    if(state is PostLoaded || state is HomeError){
                      homeBloc.add(FetchPosts());
                    }
                  },
                ),
              ),
              centerTitle: true,
              title: Text('VMBlog', style: GoogleFonts.poppins(textStyle: TextStyle(fontWeight: FontWeight.w800, color: brown)),),
              actions: [
                Container(
                  decoration: BoxDecoration(
                      border:Border.all(color: yellow,width: 4),
                      borderRadius: BorderRadius.circular(300)
                  ),
                  child: CircleAvatar(
                    backgroundColor: yellow,
                    radius: 15,
                    backgroundImage: NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQFUA1rz0ckGoZ9ZzSs-3dM5rWNpL_HsLHp8OyQoy0gJA&s',),
                  ),
                ),
                SizedBox(width: 10,)
              ],
              bottom: PreferredSize(preferredSize: Size(wh, 40),
                  child: Container(
                    padding: EdgeInsets.only(left: 15,right:15,bottom: 5),
                    child: Container(
                      padding: EdgeInsets.only(left: 8,right:8,),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: lightGrey
                      ),
                      child:CupertinoTextField(
                        controller: _searchController,
                        style: GoogleFonts.poppins(textStyle: TextStyle(color: black)),
                        placeholder: 'Search',
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                        ),
                        onChanged: (query){
                          homeBloc.add(FilterPost(query));
                        },
                        placeholderStyle: GoogleFonts.poppins(textStyle: TextStyle(color: grey)),
                        prefix: Icon(
                          CupertinoIcons.search,
                          color: grey,
                        ),
                      ),
                    ),
                  )
              ),
            ),
            body: Container(
                width: wh,
                height: hh,
                padding: EdgeInsets.only(top: 5),
                child: state is PostLoaded?
                    state.posts.length == 0?
                    Center(
                      child: Text('No Post Found'),
                    ):
                ListView.builder(
                  itemCount: state.posts.length,
                  itemBuilder: (context, index) {
                    final post = state.posts[index];
                    return InkWell(
                      child: Container(
                          width: wh,
                          margin: EdgeInsets.symmetric(horizontal: 15,vertical: 8),
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                              border: Border.all(color: yellow.withOpacity(.05), width: 5),
                              color: veryLightGrey,
                              borderRadius: BorderRadius.circular(18)
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                width:( wh *.6) - 15,
                                padding: EdgeInsets.only(right: 10),
                                child:Column(
                                  children: [
                                    Container(
                                      width:double.infinity,
                                      child: Text('Title: '+post.title, style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600, color: grey),maxLines: 1,
                                        overflow: TextOverflow.ellipsis,),
                                    ),
                                    SizedBox(height: 8,),
                                    Container(
                                      width:double.infinity,
                                      child: Text(post.subTitle, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: black),maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    SizedBox(height: 8,),
                                    Container(
                                      width:double.infinity,
                                      child: Text(post.body, style:
                                      GoogleFonts.poppins(textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: grey)),maxLines: 2,
                                        overflow: TextOverflow.ellipsis,),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width:( wh *.3) - 15,
                                height: ( wh *.3) - 15,
                                decoration: BoxDecoration(
                                    color: yellow,
                                    border: Border.all(color: yellow.withOpacity(.1), width: 5),
                                    image: DecorationImage(image: NetworkImage('https://t3.ftcdn.net/jpg/02/77/30/98/360_F_277309825_h8RvZkoyBGPDocMtippdfe3497xTrOXO.jpg'),
                                    fit: BoxFit.cover),
                                    borderRadius: BorderRadius.circular(15)
                                ),
                                alignment: Alignment.bottomRight,
                                child: Container(
                                  margin: EdgeInsets.symmetric(horizontal: 4,vertical: 4),
                                  padding: EdgeInsets.symmetric(horizontal: 8,vertical: 4),
                                  decoration: BoxDecoration(
                                      color: white,
                                      borderRadius: BorderRadius.circular(30)
                                  ),
                                  child: Text(DateClass().toWDF(post.dateCreated), style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 12)),),
                                ),
                              )
                            ],
                          )
                      ),
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => PostScreen(post: post)),
                        );
                      },
                    );
                  },
                ):
                    state is HomeError?
                InkWell(
                  child: Container(
                    height: 200,
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
                              state is PostLoading?Container(
                                  width: 15,height: 15,
                                  child: LinearProgressIndicator()
                              ):
                              Icon(CupertinoIcons.refresh, color: black,size: 14,)

                            ],
                          ),
                        ),
                        SizedBox(height: 15,),
                        Center(
                          child: Text('Can not fetch post. Click to Retry',textAlign: TextAlign.center,),
                        )
                      ],
                    ),
                  ),
                  onTap: (){
                      homeBloc.add(FetchPosts());
                  },
                ):
                        state is PostLoading?
                Center(
                  child: Container(
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
                        state is PostLoading?Container(
                            width: 15,height: 15,
                            child: LinearProgressIndicator()
                        ):
                        Icon(CupertinoIcons.refresh, color: black,size: 14,)

                      ],
                    ),
                  ),
                ):
                Center(
                  child: Text('Loading... Pleace Wait!'),
                )
            ),
            bottomNavigationBar: CustomBottomNavigation(active: 1,),
          );
        },
      ),
    );
  }
}

