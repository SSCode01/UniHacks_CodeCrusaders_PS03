import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'edit_profile_screen.dart';
import 'change_password_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D1B2A),
        elevation: 0,
        title: const Text(
          "Settings",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          children: [

            _settingsTile(
              icon: Icons.edit,
              title: "Edit Profile",
              onTap: () {
                 Navigator.push(
                 context,
                 MaterialPageRoute(
                 builder: (context) => const EditProfileScreen(),
    ),
  );
              },
            ),

            const SizedBox(height: 16),

            _settingsTile(
              icon: Icons.lock_outline,
              title: "Change Password",
              onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const ChangePasswordScreen(),
    ),
  );
},

            ),

            const SizedBox(height: 16),

            _settingsTile(
              icon: Icons.logout,
              title: "Logout",
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _settingsTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1B263B),
        borderRadius: BorderRadius.circular(18),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.white),
        title: Text(
          title,
          style: const TextStyle(color: Colors.white),
        ),
        trailing: const Icon(Icons.arrow_forward_ios,
            color: Colors.white54, size: 16),
        onTap: onTap,
      ),
    );
  }
}
