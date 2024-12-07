import 'package:ev_homes/components/loading/loading_square.dart';
import 'package:ev_homes/core/models/channel_partner.dart';
import 'package:ev_homes/core/providers/setting_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ManageChannelPartners extends StatefulWidget {
  const ManageChannelPartners({super.key});

  @override
  State<ManageChannelPartners> createState() => _ManageChannelPartnersState();
}

class _ManageChannelPartnersState extends State<ManageChannelPartners> {
  String searchQuery = '';
  bool isLoading = false;
  // List<List<T>> splitList<T>(List<T> list, int chunkSize) {
  //   List<List<T>> chunks = [];
  //   for (var i = 0; i < list.length; i += chunkSize) {
  //     chunks.add(list.sublist(
  //       i,
  //       i + chunkSize > list.length ? list.length : i + chunkSize,
  //     ));
  //   }
  //   return chunks;
  // }

  Future<void> onRefresh() async {
    final settingProvider = Provider.of<SettingProvider>(
      context,
      listen: false,
    );
    try {
      setState(() {
        isLoading = true;
      });
      await settingProvider.getChannelPartner();
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
    onRefresh();
  }

  @override
  Widget build(BuildContext context) {
    final settingProvider = Provider.of<SettingProvider>(context);
    final channelPartner = settingProvider.channelPartner;
    final filteredCp = channelPartner.where((cp) {
      final nameLower =
          (cp.firmName ?? '').toLowerCase(); // Safely handle null values
      final searchLower =
          searchQuery.toLowerCase(); // No need for null check here
      // Include all channel partners if the search query is empty
      if (searchQuery.isEmpty) {
        return true; // Return all channel partners when search query is empty
      }
      // Otherwise, check if the firmName contains the search query
      return nameLower.contains(searchLower);
    }).toList();

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text('Manage Channel Partners'),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              GoRouter.of(context).push("/add-channel-partner");
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
                    labelText: 'Search Channel Partner',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    prefixIcon: const Icon(Icons.search),
                  ),
                ),

                const SizedBox(height: 16),
                // List of channel partners
                Expanded(
                  child: filteredCp.isEmpty
                      ? const Center(
                          child: Text('No channel partner found.'),
                        )
                      : RefreshIndicator(
                          onRefresh: onRefresh,
                          child: ListView.builder(
                            itemCount: filteredCp.length,
                            itemBuilder: (context, index) {
                              final cp = filteredCp[index];

                              return ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 4, vertical: 5),
                                leading: CircleAvatar(
                                  backgroundColor: Colors.blue,
                                  child: Text(
                                    cp.firstName?.isNotEmpty == true
                                        ? cp.firstName![0].toUpperCase()
                                        : '?', // Use '?' if firstName is empty
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                                title: Text(
                                  "${cp.firstName ?? ''} ${cp.lastName ?? ''}"
                                      .trim(),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "(${cp.firmName ?? ''})", // Firm name in parentheses
                                    ),
                                    const SizedBox(
                                        height:
                                            4), // Space between firmName and email
                                    Text(cp.email ?? ''), // Email
                                  ],
                                ),
                                trailing: PopupMenuButton<String>(
                                  onSelected: (value) {
                                    if (value == 'Edit') {
                                      GoRouter.of(context).push(
                                        '/edit-channel-partner',
                                        extra: cp,
                                      );
                                    }
                                    if (value == 'Delete') {
                                      _deleteChannelPartner(
                                          cp); // Call delete function
                                    }
                                  },
                                  itemBuilder: (context) => [
                                    const PopupMenuItem(
                                      value: 'Edit',
                                      child: Text('Edit'),
                                    ),
                                    const PopupMenuItem(
                                      value: 'Delete',
                                      child: Text(
                                        'Delete',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ],
                                  icon: const Icon(Icons.more_vert_rounded),
                                ),
                                onTap: () {
                                  // Handle tap on channel partner
                                },
                              );
                            },
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
        if (isLoading) const LoadingSquare(),
      ],
    );
  }

  void _deleteChannelPartner(ChannelPartner cp) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Channel Partner?'),
        content:
            const Text('Are you sure you want to delete this Channel Partner?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final settingProvider = Provider.of<SettingProvider>(
                context,
                listen: false,
              );
              // Delete the employee using SettingProvider
              await settingProvider.deleteChannelPartner(cp.id!);
              // Handle the delete logic here
              if (context.mounted) {
                Navigator.of(context).pop();
              }
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
