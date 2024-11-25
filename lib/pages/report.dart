import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  final _formKey = GlobalKey<FormState>();
  final _searchController = TextEditingController();
  final _currencyFormat = NumberFormat.currency(
    locale: 'id_ID', 
    symbol: 'Rp ',
    decimalDigits: 0,
  );
  
  List<dynamic> _clients = [];

  String _formatCurrency(String value) {
    if (value.isEmpty) return '';
    value = value.replaceAll(RegExp(r'[^\d]'), '');
    final number = int.tryParse(value) ?? 0;
    return NumberFormat('#,###', 'id_ID').format(number);
  }

  @override
  void initState() {
    super.initState();
    _fetchClients();
  }

  Future<void> _fetchClients() async {
    try {
      final url = Uri.parse('$baseUrl/api/clients');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _clients = data['data'];
        });
      } else {
        throw Exception('Failed to fetch clients');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _updateClient(Map<String, dynamic> updatedClient) async {
    try {
      final url = Uri.parse('$baseUrl/api/clients/${updatedClient['id_client']}');
      final response = await http.put(
        url,
        body: json.encode({
          'username': updatedClient['username'],
          'email': updatedClient['email'],
          'nama_project': updatedClient['nama_project'],
          'detail_project': updatedClient['detail_project'],
          'total_harga': updatedClient['total_harga'],
          'harga_dibayar': updatedClient['harga_dibayar'],
          'status_pembayaran': updatedClient['status_pembayaran'],
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        _fetchClients();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Client updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to update client');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating client: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _deleteClient(String id) async {
    try {
      final url = Uri.parse('$baseUrl/api/clients/$id');
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        _fetchClients();
      } else {
        throw Exception('Failed to delete client');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting client: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _createClient(Map<String, dynamic> newClient) async {
    try {
      final url = Uri.parse('$baseUrl/api/clients');
      final response = await http.post(
        url,
        body: json.encode(newClient),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 201) {
        _fetchClients();
      } else {
        throw Exception('Failed to create client');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error creating client: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFF4C2A86),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Client Analytics',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline, color: Colors.white, size: 20),
                    onPressed: () => _showAddPaymentDialog(context),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search clients...',
                hintStyle: const TextStyle(fontSize: 12),
                prefixIcon: const Icon(Icons.search, color: Color(0xFF4C2A86), size: 18),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemCount: _clients.length,
              itemBuilder: (context, index) {
                final client = _clients[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: const BoxDecoration(
                          color: Color(0xFF4C2A86),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  client['username'] ?? 'No Username',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  client['nama_project'],
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                client['status_pembayaran'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildModernInfoRow(
                              'Total Price',
                              _currencyFormat.format(double.parse(client['total_harga'].toString())),
                              Icons.monetization_on_outlined,
                            ),
                            _buildModernInfoRow(
                              'Paid Amount',
                              _currencyFormat.format(double.parse(client['harga_dibayar'].toString())),
                              Icons.payments_outlined,
                            ),
                            _buildModernInfoRow(
                              'Remaining',
                              _currencyFormat.format(double.parse(client['total_harga'].toString()) - double.parse(client['harga_dibayar'].toString())),
                              Icons.account_balance_wallet_outlined,
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Project Details',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF4C2A86),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              client['detail_project'] ?? 'No description available',
                              style: const TextStyle(fontSize: 12),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    icon: const Icon(Icons.edit_outlined, size: 16),
                                    label: const Text('Edit', style: TextStyle(fontSize: 12)),
                                    onPressed: () => _showEditDialog(context, client),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF4C2A86),
                                      padding: const EdgeInsets.symmetric(vertical: 8),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: ElevatedButton.icon(
                                    icon: const Icon(Icons.delete_outline, size: 16),
                                    label: const Text('Delete', style: TextStyle(fontSize: 12)),
                                    onPressed: () => _showDeleteConfirmation(context, client['id_client'].toString()),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      padding: const EdgeInsets.symmetric(vertical: 8),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernInfoRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: const Color(0xFF4C2A86).withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF4C2A86),
              size: 16,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 10,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAddPaymentDialog(BuildContext context) {
    final _amountController = TextEditingController();
    final _notesController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Payment', style: TextStyle(fontSize: 16)),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  labelStyle: TextStyle(fontSize: 12),
                ),
                style: const TextStyle(fontSize: 12),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  _amountController.value = TextEditingValue(
                    text: _formatCurrency(value),
                    selection: TextSelection.collapsed(offset: _formatCurrency(value).length),
                  );
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter amount';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Notes',
                  labelStyle: TextStyle(fontSize: 12),
                ),
                style: const TextStyle(fontSize: 12),
                maxLines: 2,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(fontSize: 12)),
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                final newClient = {
                  'amount': double.parse(_amountController.text.replaceAll(RegExp(r'[^\d]'), '')),
                  'notes': _notesController.text,
                };
                _createClient(newClient);
                Navigator.pop(context);
              }
            },
            child: const Text('Save', style: TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, Map<String, dynamic> client) {
    final _editFormKey = GlobalKey<FormState>();
    final _usernameController = TextEditingController(text: client['username']);
    final _emailController = TextEditingController(text: client['email']);
    final _projectNameController = TextEditingController(text: client['nama_project']);
    final _totalPriceController = TextEditingController(text: _formatCurrency(client['total_harga'].toString()));
    final _paidAmountController = TextEditingController(text: _formatCurrency(client['harga_dibayar'].toString()));
    final _projectDetailsController = TextEditingController(text: client['detail_project']);
    String _selectedStatus = client['status_pembayaran'];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Client', style: TextStyle(fontSize: 16)),
        content: Form(
          key: _editFormKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    labelStyle: TextStyle(fontSize: 12),
                  ),
                  style: const TextStyle(fontSize: 12),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter username';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(fontSize: 12),
                  ),
                  style: const TextStyle(fontSize: 12),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter email';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _projectNameController,
                  decoration: const InputDecoration(
                    labelText: 'Project Name',
                    labelStyle: TextStyle(fontSize: 12),
                  ),
                  style: const TextStyle(fontSize: 12),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter project name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _totalPriceController,
                  decoration: const InputDecoration(
                    labelText: 'Total Price',
                    labelStyle: TextStyle(fontSize: 12),
                  ),
                  style: const TextStyle(fontSize: 12),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    _totalPriceController.value = TextEditingValue(
                      text: _formatCurrency(value),
                      selection: TextSelection.collapsed(offset: _formatCurrency(value).length),
                    );
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter total price';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _paidAmountController,
                  decoration: const InputDecoration(
                    labelText: 'Paid Amount',
                    labelStyle: TextStyle(fontSize: 12),
                  ),
                  style: const TextStyle(fontSize: 12),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    _paidAmountController.value = TextEditingValue(
                      text: _formatCurrency(value),
                      selection: TextSelection.collapsed(offset: _formatCurrency(value).length),
                    );
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter paid amount';
                    }
                    return null;
                  },
                ),
                DropdownButtonFormField<String>(
                  value: _selectedStatus,
                  decoration: const InputDecoration(
                    labelText: 'Payment Status', 
                    labelStyle: TextStyle(fontSize: 12),
                  ),
                  style: const TextStyle(fontSize: 12, color: Colors.black),
                  items: const [
                    DropdownMenuItem(
                      value: 'pending',
                      child: Text('pending'),
                    ),
                    DropdownMenuItem(
                      value: 'partial',
                      child: Text('partial'),
                    ),
                    DropdownMenuItem(
                      value: 'paid',
                      child: Text('paid'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      _selectedStatus = value;
                    }
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a payment status';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _projectDetailsController,
                  decoration: const InputDecoration(
                    labelText: 'Project Details',
                    labelStyle: TextStyle(fontSize: 12),
                  ),
                  style: const TextStyle(fontSize: 12),
                  maxLines: 3,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(fontSize: 12)),
          ),
          ElevatedButton(
            onPressed: () {
              if (_editFormKey.currentState!.validate()) {
                final updatedClient = {
                  'id_client': client['id_client'],
                  'username': _usernameController.text,
                  'email': _emailController.text,
                  'nama_project': _projectNameController.text,
                  'total_harga': double.parse(_totalPriceController.text.replaceAll(RegExp(r'[^\d]'), '')),
                  'harga_dibayar': double.parse(_paidAmountController.text.replaceAll(RegExp(r'[^\d]'), '')),
                  'status_pembayaran': _selectedStatus,
                  'detail_project': _projectDetailsController.text,
                };
                _updateClient(updatedClient);
                Navigator.pop(context);
              }
            },
            child: const Text('Save', style: TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Client', style: TextStyle(fontSize: 16)),
        content: const Text('Are you sure you want to delete this client?', style: TextStyle(fontSize: 12)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(fontSize: 12)),
          ),
          ElevatedButton(
            onPressed: () {
              _deleteClient(id);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete', style: TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }
}
