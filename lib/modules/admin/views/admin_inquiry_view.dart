import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/admin_inquiry_controller.dart';
import '../../../shared/models/inquiry_model.dart';
import '../../../shared/models/suggestion_model.dart';

class AdminInquiryView extends GetView<AdminInquiryController> {
  const AdminInquiryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          // Header Section
          _buildHeader(),
          
          // Stats Cards
          _buildStatsCards(),
          
          // Tab Bar
          _buildTabBar(),
          
          // Content Area
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.orange),
                );
              }
              
              return controller.selectedTab.value == 'inquiries'
                  ? _buildInquiriesTab()
                  : _buildSuggestionsTab();
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Back Button
          IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.arrow_back, color: Colors.grey),
          ),
          const SizedBox(width: 16),
          
          // Title
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Customer Inquiries & Suggestions',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Manage customer communications and feedback',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          
          const Spacer(),
          
          // Refresh Button
          ElevatedButton.icon(
            onPressed: controller.refreshData,
            icon: const Icon(Icons.refresh, size: 16),
            label: const Text('Refresh'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange[700],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCards() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Obx(() => Row(
        children: [
          Expanded(
            child: _buildStatCard(
              title: 'Total Inquiries',
              value: controller.totalInquiries.value.toString(),
              icon: Icons.mail_outline,
              color: Colors.blue,
              subtitle: '${controller.unreadInquiries.value} unread',
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildStatCard(
              title: 'Total Suggestions',
              value: controller.totalSuggestions.value.toString(),
              icon: Icons.lightbulb_outline,
              color: Colors.green,
              subtitle: '${controller.pendingSuggestions.value} pending',
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildStatCard(
              title: 'Response Rate',
              value: '95%',
              icon: Icons.trending_up,
              color: Colors.orange,
              subtitle: 'Last 30 days',
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildStatCard(
              title: 'Avg Response Time',
              value: '2.5h',
              icon: Icons.schedule,
              color: Colors.purple,
              subtitle: 'This week',
            ),
          ),
        ],
      )),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 20,
                ),
              ),
              const Spacer(),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Obx(() => _buildTab('inquiries', 'Inquiries', Icons.mail_outline)),
          const SizedBox(width: 16),
          Obx(() => _buildTab('suggestions', 'Suggestions', Icons.lightbulb_outline)),
          
          const Spacer(),
          
          // Filters
          if (controller.selectedTab.value == 'inquiries')
            _buildInquiryFilters()
          else
            _buildSuggestionFilters(),
        ],
      ),
    );
  }

  Widget _buildTab(String tabKey, String title, IconData icon) {
    final isActive = controller.selectedTab.value == tabKey;
    return GestureDetector(
      onTap: () => controller.setActiveTab(tabKey),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isActive ? Colors.orange[50] : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: isActive 
              ? Border.all(color: Colors.orange[200]!)
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isActive ? Colors.orange[700] : Colors.grey[600],
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                color: isActive ? Colors.orange[700] : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInquiryFilters() {
    return Row(
      children: [
        Text(
          'Filter:',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(width: 8),
        Obx(() => DropdownButton<String>(
          value: controller.statusFilter.value,
          underline: const SizedBox(),
          items: const [
            DropdownMenuItem(value: 'all', child: Text('All')),
            DropdownMenuItem(value: 'unread', child: Text('Unread')),
            DropdownMenuItem(value: 'read', child: Text('Read')),
          ],
          onChanged: (value) => controller.setStatusFilter(value!),
        )),
      ],
    );
  }

  Widget _buildSuggestionFilters() {
    return Row(
      children: [
        Text(
          'Status:',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(width: 8),
        Obx(() => DropdownButton<String>(
          value: controller.statusFilter.value,
          underline: const SizedBox(),
          items: const [
            DropdownMenuItem(value: 'all', child: Text('All')),
            DropdownMenuItem(value: 'pending', child: Text('Pending')),
            DropdownMenuItem(value: 'in_review', child: Text('In Review')),
            DropdownMenuItem(value: 'planned', child: Text('Planned')),
            DropdownMenuItem(value: 'implemented', child: Text('Implemented')),
            DropdownMenuItem(value: 'rejected', child: Text('Rejected')),
          ],
          onChanged: (value) => controller.setStatusFilter(value!),
        )),
        
        const SizedBox(width: 16),
        
        Text(
          'Priority:',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(width: 8),
        Obx(() => DropdownButton<String>(
          value: controller.priorityFilter.value,
          underline: const SizedBox(),
          items: const [
            DropdownMenuItem(value: 'all', child: Text('All')),
            DropdownMenuItem(value: 'low', child: Text('Low')),
            DropdownMenuItem(value: 'medium', child: Text('Medium')),
            DropdownMenuItem(value: 'high', child: Text('High')),
          ],
          onChanged: (value) => controller.setPriorityFilter(value!),
        )),
      ],
    );
  }

  Widget _buildInquiriesTab() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Obx(() {
        final inquiries = controller.filteredInquiries;
        
        if (inquiries.isEmpty) {
          return _buildEmptyState(
            icon: Icons.mail_outline,
            title: 'No inquiries found',
            subtitle: 'Customer inquiries will appear here',
          );
        }
        
        return ListView.builder(
          itemCount: inquiries.length,
          itemBuilder: (context, index) {
            final inquiry = inquiries[index];
            return _buildInquiryCard(inquiry);
          },
        );
      }),
    );
  }

  Widget _buildSuggestionsTab() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Obx(() {
        final suggestions = controller.filteredSuggestions;
        
        if (suggestions.isEmpty) {
          return _buildEmptyState(
            icon: Icons.lightbulb_outline,
            title: 'No suggestions found',
            subtitle: 'Customer suggestions will appear here',
          );
        }
        
        return ListView.builder(
          itemCount: suggestions.length,
          itemBuilder: (context, index) {
            final suggestion = suggestions[index];
            return _buildSuggestionCard(suggestion);
          },
        );
      }),
    );
  }

  Widget _buildInquiryCard(InquiryModel inquiry) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: inquiry.isRead ? null : Border.all(color: Colors.orange[200]!, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              // Status indicator
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: inquiry.isRead ? Colors.grey : Colors.orange[700],
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              
              // Customer info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      inquiry.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(Icons.email, size: 14, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(
                          inquiry.email,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Icon(Icons.phone, size: 14, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(
                          inquiry.mobile,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Date
              Text(
                DateFormat('MMM dd, yyyy').format(inquiry.createdAt),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              
              // Actions
              PopupMenuButton<String>(
                onSelected: (value) {
                  switch (value) {
                    case 'mark_read':
                      controller.markInquiryAsRead(inquiry);
                      break;
                    case 'delete':
                      _showDeleteConfirmation(() => controller.deleteInquiry(inquiry));
                      break;
                  }
                },
                itemBuilder: (context) => [
                  if (!inquiry.isRead)
                    const PopupMenuItem(
                      value: 'mark_read',
                      child: Row(
                        children: [
                          Icon(Icons.mark_email_read, size: 16),
                          SizedBox(width: 8),
                          Text('Mark as Read'),
                        ],
                      ),
                    ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, size: 16, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Delete', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Message
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              inquiry.message,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionCard(SuggestionModel suggestion) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: suggestion.isRead ? null : Border.all(color: Colors.orange[200]!, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              // Priority indicator
              _buildPriorityBadge(suggestion.priority),
              const SizedBox(width: 12),
              
              // Product name
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      suggestion.productName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    if (suggestion.customerName != null)
                      Text(
                        'by ${suggestion.customerName}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                  ],
                ),
              ),
              
              // Status badge
              _buildStatusBadge(suggestion.status),
              
              const SizedBox(width: 16),
              
              // Date
              Text(
                DateFormat('MMM dd, yyyy').format(suggestion.createdAt),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              
              // Actions
              PopupMenuButton<String>(
                onSelected: (value) {
                  switch (value) {
                    case 'mark_read':
                      controller.markSuggestionAsRead(suggestion);
                      break;
                    case 'status':
                      _showStatusUpdateDialog(suggestion);
                      break;
                    case 'priority':
                      _showPriorityUpdateDialog(suggestion);
                      break;
                    case 'delete':
                      _showDeleteConfirmation(() => controller.deleteSuggestion(suggestion));
                      break;
                  }
                },
                itemBuilder: (context) => [
                  if (!suggestion.isRead)
                    const PopupMenuItem(
                      value: 'mark_read',
                      child: Row(
                        children: [
                          Icon(Icons.mark_email_read, size: 16),
                          SizedBox(width: 8),
                          Text('Mark as Read'),
                        ],
                      ),
                    ),
                  const PopupMenuItem(
                    value: 'status',
                    child: Row(
                      children: [
                        Icon(Icons.update, size: 16),
                        SizedBox(width: 8),
                        Text('Update Status'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'priority',
                    child: Row(
                      children: [
                        Icon(Icons.flag, size: 16),
                        SizedBox(width: 8),
                        Text('Update Priority'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, size: 16, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Delete', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Suggestion content
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              suggestion.suggestion,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
                height: 1.5,
              ),
            ),
          ),
          
          // Customer contact info
          if (suggestion.customerEmail != null || suggestion.customerMobile != null)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Row(
                children: [
                  if (suggestion.customerEmail != null) ...[
                    Icon(Icons.email, size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      suggestion.customerEmail!,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                  if (suggestion.customerEmail != null && suggestion.customerMobile != null)
                    const SizedBox(width: 16),
                  if (suggestion.customerMobile != null) ...[
                    Icon(Icons.phone, size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      suggestion.customerMobile!,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPriorityBadge(String priority) {
    Color color;
    switch (priority) {
      case 'high':
        color = Colors.red;
        break;
      case 'medium':
        color = Colors.orange;
        break;
      case 'low':
        color = Colors.green;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        priority.toUpperCase(),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    String displayText;
    
    switch (status) {
      case 'pending':
        color = Colors.orange;
        displayText = 'Pending';
        break;
      case 'in_review':
        color = Colors.blue;
        displayText = 'In Review';
        break;
      case 'planned':
        color = Colors.purple;
        displayText = 'Planned';
        break;
      case 'implemented':
        color = Colors.green;
        displayText = 'Implemented';
        break;
      case 'rejected':
        color = Colors.red;
        displayText = 'Rejected';
        break;
      default:
        color = Colors.grey;
        displayText = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        displayText,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(VoidCallback onConfirm) {
    Get.dialog(
      AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Are you sure you want to delete this item? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              onConfirm();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showStatusUpdateDialog(SuggestionModel suggestion) {
    Get.dialog(
      AlertDialog(
        title: const Text('Update Status'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            'pending',
            'in_review',
            'planned',
            'implemented',
            'rejected'
          ].map((status) => ListTile(
            title: Text(status.replaceAll('_', ' ').toUpperCase()),
            onTap: () {
              Get.back();
              controller.updateSuggestionStatus(suggestion, status);
            },
          )).toList(),
        ),
      ),
    );
  }

  void _showPriorityUpdateDialog(SuggestionModel suggestion) {
    Get.dialog(
      AlertDialog(
        title: const Text('Update Priority'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            'low',
            'medium',
            'high'
          ].map((priority) => ListTile(
            title: Text(priority.toUpperCase()),
            onTap: () {
              Get.back();
              controller.updateSuggestionPriority(suggestion, priority);
            },
          )).toList(),
        ),
      ),
    );
  }
}
