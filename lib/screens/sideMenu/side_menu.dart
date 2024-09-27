import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({super.key});

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  // Track expanded states of expansion tiles
  final List<bool> _isExpanded = List.generate(10, (_) => false);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF2C3E50), Color(0xFF4CA1AF)],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(context),
              _buildMenuItems(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          Container(
            height: 120,
            width: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: const Center(
              child: Text(
                "AP",
                style: TextStyle(
                  color: Color(0xFF2C3E50),
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            "Alag Plywood",
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItems(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          _buildMenuItem(
              title: "Dashboard", icon: Icons.dashboard, onTap: () {}),
          _buildExpansionMenuItem(
              index: 0,
              title: "Company",
              icon: Icons.business,
              children: [
                _buildSubMenuItem(title: "Company List", onTap: () {}),
                _buildSubMenuItem(title: "Branch List", onTap: () {}),
              ]),
          _buildExpansionMenuItem(
              index: 1,
              title: "Master",
              icon: Icons.assignment,
              children: [
                _buildSubMenuItem(title: "Product", onTap: () {}),
                _buildSubMenuItem(title: "Category", onTap: () {}),
                _buildSubMenuItem(title: "SubCategory", onTap: () {}),
                _buildSubMenuItem(title: "Customer", onTap: () {}),
                _buildSubMenuItem(title: "HSN/SAC Rate", onTap: () {}),
              ]),
          _buildExpansionMenuItem(
              index: 2,
              title: "Transactions",
              icon: Icons.swap_horiz,
              children: [
                _buildSubMenuItem(title: "Purchase", onTap: () {}),
              ]),
          _buildDivider(),
          _buildExpansionMenuItem(
              index: 3,
              title: "Orders",
              icon: Icons.shopping_cart,
              children: [
                _buildSubMenuItem(title: "Order List", onTap: () {}),
              ]),
          _buildExpansionMenuItem(
              index: 4,
              title: "Courier",
              icon: Icons.local_shipping,
              children: [
                _buildSubMenuItem(title: "Dashboard Courier", onTap: () {}),
                _buildSubMenuItem(title: "Courier List", onTap: () {}),
                _buildSubMenuItem(title: "Driver", onTap: () {}),
                _buildSubMenuItem(title: "Report", onTap: () {}),
              ]),
          _buildDivider(),
          _buildExpansionMenuItem(
              index: 5,
              title: "Offers",
              icon: Icons.local_offer,
              children: [
                _buildSubMenuItem(title: "Home Slider", onTap: () {}),
                _buildSubMenuItem(title: "Coupon Code", onTap: () {}),
                _buildSubMenuItem(title: "Coupon Applied", onTap: () {}),
                _buildSubMenuItem(title: "Offer List", onTap: () {}),
                _buildSubMenuItem(title: "Architect", onTap: () {}),
              ]),
          _buildExpansionMenuItem(
              index: 6,
              title: "Notifications",
              icon: Icons.notifications,
              children: [
                _buildSubMenuItem(title: "Alerts", onTap: () {}),
                _buildSubMenuItem(title: "Notifications", onTap: () {}),
              ]),
          _buildDivider(),
          _buildExpansionMenuItem(
              index: 7,
              title: "Reporting",
              icon: Icons.bar_chart,
              children: [
                _buildSubMenuItem(title: "Sales Reports", onTap: () {}),
                _buildSubMenuItem(title: "Inventory Reports", onTap: () {}),
                _buildSubMenuItem(title: "Traffic Analytics", onTap: () {}),
              ]),
          _buildDivider(),
          _buildMenuItem(
              title: "Review", icon: Icons.rate_review, onTap: () {}),
          _buildMenuItem(
              title: "Support Ticket", icon: Icons.support_agent, onTap: () {}),
          _buildDivider(),
          _buildMenuItem(title: "Utility", icon: Icons.build, onTap: () {}),
          _buildExpansionMenuItem(
              index: 8,
              title: "Settings",
              icon: Icons.settings,
              children: [
                _buildSubMenuItem(title: "New User", onTap: () {}),
                _buildSubMenuItem(title: "User Role", onTap: () {}),
                _buildSubMenuItem(title: "User Permission", onTap: () {}),
              ]),
          _buildMenuItem(
              title: "Menu Setting", icon: Icons.menu_open, onTap: () {}),
          _buildMenuItem(
              title: "Logout", icon: Icons.exit_to_app, onTap: () {}),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Icon(icon, color: Colors.white, size: 24),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExpansionMenuItem({
    required int index,
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent, // Disable the divider
        ),
        child: ExpansionTile(
          initiallyExpanded: _isExpanded[index],
          leading: Icon(icon, color: Colors.white),
          title: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          onExpansionChanged: (isExpanded) {
            setState(() {
              _isExpanded[index] = isExpanded;
            });
          },
          collapsedBackgroundColor:
              Colors.transparent, // No background when collapsed
          backgroundColor: Colors.transparent, // No background when expanded
          children: children,
        ),
      ),
    );
  }

  Widget _buildSubMenuItem({
    required String title,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4, horizontal: Get.width * 0.03),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: const Color(0xFF2C3E50),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      color: Colors.white54,
      thickness: 0.5,
      height: 20,
    );
  }
}
