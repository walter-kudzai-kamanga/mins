import 'dart:typed_data';

import 'package:cool_alert/cool_alert.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mins/screens/login.dart';

import '../auths/databaseHelper.dart';
import '../auths/userModel.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  String? _fileName;
  Uint8List? _fileBytes;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  String? selectedRole;
  List<User> users=[];
  void resetForm() {
    nameController.clear();
    emailController.clear();
    phoneController.clear();
    addressController.clear();
    ageController.clear();
    setState(() {
      selectedRole = null;
    });
  }
  @override
  void initState() {
    super.initState();
    _loadUsers(); // Load users when the widget initializes
  }
  Future<void> _loadUsers() async {
    List<User> loadedUsers = await DatabaseHelper().getUsers();
    setState(() {
      users = loadedUsers;
    });
  }
  void saveData() async {
    if (_formKey.currentState!.validate()) {
      User newUser = User(
        name: nameController.text,
        email: emailController.text,
        phone: phoneController.text,
        address: addressController.text,
        age: ageController.text,
        role: selectedRole,
      );

    int result= await DatabaseHelper().saveUser(newUser);
     if(result !=0){
       ScaffoldMessenger.of(context).showSnackBar(
         const SnackBar(
           content: Text('User saved successfully!'),
           duration: Duration(seconds: 2), // Adjust duration as needed
         ),
       );
       _loadUsers();
       resetForm();
     }else{
       ScaffoldMessenger.of(context).showSnackBar(
         const SnackBar(
           content: Text('Failed to save user.'),
           duration: Duration(seconds: 2),
         ),
       );
     }
    }
  }



  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      allowMultiple: false,
    );

    if (result != null) {
      setState(() {
        _fileName = result.files.single.name;
        _fileBytes = result.files.single.bytes; // Web returns file as bytes
      });

      // Example: Convert bytes to a file (for uploads)
      if (_fileBytes != null) {
        print("File size: ${_fileBytes!.length} bytes");
      }
    }
  }

  // Function to get the selected page content
  Widget getSelectedScreen() {
    switch (_selectedIndex) {
      case 0:
        return buildDashboard(); // Dashboard screen
      case 1:
        return buildUploadReport();
      case 2:
        return buildAddUsers();
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

  Widget buildAddUsers() {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: Row(
        children: [
          // Table Section
          Expanded(
            flex: 3,
            child: SizedBox(
              height: double.infinity,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                padding: EdgeInsets.all(2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('User Registration',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold)),
                    SizedBox(height: 15),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        return Form(
                          key: _formKey,
                          child: Wrap(
                            spacing: 16,
                            runSpacing: 16,
                            children: [
                              SizedBox(
                                width: constraints.maxWidth > 600
                                    ? 300
                                    : double.infinity,
                                child: TextFormField(
                                  controller: nameController,
                                  decoration: InputDecoration(
                                      labelText: 'Name',
                                      border: OutlineInputBorder()),
                                  validator: (value) =>
                                      value!.isEmpty ? 'Enter a name' : null,
                                ),
                              ),
                              SizedBox(
                                width: constraints.maxWidth > 600
                                    ? 300
                                    : double.infinity,
                                child: TextFormField(
                                  controller: emailController,
                                  decoration: InputDecoration(
                                      labelText: 'Email',
                                      border: OutlineInputBorder()),
                                  validator: (value) =>
                                      value!.isEmpty ? 'Enter an email' : null,
                                ),
                              ),
                              SizedBox(
                                width: constraints.maxWidth > 600
                                    ? 300
                                    : double.infinity,
                                child: TextFormField(
                                  controller: phoneController,
                                  decoration: InputDecoration(
                                      labelText: 'Phone',
                                      border: OutlineInputBorder()),
                                  validator: (value) => value!.isEmpty
                                      ? 'Enter a phone number'
                                      : null,
                                ),
                              ),
                              SizedBox(
                                width: constraints.maxWidth > 600
                                    ? 300
                                    : double.infinity,
                                child: TextFormField(
                                  controller: addressController,
                                  decoration: InputDecoration(
                                      labelText: 'Address',
                                      border: OutlineInputBorder()),
                                  validator: (value) => value!.isEmpty
                                      ? 'Enter an address'
                                      : null,
                                ),
                              ),
                              SizedBox(
                                width: constraints.maxWidth > 600
                                    ? 300
                                    : double.infinity,
                                child: TextFormField(
                                  controller: ageController,
                                  decoration: InputDecoration(
                                      labelText: 'Age',
                                      border: OutlineInputBorder()),
                                  validator: (value) =>
                                      value!.isEmpty ? 'Enter age' : null,
                                ),
                              ),
                              SizedBox(
                                width: constraints.maxWidth > 600
                                    ? 300
                                    : double.infinity,
                                child: DropdownButtonFormField<String>(
                                  value: selectedRole,
                                  decoration: InputDecoration(
                                      labelText: 'Role',
                                      border: OutlineInputBorder()),
                                  items: ['Admin', 'User', 'Guest']
                                      .map((role) => DropdownMenuItem(
                                          value: role, child: Text(role)))
                                      .toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      selectedRole = value;
                                    });
                                  },
                                  validator: (value) =>
                                      value == null ? 'Select a role' : null,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                            onPressed: resetForm,
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Color.fromARGB(255, 5, 38, 95),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                )),
                            child: Text('Reset',
                                style: TextStyle(color: Colors.white))),
                        ElevatedButton(
                            onPressed: (){
                            saveData();
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Color.fromARGB(255, 5, 38, 95),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                )),
                            child: Text(
                              'Save',
                              style: TextStyle(color: Colors.white),
                            )),
                      ],
                    ),
                    SizedBox(height: 20),
                    Text('Registered Users',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: DataTable(
                        headingRowColor: WidgetStateProperty.all(Colors.blue),
                        headingRowHeight: 30,
                        columns: const [
                          DataColumn(
                              label: Text('No.',
                                  style: TextStyle(color: Colors.white))),
                          DataColumn(
                              label: Text('Name',
                                  style: TextStyle(color: Colors.white))),
                          DataColumn(
                              label: Text('Email',
                                  style: TextStyle(color: Colors.white))),
                          DataColumn(
                              label: Text('Phone',
                                  style: TextStyle(color: Colors.white))),
                          DataColumn(
                              label: Text('Role',
                                  style: TextStyle(color: Colors.white))),
                        ],
                        rows: List.generate(5, (index) {
                          return DataRow(cells: [
                            DataCell(Text('#${index + 1}')),
                            DataCell(Text('User ${index + 1}')),
                            DataCell(Text('user${index + 1}@example.com')),
                            DataCell(Text('123-456-789${index}')),
                            DataCell(Text(index % 2 == 0 ? 'Admin' : 'User')),
                          ]);
                        }),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 16), // Spacing between the Table and Card

          // Card Section
          Expanded(
            flex: 1,
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Top Bar Header
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: const Text(
                        "Admin Users",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // First DataTable with 3 columns
                    SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: DataTable(
                        headingRowColor:
                            WidgetStateProperty.all(Colors.grey[300]),
                        headingRowHeight: 30,
                        columns: [
                          DataColumn(label: Container(child: Text("Id"))),
                          DataColumn(label: Text("Name")),
                          DataColumn(label: Text("Surname")),
                        ],
                        rows: List.generate(
                          3,
                          (index) => DataRow(
                            cells: [
                              DataCell(Text("1")),
                              DataCell(Text(" John")),
                              DataCell(Text("Zimuto")),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Second Bar (Header)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: const Text(
                        "General Users",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Second DataTable with 3 columns
                    SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: DataTable(
                        headingRowColor:
                            MaterialStateProperty.all(Colors.grey[300]),
                        headingRowHeight: 30,
                        columns: const [
                          DataColumn(label: Text("Id")),
                          DataColumn(label: Text("Name")),
                          DataColumn(label: Text("Surname")),
                        ],
                        rows: List.generate(
                          3,
                          (index) => DataRow(
                            cells: [
                              DataCell(Text("1")),
                              DataCell(Text("kuku")),
                              DataCell(Text("Deuce")),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildUploadReport() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          const SizedBox(height: 20),
          Expanded(
            flex: 3,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: DataTable(
                headingRowColor: WidgetStateProperty.all(Colors.blue),
                headingRowHeight: 30,
                columns: const [
                  DataColumn(
                      label:
                          Text('No.', style: TextStyle(color: Colors.white))),
                  DataColumn(
                      label:
                          Text('Date', style: TextStyle(color: Colors.white))),
                  DataColumn(
                      label: Text('Report Name',
                          style: TextStyle(color: Colors.white))),
                  DataColumn(
                      label: Text('Actions',
                          style: TextStyle(color: Colors.white))),
                ],
                rows: List.generate(5, (index) {
                  return DataRow(cells: [
                    DataCell(Text('#${index + 1}')),
                    DataCell(Text('2022-06-30')),
                    DataCell(Text('Item ${index + 1}')),
                    DataCell(
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_red_eye_outlined,
                                color: Colors.black, size: 15),
                            onPressed: () {
                              // Edit action
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.download_outlined,
                                color: Colors.black, size: 15),
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
          ),
          const SizedBox(width: 16), // Spacing between the Table and Card

          // Card Section
          Expanded(
            flex: 1,
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Top Bar (Header)
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.blue, // Background color for the top bar
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Upload Report', // Title in the top bar
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.info_outline,
                                color: Colors.white), // Optional icon
                            onPressed: () {
                              // Action for the icon button
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                        height: 20), // Space between top bar and content

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(
                          16), // Padding inside the container
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 184, 184, 184),
                        borderRadius: BorderRadius.circular(
                            8), // Rounded corners (optional)
                      ),
                      child: _fileName != null
                          ? Text(" $_fileName",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold))
                          : Column(
                              children: [
                                Icon(
                                  Icons.upload,
                                  size: 50,
                                  color: Colors.blue,
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  'Upload Report',
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Visibility(
                      visible: _fileName != null,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          backgroundColor: const Color.fromARGB(255, 2, 19, 33),
                        ),
                        onPressed: () {
                          CoolAlert.show(
                            context: context,
                            type: CoolAlertType.success,
                            width: 250,
                            text: "Publication successful!",
                          );
                        },
                        child: const Text(
                          "Save",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            backgroundColor:
                                const Color.fromARGB(255, 2, 19, 33)),
                        onPressed: pickFile,
                        child: const Text(
                          "Select Report",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
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
                child: Image.asset(
                  'assets/images/deuces.png',
                  color: Colors.white,
                )),
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
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
        Wrap(
          spacing: 16, // Horizontal spacing
          runSpacing: 16, // Vertical spacing
          children: const [
            DashboardCard(
                title: 'Wednesday',
                subtitle: 'Recently Added',
                icon: Icons.book,
                color: Colors.teal),
            DashboardCard(
                title: '16',
                subtitle: 'Reports',
                icon: Icons.show_chart,
                color: Colors.green),
            DashboardCard(
                title: '44',
                subtitle: 'Total Users',
                icon: Icons.person_add,
                color: Colors.amber),
            DashboardCard(
                title: '0',
                subtitle: 'Pending Issues',
                icon: Icons.error,
                color: Colors.red),
          ],
        ),
        const SizedBox(height: 20),
        const Text('Recent Orders',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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

  const DashboardCard(
      {super.key,
      required this.title,
      required this.subtitle,
      required this.icon,
      required this.color});

  @override
  State<DashboardCard> createState() => _DashboardCardState();
}

class _DashboardCardState extends State<DashboardCard> {
  int _selectedIndex = 0;
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
              Text(widget.title,
                  style: const TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(widget.subtitle,
                  style: const TextStyle(fontSize: 16, color: Colors.white)),
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
          DataColumn(
              label: Text('Date', style: TextStyle(color: Colors.white))),
          DataColumn(
              label:
                  Text('Report Name', style: TextStyle(color: Colors.white))),
          DataColumn(
              label:
                  Text('Uploaded By', style: TextStyle(color: Colors.white))),
          DataColumn(
              label: Text('Actions', style: TextStyle(color: Colors.white))),
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
                    icon: const Icon(Icons.remove_red_eye_outlined,
                        color: Colors.black, size: 15),
                    onPressed: () {
                      // Edit action
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.download_outlined,
                        color: Colors.black, size: 15),
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
          color:
              isSelected ? Colors.white.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border:
              isSelected ? Border.all(color: Colors.white, width: 1.5) : null,
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
            decoration:
                const BoxDecoration(color: Color.fromARGB(255, 67, 67, 67)),
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
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
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
                          Text('Account',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 14)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => loginScreen()));
                      },
                      child: Row(
                        children: const [
                          Icon(Icons.logout, color: Colors.white70, size: 20),
                          SizedBox(width: 5),
                          Text('Log Out',
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 12)),
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
