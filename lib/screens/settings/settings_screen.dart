import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubits/theme/theme_cubit.dart';
import '../../cubits/theme/theme_state.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          _buildThemeSection(context),
          const Divider(),
          _buildAboutSection(context),
        ],
      ),
    );
  }

  Widget _buildThemeSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Appearance',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, state) {
            return SwitchListTile(
              title: const Text('Dark Mode'),
              subtitle: Text(
                state.isDarkMode ? 'Enabled' : 'Disabled',
              ),
              secondary: Icon(
                state.isDarkMode ? Icons.dark_mode : Icons.light_mode,
              ),
              value: state.isDarkMode,
              onChanged: (_) {
                context.read<ThemeCubit>().toggleTheme();
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildAboutSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'About',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.info_outline),
          title: const Text('App Version'),
          subtitle: const Text('1.0.0'),
        ),
        ListTile(
          leading: const Icon(Icons.code),
          title: const Text('Technology'),
          subtitle: const Text('Flutter with Cubit State Management'),
        ),
        ListTile(
          leading: const Icon(Icons.api),
          title: const Text('API'),
          subtitle: const Text('FakeStore API'),
          onTap: () {
            _showApiInfo(context);
          },
        ),
        ListTile(
          leading: const Icon(Icons.description),
          title: const Text('About This App'),
          onTap: () {
            _showAboutDialog(context);
          },
        ),
      ],
    );
  }

  void _showApiInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('API Information'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'This app uses the FakeStore API for product data.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                'Base URL:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('https://fakestoreapi.com'),
              SizedBox(height: 12),
              Text(
                'Endpoints Used:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('• GET /products'),
              Text('• GET /products/{id}'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('E-Commerce Shopping App'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'A full-featured e-commerce shopping application built with Flutter.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                'Features:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 8),
              Text('• Product browsing with grid/list views'),
              Text('• Search and filter functionality'),
              Text('• Shopping cart management'),
              Text('• Local data persistence'),
              Text('• Dark mode support'),
              Text('• Offline mode with cached data'),
              SizedBox(height: 16),
              Text(
                'Technologies:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 8),
              Text('• Flutter'),
              Text('• Cubit State Management'),
              Text('• HTTP for API calls'),
              Text('• SharedPreferences for storage'),
              Text('• Cached Network Images'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
