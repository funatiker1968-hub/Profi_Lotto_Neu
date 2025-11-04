import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'features/home/home_screen.dart';
import 'features/statistics/statistics_screen.dart';
import 'core/services/disclaimer_service.dart';
import 'core/services/language_service.dart';
import 'core/services/theme_service.dart';
import 'widgets/disclaimer_dialog.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LanguageService()),
        ChangeNotifierProvider(create: (_) => ThemeService()),
      ],
      child: Consumer2<LanguageService, ThemeService>(
        builder: (context, languageService, themeService, child) {
          return MaterialApp(
            title: languageService.getText('app_title'),
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            themeMode: themeService.themeMode,
            home: const DisclaimerWrapper(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}

class DisclaimerWrapper extends StatefulWidget {
  const DisclaimerWrapper({super.key});

  @override
  State<DisclaimerWrapper> createState() => _DisclaimerWrapperState();
}

class _DisclaimerWrapperState extends State<DisclaimerWrapper> {
  final DisclaimerService _disclaimerService = DisclaimerService();
  bool _isLoading = true;
  bool _showDisclaimer = false;

  @override
  void initState() {
    super.initState();
    _checkDisclaimer();
  }

  Future<void> _checkDisclaimer() async {
    final languageService = Provider.of<LanguageService>(context, listen: false);
    final themeService = Provider.of<ThemeService>(context, listen: false);
    
    await languageService.loadLanguage();
    await themeService.loadTheme();
    final isAccepted = await _disclaimerService.isDisclaimerAccepted();
    
    if (!mounted) return;
    
    setState(() {
      _isLoading = false;
      _showDisclaimer = !isAccepted;
    });
  }

  void _handleDisclaimerResult(bool accepted) async {
    if (accepted) {
      await _disclaimerService.setDisclaimerAccepted(true);
      if (!mounted) return;
      setState(() {
        _showDisclaimer = false;
      });
    } else {
      exit(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_showDisclaimer) {
      return Consumer<LanguageService>(
        builder: (context, languageService, child) {
          return Dialog(
            child: DisclaimerDialog(
              languageService: languageService,
              onResult: _handleDisclaimerResult,
            ),
          );
        },
      );
    }

    return const MainNavigationScreen();
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final _screens = [
    const HomeScreen(),
    const StatisticsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final languageService = Provider.of<LanguageService>(context);
    
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: languageService.getText('home'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.bar_chart),
            label: languageService.getText('statistics'),
          ),
        ],
      ),
    );
  }
}
