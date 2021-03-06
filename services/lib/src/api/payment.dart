///支付相关接口
class PaymentApis {
  /// 微信预付码
  static get wechatPrepay => (code) {
        return '/{baseSiteId}/checkout/multi/wechat/prepay/$code';
      };

  /// 支付宝预付码
  static get alipayPrepay => (code) {
        return '/{baseSiteId}/checkout/multi/alipay/prepay/$code';
      };

  /// 打样单----- 确认支付
  static get proofingPaidConfirm => (code, type) {
        return '/{baseSiteId}/orders/proofing/$code/paid/$type';
      };

  /// 生产单-定金 ----- 确认支付
  static get purchaseDepositPaidConfirm => (code, type) {
        return '/{baseSiteId}/orders/purchase/$code/paid/deposit/$type';
      };

  /// 生产单-尾款 ----- 确认支付
  static get purchaseBalancePaidConfirm => (code, type) {
        return '/{baseSiteId}/orders/purchase/$code/paid/balance/$type';
      };

  /// 销售单支付状态
  static get salesOrderPayStatus =>
          (code) {
        return '/{baseSiteId}/b2b/orders/sales/$code/check/paid/state';
      };
}
