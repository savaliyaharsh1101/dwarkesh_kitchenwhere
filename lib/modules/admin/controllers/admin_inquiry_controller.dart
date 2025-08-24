import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../shared/models/inquiry_model.dart';
import '../../../shared/models/suggestion_model.dart';

class AdminInquiryController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Observable variables
  final RxList<InquiryModel> inquiries = <InquiryModel>[].obs;
  final RxList<SuggestionModel> suggestions = <SuggestionModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString selectedTab = 'inquiries'.obs;
  final RxString statusFilter = 'all'.obs;
  final RxString priorityFilter = 'all'.obs;
  
  // Stats
  final RxInt totalInquiries = 0.obs;
  final RxInt unreadInquiries = 0.obs;
  final RxInt totalSuggestions = 0.obs;
  final RxInt pendingSuggestions = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    isLoading.value = true;
    try {
      await Future.wait([
        loadInquiries(),
        loadSuggestions(),
      ]);
      updateStats();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadInquiries() async {
    try {
      final snapshot = await _firestore
          .collection('inquiries')
          .orderBy('createdAt', descending: true)
          .get();

      final List<InquiryModel> loadedInquiries = [];
      for (final doc in snapshot.docs) {
        try {
          final inquiry = InquiryModel.fromMap(doc.data(), doc.id);
          loadedInquiries.add(inquiry);
        } catch (e) {
          print('Error parsing inquiry ${doc.id}: $e');
          print('Data: ${doc.data()}');
        }
      }
      inquiries.value = loadedInquiries;
    } catch (e) {
      print('Error loading inquiries: $e');
      Get.snackbar('Error', 'Failed to load inquiries: $e');
    }
  }

  Future<void> loadSuggestions() async {
    try {
      final snapshot = await _firestore
          .collection('suggestions')
          .orderBy('createdAt', descending: true)
          .get();

      final List<SuggestionModel> loadedSuggestions = [];
      for (final doc in snapshot.docs) {
        try {
          final suggestion = SuggestionModel.fromMap(doc.data(), doc.id);
          loadedSuggestions.add(suggestion);
        } catch (e) {
          print('Error parsing suggestion ${doc.id}: $e');
          print('Data: ${doc.data()}');
        }
      }
      suggestions.value = loadedSuggestions;
    } catch (e) {
      print('Error loading suggestions: $e');
      Get.snackbar('Error', 'Failed to load suggestions: $e');
    }
  }

  void updateStats() {
    totalInquiries.value = inquiries.length;
    unreadInquiries.value = inquiries.where((inquiry) => !inquiry.isRead).length;
    totalSuggestions.value = suggestions.length;
    pendingSuggestions.value = suggestions.where((suggestion) => suggestion.status == 'pending').length;
  }

  Future<void> markInquiryAsRead(InquiryModel inquiry) async {
    try {
      final now = DateTime.now();
      await _firestore
          .collection('inquiries')
          .doc(inquiry.id)
          .update({'isRead': true, 'updatedAt': Timestamp.fromDate(now)});
      
      // Update local data
      final index = inquiries.indexWhere((item) => item.id == inquiry.id);
      if (index != -1) {
        inquiries[index] = inquiry.copyWith(isRead: true, updatedAt: now);
        updateStats();
      }
      
      Get.snackbar('Success', 'Inquiry marked as read');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update inquiry: $e');
    }
  }

  Future<void> markSuggestionAsRead(SuggestionModel suggestion) async {
    try {
      final now = DateTime.now();
      await _firestore
          .collection('suggestions')
          .doc(suggestion.id)
          .update({'isRead': true, 'updatedAt': Timestamp.fromDate(now)});
      
      // Update local data
      final index = suggestions.indexWhere((item) => item.id == suggestion.id);
      if (index != -1) {
        suggestions[index] = suggestion.copyWith(isRead: true, updatedAt: now);
      }
      
      Get.snackbar('Success', 'Suggestion marked as read');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update suggestion: $e');
    }
  }

  Future<void> updateSuggestionStatus(SuggestionModel suggestion, String newStatus) async {
    try {
      final now = DateTime.now();
      await _firestore
          .collection('suggestions')
          .doc(suggestion.id)
          .update({'status': newStatus, 'updatedAt': Timestamp.fromDate(now)});
      
      // Update local data
      final index = suggestions.indexWhere((item) => item.id == suggestion.id);
      if (index != -1) {
        suggestions[index] = suggestion.copyWith(status: newStatus, updatedAt: now);
        updateStats();
      }
      
      Get.snackbar('Success', 'Suggestion status updated');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update suggestion status: $e');
    }
  }

  Future<void> updateSuggestionPriority(SuggestionModel suggestion, String newPriority) async {
    try {
      final now = DateTime.now();
      await _firestore
          .collection('suggestions')
          .doc(suggestion.id)
          .update({'priority': newPriority, 'updatedAt': Timestamp.fromDate(now)});
      
      // Update local data
      final index = suggestions.indexWhere((item) => item.id == suggestion.id);
      if (index != -1) {
        suggestions[index] = suggestion.copyWith(priority: newPriority, updatedAt: now);
      }
      
      Get.snackbar('Success', 'Suggestion priority updated');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update suggestion priority: $e');
    }
  }

  Future<void> deleteInquiry(InquiryModel inquiry) async {
    try {
      await _firestore.collection('inquiries').doc(inquiry.id).delete();
      inquiries.removeWhere((item) => item.id == inquiry.id);
      updateStats();
      Get.snackbar('Success', 'Inquiry deleted successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete inquiry: $e');
    }
  }

  Future<void> deleteSuggestion(SuggestionModel suggestion) async {
    try {
      await _firestore.collection('suggestions').doc(suggestion.id).delete();
      suggestions.removeWhere((item) => item.id == suggestion.id);
      updateStats();
      Get.snackbar('Success', 'Suggestion deleted successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete suggestion: $e');
    }
  }

  void setActiveTab(String tab) {
    selectedTab.value = tab;
  }

  void setStatusFilter(String status) {
    statusFilter.value = status;
  }

  void setPriorityFilter(String priority) {
    priorityFilter.value = priority;
  }

  // Filtered lists based on current filters
  List<InquiryModel> get filteredInquiries {
    var filtered = inquiries.toList();
    
    if (statusFilter.value == 'unread') {
      filtered = filtered.where((inquiry) => !inquiry.isRead).toList();
    } else if (statusFilter.value == 'read') {
      filtered = filtered.where((inquiry) => inquiry.isRead).toList();
    }
    
    return filtered;
  }

  List<SuggestionModel> get filteredSuggestions {
    var filtered = suggestions.toList();
    
    if (statusFilter.value != 'all') {
      filtered = filtered.where((suggestion) => suggestion.status == statusFilter.value).toList();
    }
    
    if (priorityFilter.value != 'all') {
      filtered = filtered.where((suggestion) => suggestion.priority == priorityFilter.value).toList();
    }
    
    return filtered;
  }

  Future<void> refreshData() async {
    await loadData();
  }
}
