import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:formfrontend/theme.dart';
import 'package:formfrontend/screens/dashboard_screen.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (context, orientation, screenType) {
        return MaterialApp(
          title: 'A.D.I.Y.O.G.I',
          theme: AppTheme.light,
          debugShowCheckedModeBanner: false,
          home: const DashboardScreen(),
        );
      },
    );
  }
}
