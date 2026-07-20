import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:online_exam/l10n/app_localizations.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home View'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: .stretch,
          mainAxisAlignment: .center,
          children: [
            Text(AppLocalizations.of(context)!.helloWorld),
            SizedBox(height: 16.h),
            ElevatedButton(onPressed: (){}, child: const Text('Press Me')),
            SizedBox(height: 16.h),
            TextField(
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.helloWorld,
                labelText: AppLocalizations.of(context)!.helloWorld,
              ),
            ),
          ],
        ),
      ),
    );
  }
}