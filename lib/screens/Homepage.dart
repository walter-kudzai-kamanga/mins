import 'package:flutter/material.dart';

void main() {
  runApp(const AdminDashboardApp());
}

class AdminDashboardApp extends StatelessWidget {
  const AdminDashboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Web Admin',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DashboardDrawer(),
      body: Row(
        children: [
          const Expanded(flex: 2, child: DashboardDrawer()),
          Expanded(
            flex: 8,
            child: Column(
              children: [
                buildTopBar(),
                Expanded(child: buildDashboard()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget buildTopBar() {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    color: Colors.blue,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Dashboard', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
        Row(
          children: [
            IconButton(icon: const Icon(Icons.nightlight_round, color: Colors.white), onPressed: () {}),
            IconButton(icon: const Icon(Icons.language, color: Colors.white), onPressed: () {}),
          ],
        )
      ],
    ),
  );
}

Widget buildDashboard() {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GridView.count(
          crossAxisCount: 4,
          shrinkWrap: true,
          crossAxisSpacing: 16,
          childAspectRatio: 1,
          mainAxisSpacing: 16,
          children: const [
            DashboardCard(title: '150', subtitle: 'Recently Added', icon: Icons.shopping_cart, color: Colors.teal),
            DashboardCard(title: '+12%', subtitle: 'Today Sales', icon: Icons.show_chart, color: Colors.green),
            DashboardCard(title: '44', subtitle: 'New Users', icon: Icons.person_add, color: Colors.amber),
            DashboardCard(title: '0', subtitle: 'Pending Issues', icon: Icons.error, color: Colors.red),
          ],
        ),
        const SizedBox(height: 20),
        const Text('Recent Orders', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Expanded(child: buildRecentOrdersTable()),
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.remove_red_eye),
            label: const Text('View All'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
          ),
        ),
      ],
    ),
  );
}

class DashboardCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;

  const DashboardCard({super.key, required this.title, required this.subtitle, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.white),
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(subtitle, style: const TextStyle(fontSize: 16, color: Colors.white)),
          ],
        ),
      ),
    );
  }
}

Widget buildRecentOrdersTable() {
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: DataTable(
      headingRowColor: MaterialStateProperty.all(Colors.blue),
      columns: const [
        DataColumn(label: Text('No.', style: TextStyle(color: Colors.white))),
        DataColumn(label: Text('Date', style: TextStyle(color: Colors.white))),
        DataColumn(label: Text('Item', style: TextStyle(color: Colors.white))),
        DataColumn(label: Text('Price', style: TextStyle(color: Colors.white))),
      ],
      rows: List.generate(5, (index) {
        return DataRow(cells: [
          DataCell(Text('#${index + 1}')),
          DataCell(const Text('2022-06-30')),
          DataCell(Text('Item ${index + 1}')),
          DataCell(Text((4000 + index * 1000).toString())),
        ]);
      }),
    ),
  );
}

class DashboardDrawer extends StatelessWidget {
  const DashboardDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: const Text('Admin ABC'),
            accountEmail: const Text('admin@example.com'),
            currentAccountPicture: const CircleAvatar(
              backgroundImage: AssetImage('assets/profile.jpg'),
            ),
            decoration: const BoxDecoration(color: Colors.blue),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: const [
                ListTile(leading: Icon(Icons.dashboard), title: Text('Dashboard')),
                ListTile(leading: Icon(Icons.list), title: Text('Form')),
                ListTile(leading: Icon(Icons.widgets), title: Text('UI Elements')),
                ListTile(leading: Icon(Icons.pages), title: Text('Pages')),
                ListTile(leading: Icon(Icons.web), title: Text('iFrame Demo')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
