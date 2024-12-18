import 'package:flutter/material.dart';
import 'package:flutter_firebase/provider/premium_provider.dart';
import 'package:flutter_firebase/widgets/show_premium.dart';
import 'package:flutter_firebase/widgets/user_history_widget.dart';
import 'package:provider/provider.dart';


class UserHistory extends StatelessWidget {
  const UserHistory({super.key});

  @override
  Widget build(BuildContext context) {
    final isPremiumProvider = Provider.of<PremiumProvider>(context);

    //check if the premium  status is not loader  yet
    WidgetsBinding.instance.addPostFrameCallback((_){
      isPremiumProvider.checkPremiumStatus();
    });
    
    return Scaffold(appBar:AppBar(
      title:  const Text(
        'History Conversion',
        style: TextStyle(
          fontSize: 20,
          color: Colors.white,
        ),
      ),
    ) ,
    body: isPremiumProvider.isPremium? const UserHistoryWidget(): const ShowPremiumPannel(),
    );
  }
}