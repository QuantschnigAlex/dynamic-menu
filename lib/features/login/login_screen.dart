import 'dart:async';
import 'package:dynamic_menu/main.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _redirecting = false;

  @override
  void initState() {
    supabase.auth.onAuthStateChange.listen((data) {
      if (_redirecting) return;
      final session = data.session;
      if (session != null) {
        _redirecting = true;
        context.pushReplacement('/qr');
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    final theme = Theme.of(context);

    if (_isError) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Wrong email format")));

      return;
    }

    if (_passwordController.value.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Password must be provided!"),
        ),
      );
      return;
    }
    try {
      setState(() {
        _isLoading = true;
      });
      await supabase.auth.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        emailRedirectTo: 'io.supabase.flutterquickstart://login-callback/',
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Check your email for a login link!')),
        );
        _emailController.clear();
        _passwordController.clear();
      }
    } on AuthException catch (error) {
      SnackBar(
        content: Text(error.message),
        backgroundColor: theme.colorScheme.error,
      );
    } catch (error) {
      SnackBar(
        content: const Text('Unexpected error occurred'),
        backgroundColor: theme.colorScheme.error,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _signIn() async {
    final theme = Theme.of(context);
    final messenger = ScaffoldMessenger.of(context);

    try {
      setState(() {
        _isLoading = true;
      });
      await supabase.auth.signInWithPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      if (mounted) {
        messenger.showSnackBar(
          const SnackBar(content: Text('Logged in successfully')),
        );
        _emailController.clear();
        _passwordController.clear();
      }
    } on AuthException catch (error) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(error.message),
          backgroundColor: theme.colorScheme.error,
        ),
      );
    } catch (error) {
      print(error);

      messenger.showSnackBar(SnackBar(
        content: const Text('Unexpected error occurred'),
        backgroundColor: theme.colorScheme.error,
      ));
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  bool _validateEmail(String email) {
    // Simple regex for email validation
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  bool _isError = false;
  bool _showPassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text(""),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Center(
          child: Column(
            children: [
              const Text("Welcome to Dynamic Menu",
                  style: TextStyle(fontSize: 24.0)),
              const Text("Please login or register to continue",
                  style: TextStyle(fontSize: 16.0)),
              const SizedBox(height: 32.0),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: Card(
                  margin: const EdgeInsets.all(16),
                  color: Theme.of(context).colorScheme.surface,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          keyboardType: TextInputType.emailAddress,
                          controller: _emailController,
                          onChanged: (value) {
                            if (mounted) {
                              setState(() {
                                _isError = !_validateEmail(value);
                              });
                            }
                          },
                          decoration: InputDecoration(
                            labelText: 'E-Mail',
                            focusedBorder: _isError
                                ? const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.red, width: 2.0),
                                  )
                                : OutlineInputBorder(
                                    borderSide: BorderSide(
                                      width: 2.0,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                            border: const OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        TextField(
                          obscureText: !_showPassword,
                          controller: _passwordController,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            suffixIcon: IconButton(
                              icon: _showPassword
                                  ? const Icon(Icons.visibility)
                                  : const Icon(Icons.visibility_off),
                              onPressed: () {
                                setState(() {
                                  _showPassword = !_showPassword;
                                });
                              },
                            ),
                            border: const OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 32.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TextButton(
                              onPressed: _isLoading ? null : _signUp,
                              child: const Text('Register'),
                            ),
                            ElevatedButton(
                              onPressed: _isLoading ? null : _signIn,
                              child: const SizedBox(
                                width: 80,
                                child: Center(
                                  child: Text(
                                    'Login',
                                    style: TextStyle(fontSize: 16.0),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16.0),
                        const Row(
                          children: [
                            Expanded(child: Divider()),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                              child: Text(
                                'OR',
                              ),
                            ),
                            Expanded(
                              child: Divider(),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                                onPressed: () async {},
                                icon: Image.asset(
                                  'assets/logos/apple_logo.png',
                                  height: 50.0,
                                  width: 50.0,
                                )),
                            IconButton(
                              onPressed: () async {},
                              icon: Image.asset(
                                width: 50,
                                height: 50,
                                'assets/logos/google_logo.png',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text("contiunue without signing"),
                        ),
                      ],
                    ),
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
