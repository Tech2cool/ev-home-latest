import 'package:ev_homes/components/loading/loading_square.dart';
import 'package:ev_homes/core/models/designation.dart';
import 'package:ev_homes/core/providers/setting_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ManageDesignationPage extends StatefulWidget {
  const ManageDesignationPage({super.key});

  @override
  State<ManageDesignationPage> createState() => _ManageDesignationPageState();
}

class _ManageDesignationPageState extends State<ManageDesignationPage> {
  String searchQuery = '';
  TextEditingController nameController = TextEditingController();
  bool isLoading = false;
  Future<void> _onRefresh() async {
    final settingProvider = Provider.of<SettingProvider>(
      context,
      listen: false,
    );
    try {
      setState(() {
        isLoading = true;
      });
      await settingProvider.getDesignation();
    } catch (e) {
//
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _onRefresh();
  }

  @override
  Widget build(BuildContext context) {
    final settingProvider = Provider.of<SettingProvider>(context);
    final designations = settingProvider.designations;
    // Filter designations based on the search query
    final filteredDesignations = designations.where((designation) {
      final nameLower = designation.designation.toLowerCase();
      final searchLower = searchQuery.toLowerCase();
      return nameLower.contains(searchLower);
    }).toList();

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text('Manage Designation'),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: (BuildContext context) {
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: SingleChildScrollView(
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text("Add Designation"),
                            const SizedBox(height: 16.0),
                            TextFormField(
                              controller: nameController,
                              decoration: InputDecoration(
                                contentPadding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                labelText: 'Designation',
                                prefixIcon: const Icon(Icons.badge),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: Colors.grey.withOpacity(0.7),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: Colors.grey.withOpacity(0.4),
                                  ),
                                ),
                              ),
                              keyboardType: TextInputType.text,
                            ),
                            const SizedBox(height: 16.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red[300],
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text(
                                      "Cancel",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 30),
                                Expanded(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green[300],
                                    ),
                                    onPressed: () async {
                                      // setState(() { final settingProvider =
                                      Provider.of<SettingProvider>(
                                        context,
                                        listen: false,
                                      );
                                      setState(() {
                                        isLoading = true;
                                      });
                                      try {
                                        await settingProvider.addDesignation(
                                          nameController.text,
                                        );
                                        setState(() {
                                          isLoading = false;
                                        });
                                      } catch (e) {
                                        setState(() {
                                          isLoading = false;
                                        });
                                      }

                                      setState(() {
                                        isLoading = false;
                                      });

                                      nameController.clear();
                                      if (!context.mounted) return;
                                      Navigator.pop(context);
                                    },
                                    child: const Text(
                                      "Create Designation",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
            child: const Icon(Icons.add),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Search field
                TextField(
                  onChanged: (query) {
                    setState(() {
                      searchQuery = query;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Search Designation',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    prefixIcon: const Icon(Icons.search),
                  ),
                ),
                const SizedBox(height: 16),
                // List of designations
                Expanded(
                  child: filteredDesignations.isEmpty
                      ? const Center(
                          child: Text('No Designation found.'),
                        )
                      : RefreshIndicator(
                          onRefresh: _onRefresh,
                          child: ListView.builder(
                            itemCount: filteredDesignations.length,
                            itemBuilder: (context, index) {
                              final designation = filteredDesignations[index];
                              return ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                  vertical: 5,
                                ),
                                title: Text(designation.designation),
                                trailing: PopupMenuButton<String>(
                                  // onSelected: (value) {
                                  //   if (value == 'Edit') {
                                  //     _editDesignation(designation);
                                  //   } else if (value == 'Delete') {
                                  //     _deleteDesignation(designation);
                                  //   }
                                  // },
                                  itemBuilder: (context) => [
                                    PopupMenuItem(
                                      value: 'Edit',
                                      child: const Text('Edit'),
                                      onTap: () {
                                        _editDesignation(designation);
                                      },
                                    ),
                                    PopupMenuItem(
                                      value: 'Delete',
                                      onTap: () {
                                        _deleteDesignation(designation);
                                      },
                                      child: const Text(
                                        'Delete',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ],
                                  icon: const Icon(Icons.more_vert_rounded),
                                ),
                              );
                            },
                          ),
                        ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
        if (isLoading) const LoadingSquare()
      ],
    );
  }

  // Function to handle edit action
  void _editDesignation(Designation designation) {
    setState(() {
      nameController.text = designation.designation;
    });

    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        final settingProvider = Provider.of<SettingProvider>(
          context,
          listen: false,
        );

        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Edit Designation"),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(vertical: 16),
                      labelText: 'Designation',
                      prefixIcon: const Icon(Icons.badge),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Colors.grey.withOpacity(0.7),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Colors.grey.withOpacity(0.4),
                        ),
                      ),
                    ),
                    keyboardType: TextInputType.text,
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red[300],
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            "Cancel",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 30),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[300],
                          ),
                          onPressed: () async {
                            setState(() {
                              isLoading = true;
                            });
                            try {
                              await settingProvider.updateDesignation(
                                designation.id,
                                nameController.text,
                              );
                              setState(() {
                                isLoading = false;
                              });
                            } catch (e) {
                              setState(() {
                                isLoading = false;
                              });
                            }

                            setState(() {
                              isLoading = false;
                            });

                            if (!context.mounted) return;
                            Navigator.pop(context);
                            nameController.clear();
                          },
                          child: const Text(
                            "Update Designation",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Function to handle delete action
  void _deleteDesignation(Designation designation) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Designation'),
        content:
            const Text('Are you sure you want to delete this Designation?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final settingProvider = Provider.of<SettingProvider>(
                context,
                listen: false,
              );
              setState(() {
                isLoading = true;
              });
              try {
                await settingProvider.deleteDesignation(designation.id);
                setState(() {
                  isLoading = false;
                });
              } catch (e) {
                setState(() {
                  isLoading = false;
                });
              }
              setState(() {
                isLoading = false;
              });
              if (!context.mounted) return;
              Navigator.of(context).pop();
            },
            child: const Text(
              'Delete',
              style: TextStyle(
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
