import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime? selectedDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: TableCalendar(
          focusedDay: DateTime(2024, 7, 1),
          firstDay: DateTime(1800),
          lastDay: DateTime(3000),
          onDaySelected: (DateTime selectedDay, DateTime focuseDay){
            setState(() {
              this.selectedDay = selectedDay;
            });
          },
          selectedDayPredicate: (DateTime date){
            if(selectedDay == null){
              return false;
            }
            return date.isAtSameMomentAs(selectedDay!);
          },
        ),
      ),
    );
  }
}

