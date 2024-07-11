import 'package:flutter/material.dart';
import 'package:todo/delay_animation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:todo/provider/user_provider.dart';
import 'package:todo/view/loginscreen.dart';
import 'package:todo/view/task_list.dart';

class DemarragePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 255, 255, 1),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(
            vertical: 60,
            horizontal: 30,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              
              SizedBox(height: 250),
              DelayedAnimation(
                delay: 0,
                child: Text(
                  'TODO !',
                  style: GoogleFonts.poppins(
                    fontSize: 38,
                    fontWeight: FontWeight.w700,
                    color: Color.fromRGBO(0, 113, 191, 1),
                  ),
                ),
              ),
              SizedBox(height: 10),
              DelayedAnimation(
                delay: 300,
                child: Text(
                  'Gérez vos tâches avec aisance et efficacité.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Color.fromRGBO(0, 113, 191, 1),
                  ),
                ),
              ),
              SizedBox(height: 200),
              DelayedAnimation(
                delay: 1000,
                child: Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                      backgroundColor: Color.fromRGBO(0, 113, 191, 1), // Define the color as needed
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'COMMENCER',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        color: Color.fromRGBO(255, 255, 255, 1),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => CheckUserState()),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CheckUserState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    if (userProvider.user == null) {
      return LoginScreen();
    } else {
      return const TaskListView();
    }
  }
}
