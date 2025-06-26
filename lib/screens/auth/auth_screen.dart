import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  bool isLogin = true;
  bool isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _authenticate() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => isLoading = true);

    try {
      final supabase = Supabase.instance.client;
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();
      final name = _nameController.text.trim();

      if (isLogin) {
        await supabase.auth
            .signInWithPassword(email: email, password: password);
      } else {
        final res = await supabase.auth.signUp(
          email: email,
          password: password,
          data: {'name': name},
        );
        if (res.user != null) {
          await supabase.auth.updateUser(UserAttributes(data: {'name': name}));
        }
      }

      if (mounted) Navigator.pushReplacementNamed(context, '/quiz');
    } on AuthException catch (e) {
      _showError(e.message);
    } catch (_) {
      _showError("Unexpected error occurred");
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.primary.withOpacity(0.8),
                  theme.colorScheme.secondary.withOpacity(0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // Auth Form
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Animate(
                      effects: [FadeEffect()],
                      child: Lottie.asset('assets/auth.json', height: 160)),
                  const SizedBox(height: 24),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: Colors.white30, width: 1),
                        ),
                        child: Form(
                          key: _formKey,
                          child: AnimatedSwitcher(
                            duration: 300.ms,
                            child: Column(
                              key: ValueKey(isLogin),
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                if (!isLogin)
                                  _buildField(_nameController, 'Full Name',
                                          Icons.person, false)
                                      .animate()
                                      .fadeIn(),
                                const SizedBox(height: 16),
                                _buildField(_emailController, 'Email',
                                    Icons.email, false),
                                const SizedBox(height: 16),
                                _buildField(_passwordController, 'Password',
                                    Icons.lock, true),
                                if (!isLogin) ...[
                                  const SizedBox(height: 16),
                                  _buildField(
                                          _confirmController,
                                          'Confirm Password',
                                          Icons.lock_reset,
                                          true,
                                          confirm: true)
                                      .animate()
                                      .fadeIn(),
                                ],
                                const SizedBox(height: 24),
                                _buildButton(theme),
                                const SizedBox(height: 12),
                                TextButton(
                                  onPressed: () =>
                                      setState(() => isLogin = !isLogin),
                                  child: Text(
                                    isLogin
                                        ? "Don't have an account? Sign Up"
                                        : "Already have an account? Login",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      color: Colors.white.withOpacity(0.95),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.2),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField(
      TextEditingController ctl, String lbl, IconData icon, bool isPwd,
      {bool confirm = false}) {
    return TextFormField(
      controller: ctl,
      obscureText: isPwd,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: lbl,
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        prefixIcon: Icon(icon, color: Colors.white70),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Colors.white30),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Colors.white),
        ),
      ),
      validator: (val) {
        if (val == null || val.trim().isEmpty) return '$lbl is required';
        if (confirm && val != _passwordController.text)
          return 'Passwords do not match';
        return null;
      },
    );
  }

  Widget _buildButton(ThemeData theme) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: isLoading ? null : _authenticate,
        icon: isLoading
            ? const SizedBox(
                height: 18,
                width: 18,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: Colors.white),
              )
            : Icon(Icons.arrow_forward, color: Colors.grey.shade700,),
        label: Text(isLogin ? 'Login' : 'Sign Up', style: TextStyle(color: Colors.grey.shade700,),),
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.primary.withOpacity(0.95),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
