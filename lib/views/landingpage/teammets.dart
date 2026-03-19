import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:winstar/services/pref.dart';
import 'package:winstar/utils/app_utils.dart';
import 'package:winstar/utils/sharedprefconstants.dart';

class MyTeamScreen extends StatelessWidget {
  const MyTeamScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: AppUtils.buildNormalText(
          text: "My Team",
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildTeamCard(
            title: "Head of Department (HOD)",
            name:
                Prefs.getLinemanager(SharefprefConstants.sharedhod).toString(),
            initials: "HO",
            color: Colors.indigo,
          ),
          _buildTeamCard(
            title: "Line Manager",
            name: Prefs.getSupervisor(SharefprefConstants.sharedLineManager)
                .toString(),
            initials: "LM",
            color: Colors.deepPurple,
          ),
          _buildTeamCard(
            title: "Supervisor",
            name: Prefs.gethod(SharefprefConstants.sharedsupervisor).toString(),
            initials: "SP",
            color: Colors.teal,
          ),
          _buildTeamCard(
            title: Prefs.getDesignation(SharefprefConstants.shareddept) ??
                "Employee",
            name:
                Prefs.getFullName(SharefprefConstants.shareFullName) ?? "Staff",
            initials: _getInitials(
              Prefs.getFullName(SharefprefConstants.shareFullName),
            ),
            color: Colors.orangeAccent,
            highlight: true,
          ),
        ],
      ),
    );
  }

  // --- Helper: Beautiful Team Card ---
  Widget _buildTeamCard({
    required String title,
    required String name,
    required String initials,
    required Color color,
    bool highlight = false,
  }) {
    return Card(
      elevation: highlight ? 6 : 3,
      shadowColor: highlight ? color.withOpacity(0.3) : Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        leading: CircleAvatar(
          radius: 28,
          backgroundColor: color.withOpacity(0.15),
          child: Text(
            initials,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15,
            color: highlight ? color : Colors.grey[800],
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(
            name,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black87,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        trailing: highlight
            ? Icon(CupertinoIcons.star_fill, color: color, size: 20)
            : Icon(CupertinoIcons.person_alt_circle,
                color: color.withOpacity(0.6), size: 20),
      ),
    );
  }

  // --- Helper: Safe Initials Generator ---
  String _getInitials(String? fullName) {
    if (fullName == null || fullName.isEmpty) return "U";
    final parts = fullName.trim().split(" ");
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
        .toUpperCase();
  }
}

class TeamMember {
  final String name;
  final String designation;
  final String? imagePath;
  final String? initials;

  TeamMember(this.name, this.designation, this.imagePath, {this.initials});
}
