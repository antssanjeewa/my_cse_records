import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101322), 
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 16),
                // Top Bar
                Row(
                  children: [
                    IconButton(
                        icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF1337EC)),
                        onPressed: () {}, 
                    ), 
                    const Expanded(
                      child: Text('Login', 
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                      )
                    ),
                    const SizedBox(width: 48), // balance space
                  ],
                ),
                
                const SizedBox(height: 32),
                
                // Icon
                Center(
                  child: Container(
                    width: 64, height: 64,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1337EC).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.trending_up, color: Color(0xFF1337EC), size: 36),
                  ),
                ),
                
                const SizedBox(height: 24),
                // Text
                Text('Welcome Back', 
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 8),
                Text('Securely manage your CSE portfolio and track market movements in real-time.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(fontSize: 16, color: Colors.white54),
                ),
                
                const SizedBox(height: 48),
                
                // Form
                _buildTextField(label: 'Email Address', hint: 'e.g. investor@cse.lk', icon: null),
                const SizedBox(height: 16),
                _buildTextField(label: 'Password', hint: 'Enter your password', icon: Icons.visibility, isPassword: true),
                 
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: Text('Forgot Password?', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: const Color(0xFF1337EC))),
                  ),
                ),

                const SizedBox(height: 16),
                
                ElevatedButton(
                  onPressed: () {
                     context.go('/home');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1337EC),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    textStyle: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold),
                    elevation: 4,
                    shadowColor: const Color(0xFF1337EC).withOpacity(0.2),
                  ),
                  child: const Text('Sign In'),
                ),

                const SizedBox(height: 32),
                
                // Biometric
                 Column(
                   children: [
                     const Text('Quick Access', style: TextStyle(color: Colors.white54, fontSize: 14)),
                     const SizedBox(height: 16),
                     Container(
                       width: 64, height: 64,
                       decoration: BoxDecoration(
                         color: const Color(0xFF1337EC).withOpacity(0.1),
                         border: Border.all(color: const Color(0xFF1337EC).withOpacity(0.3)),
                         shape: BoxShape.circle,
                       ),
                       child: const Icon(Icons.fingerprint, size: 36, color: Color(0xFF1337EC)),
                     ),
                     const SizedBox(height: 8),
                     const Text('Biometric Login', style: TextStyle(color: Colors.white54, fontSize: 12)),
                   ],
                 ),

                 const SizedBox(height: 32),
                 Center(
                   child: RichText(
                     text: TextSpan(
                       style: const TextStyle(color: Colors.white54), 
                       children: [
                         const TextSpan(text: "Don't have an account? "),
                         TextSpan(text: "Sign Up", style: TextStyle(color: const Color(0xFF1337EC), fontWeight: FontWeight.bold)),
                       ]
                     )
                   )
                 ),
                 
                 const SizedBox(height: 24),
                 // Security Badge
                 Row(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     Icon(Icons.lock, size: 12, color: Colors.white.withOpacity(0.5)),
                     const SizedBox(width: 4),
                     Text('END-TO-END ENCRYPTED', style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 10, letterSpacing: 1.0)),
                   ],
                 )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({required String label, required String hint, IconData? icon, bool isPassword = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         Text(label, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
         const SizedBox(height: 8),
         TextField(
           obscureText: isPassword,
           style: const TextStyle(color: Colors.white),
           decoration: InputDecoration(
             filled: true,
             fillColor: const Color(0xFF191E33),
             hintText: hint,
             hintStyle: const TextStyle(color: Color(0xFF929BC9)),
             border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF323B67))),
             enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF323B67))),
             focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF1337EC))),
             suffixIcon: icon != null ? Icon(icon, color: const Color(0xFF929BC9)) : null,
             contentPadding: const EdgeInsets.all(16),
           ),
         ),
      ],
    );
  }
}
