import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:qanon/models/contract_type.dart';
import 'package:qanon/models/legal_contract.dart';
import 'package:qanon/widgets/contracts/contract_filter_dropdown.dart';
import 'package:qanon/widgets/contracts/contract_card.dart';
import 'package:qanon/widgets/contracts/empty_contracts_view.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:open_file/open_file.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

class LegalContractScreen extends StatefulWidget {
  const LegalContractScreen({super.key});

  @override
  State<LegalContractScreen> createState() => _LegalContractScreenState();
}

class _LegalContractScreenState extends State<LegalContractScreen> {
  final _firestore = FirebaseFirestore.instance;
  static const _collectionName = 'legal_contracts';
  ContractType? _selectedType;

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Stream<List<LegalContract>> _getContractsStream() {
    Query query = _firestore.collection(_collectionName);
    
    if (_selectedType != null) {
      query = query.where('contractType', isEqualTo: _selectedType!.value);
    }

    return query
        .orderBy('uploadedAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => LegalContract.fromFirestore(doc))
            .toList());
  }

  Future<void> _checkAndRequestPermissions() async {
    if (Platform.isAndroid) {
      // للـ Android 13 وأعلى
      if (await Permission.photos.isDenied) {
        await Permission.photos.request();
      }
      if (await Permission.videos.isDenied) {
        await Permission.videos.request();
      }
      if (await Permission.audio.isDenied) {
        await Permission.audio.request();
      }
      
      // للإصدارات الأقدم
      if (await Permission.storage.isDenied) {
        await Permission.storage.request();
      }
      if (await Permission.manageExternalStorage.isDenied) {
        await Permission.manageExternalStorage.request();
      }
    }
  }

  Future<void> _viewPdf(String? url) async {
    if (!mounted) return;

    if (url == null || url.isEmpty) {
      _showSnackBar('لا يوجد رابط للملف');
      return;
    }

    try {
      // عرض مؤشر التحميل
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('جاري تحضير الملف...'),
            ],
          ),
        ),
      );

      final uri = Uri.tryParse(url);
      if (uri == null) {
        Navigator.pop(context);
        _showSnackBar('رابط غير صالح');
        return;
      }

      // طلب الصلاحيات
      await _checkAndRequestPermissions();
      
      // تحميل مؤقت وفتح
      final tempDir = await getTemporaryDirectory();
      final fileName = 'contract_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final filePath = '${tempDir.path}/$fileName';

      final dio = Dio();
      await dio.download(url, filePath);

      Navigator.pop(context);

      // فتح الملف
      final result = await OpenFile.open(filePath);
      
      if (result.type != ResultType.done) {
        // إذا فشل الفتح، جرب بالمتصفح
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }

    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        _showSnackBar('حدث خطأ في عرض الملف');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'العقود القانونية',
          style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          ContractFilterDropdown(
            selectedType: _selectedType,
            onChanged: (value) => setState(() => _selectedType = value),
          ),
          Expanded(
            child: StreamBuilder<List<LegalContract>>(
              stream: _getContractsStream(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                    child: Text('حدث خطأ في تحميل العقود'),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final contracts = snapshot.data ?? [];
                if (contracts.isEmpty) {
                  return EmptyContractsView(selectedType: _selectedType);
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: contracts.length,
                  itemBuilder: (context, index) => ContractCard(
                    contract: contracts[index],
                    onViewPressed: (url) => _viewPdf(url),
                    onDownloadPressed: (url) => {}, // مش مستعمل
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}