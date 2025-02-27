import 'package:flutter/material.dart';
import 'package:formulaire_app/controllers/user_controller.dart';
import 'package:formulaire_app/models/user.dart';
import 'welcome_screen.dart';
import '../services/auth_service.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}


//Moved validation logic to the controller
// Created a User model for data handling
// Simplified the SignUpScreen code
// Better organized the file storage logic


class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController prenomController = TextEditingController();
  final TextEditingController nomController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final StorageService _storageService = StorageService();
  final AuthController _authController = AuthController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  Future<void> _register() async {
    setState(() => _isLoading = true);

    try {
      final user = User(
          prenom: prenomController.text.trim(),
          nom: nomController.text.trim(),
          email: emailController.text.trim(),
          password: passwordController.text.trim());
      await _authController.signUp(user);

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                WelcomeScreen(prenom: user.prenom, nom: user.nom),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFEBC894), Color(0xFFB49EF4)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: SingleChildScrollView(
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Sign Up",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Create an account to continue!",
                        style: TextStyle(color: Colors.grey),
                      ),
                      SizedBox(height: 16),
                      _buildTextField("Prénom", prenomController),
                      SizedBox(height: 12),
                      _buildTextField("Nom", nomController),
                      SizedBox(height: 12),
                      _buildTextField("Email", emailController,
                          keyboardType: TextInputType.emailAddress),
                      SizedBox(height: 12),
                      _buildPasswordField(),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _isLoading ? null : _register,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: EdgeInsets.symmetric(
                            vertical: 14,
                            horizontal: 64,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: _isLoading
                            ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                "Register",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                      SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Already have an account? "),
                          GestureDetector(
                            onTap: () {}, // Add login navigation later
                            child: Text(
                              "Login",
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String hint, TextEditingController controller,
      {TextInputType? keyboardType}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Color(0xFFA3A3A3)),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextField(
      controller: passwordController,
      obscureText: _obscurePassword,
      decoration: InputDecoration(
        hintText: "Password",
        hintStyle: TextStyle(color: Color(0xFFA3A3A3)),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey,
          ),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    prenomController.dispose();
    nomController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
