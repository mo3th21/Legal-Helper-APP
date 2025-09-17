import 'package:cloud_firestore/cloud_firestore.dart';
import 'contract_type.dart';

/// Model class for legal contracts stored in Firebase
class LegalContract {
  final String? id;
  final String fileName;
  final String downloadUrl;
  final DateTime? uploadedAt;
  final String uploadFileName;
  final ContractType contractType;
  final String? description;

  LegalContract({
    this.id,
    required this.fileName,
    required this.downloadUrl,
    this.uploadedAt,
    required this.uploadFileName,
    this.contractType = ContractType.other,
    this.description,
  });

  /// Create a LegalContract from Firestore document
  factory LegalContract.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return LegalContract(
      id: doc.id,
      fileName: data['fileName'] ?? 'Unknown File',
      downloadUrl: data['downloadUrl'] ?? '',
      uploadedAt:
          data['uploadedAt'] != null
              ? (data['uploadedAt'] as Timestamp).toDate()
              : null,
      uploadFileName: data['uploadFileName'] ?? '',
      contractType:
          data['contractType'] != null
              ? ContractType.fromValue(data['contractType'])
              : ContractType.other,
      description: data['description'],
    );
  }

  /// Create a LegalContract from a Map
  factory LegalContract.fromMap(
    Map<String, dynamic> map, {
    String? documentId,
  }) {
    return LegalContract(
      id: documentId,
      fileName: map['fileName'] ?? 'Unknown File',
      downloadUrl: map['downloadUrl'] ?? '',
      uploadedAt:
          map['uploadedAt'] != null
              ? (map['uploadedAt'] is Timestamp
                  ? (map['uploadedAt'] as Timestamp).toDate()
                  : DateTime.parse(map['uploadedAt'].toString()))
              : null,
      uploadFileName: map['uploadFileName'] ?? '',
      contractType:
          map['contractType'] != null
              ? ContractType.fromValue(map['contractType'])
              : ContractType.other,
      description: map['description'],
    );
  }

  /// Convert LegalContract to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'fileName': fileName,
      'downloadUrl': downloadUrl,
      'uploadedAt':
          uploadedAt != null
              ? Timestamp.fromDate(uploadedAt!)
              : FieldValue.serverTimestamp(),
      'uploadFileName': uploadFileName,
      'contractType': contractType.value,
      'description': description,
    };
  }

  /// Convert LegalContract to Map for creating new documents
  Map<String, dynamic> toFirestoreMap() {
    return {
      'fileName': fileName,
      'downloadUrl': downloadUrl,
      'uploadedAt': FieldValue.serverTimestamp(),
      'uploadFileName': uploadFileName,
      'contractType': contractType.value,
      'description': description,
    };
  }

  /// Format upload date for display
  String get formattedUploadDate {
    if (uploadedAt == null) return 'غير معروف';
    return uploadedAt!.toString().split('.')[0];
  }

  /// Get file extension
  String get fileExtension {
    return fileName.split('.').last.toLowerCase();
  }

  /// Check if file is a PDF
  bool get isPdf => fileExtension == 'pdf';

  /// Validate if the contract data is complete
  bool get isValid {
    return fileName.isNotEmpty &&
        downloadUrl.isNotEmpty &&
        uploadFileName.isNotEmpty;
  }

  /// Create a copy of this contract with updated fields
  LegalContract copyWith({
    String? id,
    String? fileName,
    String? downloadUrl,
    DateTime? uploadedAt,
    String? uploadFileName,
    ContractType? contractType,
    String? description,
  }) {
    return LegalContract(
      id: id ?? this.id,
      fileName: fileName ?? this.fileName,
      downloadUrl: downloadUrl ?? this.downloadUrl,
      uploadedAt: uploadedAt ?? this.uploadedAt,
      uploadFileName: uploadFileName ?? this.uploadFileName,
      contractType: contractType ?? this.contractType,
      description: description ?? this.description,
    );
  }

  @override
  String toString() {
    return 'LegalContract(id: $id, fileName: $fileName, uploadedAt: $formattedUploadDate)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LegalContract &&
        other.id == id &&
        other.fileName == fileName &&
        other.downloadUrl == downloadUrl &&
        other.uploadFileName == uploadFileName;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        fileName.hashCode ^
        downloadUrl.hashCode ^
        uploadFileName.hashCode;
  }
}
