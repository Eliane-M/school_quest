import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: SetNewPasswordPage(),
  ));
}

class SetNewPasswordPage extends StatefulWidget {
  final Map<String, dynamic>? arguments;
  const SetNewPasswordPage({super.key, this.arguments});

  @override
  _SetNewPasswordPageState createState() => _SetNewPasswordPageState();
}

class _SetNewPasswordPageState extends State<SetNewPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;
  bool _isLoading = false;

  Future<void> _updatePassword() async {
    if (!_formKey.currentState!.validate()) return;

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passwords do not match")),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final oobCode = widget.arguments?['oobCode'] as String?;
      if (oobCode != null) {
        // Verify the reset code
        final email = await _auth.verifyPasswordResetCode(oobCode);
        // Update password
        await _auth.confirmPasswordReset(
          code: oobCode,
          newPassword: _passwordController.text,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Password updated successfully")),
        );
        Navigator.pushNamed(context, '/successfulset');
      } else {
        throw Exception('Invalid reset link');
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'An error occurred';
      switch (e.code) {
        case 'expired-action-code':
          errorMessage = 'The reset link has expired';
          break;
        case 'invalid-action-code':
          errorMessage = 'The reset link is invalid';
          break;
        case 'user-disabled':
          errorMessage = 'This account has been disabled';
          break;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEAF3FC), // Light blue background
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                const Text(
                  "Set New Password",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  "Try to create a new password that you will remember.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
                const SizedBox(height: 20),
                Image.asset(
                  'images/new_password.png',
                  height: 150,
                ),
                const SizedBox(height: 20),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buildPasswordField(
                          "New Password", _passwordController, true),
                      const SizedBox(height: 15),
                      _buildPasswordField(
                          "Confirm Password", _confirmPasswordController, false),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                _buildPasswordRequirements(),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _updatePassword,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[900],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "Save new password",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    // Handle support action
                    Navigator.pushNamed(context, '/');
                  },
                  child: const Text(
                    "Need help? Contact Support",
                    style: TextStyle(color: Colors.blueAccent),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField(
      String label, TextEditingController controller, bool isNewPassword) {
    return TextFormField(
      controller: controller,
      obscureText: isNewPassword ? !_passwordVisible : !_confirmPasswordVisible,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        suffixIcon: IconButton(
          icon: Icon(
            isNewPassword
                ? (_passwordVisible ? Icons.visibility : Icons.visibility_off)
                : (_confirmPasswordVisible
                    ? Icons.visibility
                    : Icons.visibility_off),
            color: Colors.black54,
          ),
          onPressed: () {
            setState(() {
              if (isNewPassword) {
                _passwordVisible = !_passwordVisible;
              } else {
                _confirmPasswordVisible = !_confirmPasswordVisible;
              }
            });
          },
        ),
      ),
      validator: (value) {
        if (value == null || value.length < 8) {
          return "Password must be at least 8 characters long";
        }
        return null;
      },
    );
  }

  Widget _buildPasswordRequirements() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildRequirement("At least 8 characters", true),
        _buildRequirement("Uppercase and lowercase letters (optional)", true),
        _buildRequirement("At least one number or symbol (optional)", true),
      ],
    );
  }

  Widget _buildRequirement(String text, bool isValid) {
    return Row(
      children: [
        Icon(
          isValid ? Icons.check_circle : Icons.cancel,
          color: isValid ? Colors.green : Colors.red,
          size: 18,
        ),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(fontSize: 14)),
      ],
    );
  }

  void savePassword() {
    if (_formKey.currentState!.validate()) {
      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Passwords do not match")),
        );
      } else {
        // Implement password update logic
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Password updated successfully!")),
        );
      }
    }
  }
}
