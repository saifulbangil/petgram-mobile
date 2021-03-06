import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petgram_mobile_app/bloc/follow_unfollow_bloc/follow_unfollow_bloc.dart';
import 'package:petgram_mobile_app/bloc/my_profile_bloc/profile_bloc.dart';
import 'package:petgram_mobile_app/bloc/user_profile_bloc/user_profile_bloc.dart';
import 'package:petgram_mobile_app/screens/profile_screen/profile_loading.dart';

import 'ProfileScreen.dart';

class UserProfileScreen extends StatefulWidget {
  final String id;


  UserProfileScreen({this.id});

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {

  @override
  void initState() {
    super.initState();
    BlocProvider.of<FollowUnfollowUserBloc>(context);
    BlocProvider.of<UserProfileBloc>(context).add(FetchUserProfile(
      id: widget.id
    ));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<UserProfileBloc,UserProfileState>(
        listener: (context,state){
          if(state is UserProfileFailure){
            Scaffold.of(context)..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(
                content: Text(state.msg),
              ));
          }
        },
        builder: (context,state){
          print(state);
          if(state is UserProfileLoading){
            return ProfileScreenLoading();
          }
          if(state is UserProfileFailure){
            return Center(
              child: Text(state.msg),
            );
          }
          if(state is UserProfileLoaded){
            return ProfileScreen(
              showLogout: false,
              userDetail: state.userProfileModel.user,
            );
          }
          return Container();
        },
      ),
    );
  }
}