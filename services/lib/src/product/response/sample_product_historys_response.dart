import 'package:json_annotation/json_annotation.dart';
import 'package:models/models.dart';

part 'sample_product_historys_response.g.dart';

/// 产品列表响应
@JsonSerializable()
class SampleProductHistorysResponse {
  final int number;
  final int size;
  final int totalPages;
  final int totalElements;
  final List<SampleBorrowReturnHistoryModel> content;

  SampleProductHistorysResponse(this.number, this.size, this.totalPages,
      this.totalElements, this.content);

  factory SampleProductHistorysResponse.fromJson(Map<String, dynamic> json) =>
      json == null ? null : _$SampleProductHistorysResponseFromJson(json);

  static Map<String, dynamic> toJson(SampleProductHistorysResponse model) =>
      model == null ? null : _$SampleProductHistorysResponseToJson(model);
}
