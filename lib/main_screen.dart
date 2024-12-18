import 'package:flutter/material.dart';
import 'package:flutter_firebase/constants/colors.dart';
import 'package:flutter_firebase/screens/home_page.dart';
import 'package:flutter_firebase/screens/user_history.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  int _selectedIndex = 0;

  // Method to handel the tapping on bottom navigation items
void _onTapItem(int index){
  setState(() {
    
    _selectedIndex = index;
  });

}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar:BottomNavigationBar(
        items:const [
        BottomNavigationBarItem(icon: Icon(Icons.transform),
        label: "Conversion",
        ),
        BottomNavigationBarItem(icon: Icon(Icons.history),
        label: "History",
        ),
      ],
      onTap: _onTapItem,
      currentIndex: _selectedIndex,
      unselectedItemColor: const Color.fromARGB(255, 5, 35, 61),
      selectedItemColor: const Color.fromARGB(255, 252, 254, 255),
      backgroundColor: mainColor,
      ) ,
      body: _selectedIndex ==0 ? HomePage() : UserHistory(),
    );
  }
}