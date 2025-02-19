import 'package:flutter/material.dart';
import 'package:mins/screens/login.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  // Function to get the selected page content
  Widget getSelectedScreen() {
    switch (_selectedIndex) {
      case 0:
        return buildDashboard(); // Dashboard screen
      case 1:
        return buildUploadReport();
      case 2:
        return const Center(child: Text("Add User", style: TextStyle(fontSize: 22)));
      default:
        return buildDashboard();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blue,
        actions: [
          buildTopBar(),
        ],
      ),
      body: Row(
        children: [
          Expanded(
            flex: 2,
            child: DashboardDrawer(
              selectedIndex: _selectedIndex,
              onItemSelected: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          ),
          Expanded(
            flex: 8,
            child: getSelectedScreen(),
          ),
        ],
      ),
    );
  }
}


Widget buildTopBar() {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
    color: Colors.blue,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
       
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
             Tooltip(

              message: 'Contact Walter on +263782926585',
              child: Image.asset('assets/images/deuces.png',color: Colors.white,)),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.end,
            //   children: [
            //     IconButton(icon: const Icon(Icons.nightlight_round, color: Colors.white), onPressed: () {}),
            //     IconButton(icon: const Icon(Icons.language, color: Colors.white), onPressed: () {}),
            //   ],
            // )
          ],
        ),
      ],
    ),
  );
}
Widget buildUploadReport(){
  return Padding(
    padding: EdgeInsets.all(8)
    
    );
}
Widget buildDashboard() {
  return Padding(
    padding: const EdgeInsets.all(2),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(2),
          child: Text(
            'Dashboard',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
        Wrap(
          spacing: 16, // Horizontal spacing
          runSpacing: 16, // Vertical spacing
          children: const [
            DashboardCard(title: 'Wednesday', subtitle: 'Recently Added', icon: Icons.book, color: Colors.teal),
            DashboardCard(title: '16', subtitle: 'Reports', icon: Icons.show_chart, color: Colors.green ),
            DashboardCard(title: '44', subtitle: 'Total Users', icon: Icons.person_add, color: Colors.amber),
            DashboardCard(title: '0', subtitle: 'Pending Issues', icon: Icons.error, color: Colors.red),
          ],
        ),
        const SizedBox(height: 20),
        const Text('Recent Orders', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        buildRecentOrdersTable(),
      ],
    ),
  );
}



class DashboardCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;

  const DashboardCard({super.key, required this.title, required this.subtitle, required this.icon, required this.color});

  @override
  State<DashboardCard> createState() => _DashboardCardState();
}

class _DashboardCardState extends State<DashboardCard> {
  int _selectedIndex=0;
  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
  tween: Tween(begin: 5, end: 20), // Glow range
  duration: Duration(seconds: 1),
  curve: Curves.easeInOut,
  builder: (context, glow, child) {
    return SizedBox(
      width: 280,
      height: 160,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: widget.color.withOpacity(0.6),
              blurRadius: glow,
              spreadRadius: glow / 4,
            ),
          ],
        ),
        child: child,
      ),
    );
  },
  child: Card(
    
    color: widget.color,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(widget.icon, size: 40, color: Colors.white),
          const SizedBox(height: 10),
          Text(widget.title, style: const TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(widget.subtitle, style: const TextStyle(fontSize: 16, color: Colors.white)),
        ],
      ),
    ),
  ),
);

  }
}
Widget buildRecentOrdersTable() {
  return SizedBox(
    width: double.infinity, // Make sure the table takes up the available width
    child: SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: DataTable(
        headingRowColor: MaterialStateProperty.all(Colors.blue),
        headingRowHeight: 30,
        columns: const [
          DataColumn(label: Text('No.', style: TextStyle(color: Colors.white))),
          DataColumn(label: Text('Date', style: TextStyle(color: Colors.white))),
          DataColumn(label: Text('Report Name', style: TextStyle(color: Colors.white))),
          DataColumn(label: Text('Uploaded By', style: TextStyle(color: Colors.white))),
          DataColumn(label: Text('Actions', style: TextStyle(color: Colors.white))),
        ],
        rows: List.generate(5, (index) {
          return DataRow(cells: [
            DataCell(Text('#${index + 1}')),
            DataCell(const Text('2022-06-30')),
            DataCell(Text('Item ${index + 1}')),
            DataCell(Text((4000 + index * 1000).toString())),
            DataCell(
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove_red_eye_outlined, color: Colors.black, size: 15),
                    onPressed: () {
                      // Edit action
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.download_outlined, color: Colors.black, size: 15),
                    onPressed: () {
                      // Delete action
                    },
                  ),
                ],
              ),
            ),
          ]);
        }),
      ),
    ),
  );
}

class DashboardDrawer extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const DashboardDrawer({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  Widget buildListTile(int index, IconData icon, String title) {
    bool isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () => onItemSelected(index), // Call parent function
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: isSelected ? Border.all(color: Colors.white, width: 1.5) : null,
        ),
        child: ListTile(
          leading: Icon(icon, color: Colors.white),
          title: Text(title, style: const TextStyle(color: Colors.white)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 67, 67, 67),
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Color.fromARGB(255, 67, 67, 67)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Info
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage('assets/images/user.jpg'),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Admin Deuce',
                          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'admin@deuces.com',
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Account & Logout Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                       onTap: () {
    // Handle logout action
    print("Logout clicked");
  },
                      child: Row(
                        children: const [
                          Icon(Icons.person, color: Colors.white, size: 20),
                          SizedBox(width: 5),
                          Text('Account', style: TextStyle(color: Colors.white, fontSize: 14)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                  InkWell(
  onTap: () {
   Navigator.push(context,MaterialPageRoute(builder: (context)=>loginScreen ()));
  },
  child: Row(
    children: const [
      Icon(Icons.logout, color: Colors.white70, size: 20),
      SizedBox(width: 5),
      Text('Log Out', style: TextStyle(color: Colors.white70, fontSize: 12)),
    ],
  ),
)

                  ],
                ),
              ],
            ),
          ),

          // Navigation List
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                buildListTile(0, Icons.dashboard, 'Dashboard'),
                buildListTile(1, Icons.list, 'Upload Report'),
                buildListTile(2, Icons.widgets, 'Add User'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
