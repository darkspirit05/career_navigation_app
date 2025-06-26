import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  String userName = 'AI Career Navigator';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    try {
      await Supabase.instance.client.auth.refreshSession();
      final user = Supabase.instance.client.auth.currentUser;

      final name = user?.userMetadata?['name'];
      if (name != null && name.toString().trim().isNotEmpty) {
        setState(() {
          userName = name.toString().trim();
        });
      }
    } catch (e) {
      debugPrint('Error fetching user name: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final colorScheme = theme.colorScheme;

    return Drawer(
      backgroundColor: Colors.transparent,
      child: Stack(
        children: [
          // Blur & frosted glass background
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withOpacity(0.05)
                    : Colors.white.withOpacity(0.7),
              ),
            ),
          ),
          // Content
          Column(
            children: [
              Container(
                padding: const EdgeInsets.only(top: 40),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withOpacity(0.3),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                ),
                child: UserAccountsDrawerHeader(
                  decoration: const BoxDecoration(color: Colors.transparent),
                  accountName: isLoading
                      ? const Text('Loading...')
                      : Text(userName, style: const TextStyle(fontSize: 18)),
                  accountEmail: null,
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: Colors.white24,
                    child: Icon(Icons.person,
                        color: colorScheme.onPrimary, size: 36),
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  children: [
                    _buildDrawerTile(
                      context,
                      icon: Icons.quiz_outlined,
                      label: 'Take Quiz',
                      routeName: '/quiz',
                    ),
                    _buildDrawerTile(
                      context,
                      icon: Icons.history,
                      label: 'History',
                      routeName: '/history',
                    ),
                    const Divider(color: Colors.grey,),
                    ListTile(
                      leading: const Icon(Icons.logout),
                      title: const Text('Logout'),
                      onTap: () => _confirmLogout(context),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerTile(
      BuildContext context, {
        required IconData icon,
        required String label,
        required String routeName,
      }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      onTap: () {
        Navigator.pop(context);
        Navigator.pushReplacementNamed(context, routeName);
      },
    );
  }

  Future<void> _confirmLogout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await Supabase.instance.client.auth.signOut();
      if (context.mounted) {
        Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
      }
    }
  }
}
