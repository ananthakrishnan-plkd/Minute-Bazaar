import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:online_groceries/view/login/sign_up_view.dart';
import '../../common/color_extension.dart';

import '../../common_widget/round_button.dart';

class WelcomeView extends StatefulWidget {
  const WelcomeView({super.key});

  @override
  State<WelcomeView> createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setEnabledSystemUIMode( SystemUiMode.leanBack );
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: TColor.primary,
      body: Stack(
        children: [
          Image.asset(
            "assets/img/welcom_bg.png",
            width: media.width,
            height: media.height,
            fit: BoxFit.cover,
          ),
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
          
              children: [

                Image.asset("assets/img/app_logo.png", width: 120, height: 120, ),


                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                     Text(
                      "Welcome to\n Minute Bazaar",
                      style: TextStyle(
                          color: Colors.black54,
                          fontSize: 46,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
          
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                     Text(
                      "Shop groceries in minutes, anytime, anywhere",
                      style: TextStyle(
                          color: const Color(0xff000000).withOpacity(1),
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),


                const SizedBox(height: 50,),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: RoundButton(title: "Start Shopping", onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUpView() ) );
                  },),
                ),
                

                const SizedBox(height: 46,),
              ],
            ),
          )
        ],
      ),
    );
  }
}
