const COMMON_APIS = {
  // 注册
  fastRegister(type) {
    return '/b2b/companies/register/fast/' + type;
  },
  // 是否已注册
  checkRegistered(phone) {
    return '/b2b/companies/register/' + phone;
  },
  // 发送短信验证码
  sendCaptcha(phone) {
    return '/b2b/sms/captcha/' + phone;
  },
  // 发送员工绑定手机号短信验证码
  sendCaptchaByChild(uid) {
    return '/b2b/sms/captchaByChild/' + uid;
  },
  // 校验短信验证码
  validateCaptcha() {
    return '/b2b/sms/validate';
  },
  //短信重置密码
  resetPasswordByCaptcha(id) {
    return '/b2b/users/anonymous/resetPasswordByCaptcha/' + id;
  },

  //员工账号短信重置密码
  resetPasswordByCaptchaForChild(uid) {
    return '/b2b/users/anonymous/resetPasswordByCaptchaChild/' + uid;
  },

  getAmapTips(key, keyWord, city) {
    return '/amap/v3/assistant/inputtips?key=' + key + '&keywords=' + keyWord + '&city=' + city;
  },
  changePassword(username) {
    return '/b2b/users/' + username + '/password';
  },
  getRegions() {
    return '/b2b/addresses/CN/regions';
  },
  getCities(parentCode) {
    return '/b2b/addresses/' + parentCode + '/cities'
  },
  getDistricts(parentCode) {
    return '/b2b/addresses/' + parentCode + '/districts'
  },
  getCarriers() {
    return '/b2b/carriers';
  },
  findBrandAndFactory() {
    return '/b2b/companies/findBrandAndFactory';
  },
  createColor() {
    return '/b2b/colors/create';
  },
  updateColor(code) {
    return '/b2b/colors/update/' + code;
  },
  getColors() {
    return '/b2b/colors';
  },
  getColorsSearch() {
    return '/b2b/colors/search';
  },
  getColor(code) {
    return '/b2b/colors/' + code;
  },
  getColorSearch(code) {
    return '/b2b/colors/search/' + code;
  },
  getAllColors() {
    return '/b2b/colors/all';
  },
  createSize() {
    return '/b2b/sizes/create';
  },
  updateSize(code) {
    return '/b2b/sizes/update/' + code;
  },
  getSizes() {
    return '/b2b/sizes';
  },
  getSizesSearch() {
    return '/b2b/sizes/search';
  },
  getSize(code) {
    return '/b2b/sizes/' + code;
  },
  getSizeSearch(code) {
    return '/b2b/sizes/search/' + code;
  },
  getAllSizes() {
    return '/b2b/sizes/all';
  },
  createSampleProduct() {
    return '/b2b/products/sample/create';
  },
  updateSampleProduct(code) {
    return '/b2b/products/sample/update/' + code;
  },
  getSampleProducts() {
    return '/b2b/sample/clothes';
  },
  getSampleProduct(id) {
    return '/b2b/products/sample/' + id;
  },
  createSampleCheckoutHist() {
    return '/b2b/products/sampleCheckoutHist/create';
  },
  updateSampleCheckoutHist(id) {
    return '/b2b/products/sampleCheckoutHist/update/' + id;
  },
  getSampleCheckoutHists() {
    return '/b2b/products/sampleCheckoutHist';
  },
  getAdvanceSampleCheckoutHists() {
    return '/b2b/products/sampleCheckoutHist/search';
  },
  getSampleCheckoutHist(id) {
    return '/b2b/products/sampleCheckoutHist/' + id;
  },
  createCarousel() {
    return '/b2b/carousels/create';
  },
  updateCarousel(id) {
    return '/b2b/carousels/update/' + id;
  },
  getCarousels() {
    return '/b2b/carousels';
  },
  getCarousel(id) {
    return '/b2b/carousels/' + id;
  },
  createIndustrialCluster() {
    return '/b2b/industrialClusters/create';
  },
  getIndustrialClusters() {
    return '/b2b/industrialClusters';
  },
  getIndustrialClustersAll() {
    return '/b2b/industrialClusters/all';
  },
  getIndustrialCluster(code) {
    return '/b2b/industrialClusters/' + code;
  },
  createLabel() {
    return '/b2b/labels/create';
  },
  updateLabel() {
    return '/b2b/labels/update';
  },
  getAllLabels() {
    return '/b2b/labels/all';
  },
  getGroupLabels(group) {
    return '/b2b/labels/' + group + '/all';
  },
  getIndustrialClusterLabels() {
    return '/b2b/industrialClusters/labels';
  },
  getLabels() {
    return '/b2b/labels';
  },
  getLabel(id) {
    return '/b2b/labels/' + id;
  },
  getBrandSuppliers() {
    return '/b2b/factories/getSuppliers';
  },
  getFactoriesSuppliers() {
    return '/b2b/brands/getSuppliers';
  },
  createEmployee() {
    return '/b2b/employees/create';
  },
  updateEmployee(uid) {
    return '/b2b/employees/update/' + uid;
  },
  getEmployees() {
    return '/b2b/employees';
  },
  getEmployee(uid) {
    return '/b2b/employees/' + uid;
  },
  createBrand() {
    return '/b2b/brands/new';
  },
  updateBrand(uid) {
    return '/b2b/brands/' + uid;
  },
  getBrands() {
    return '/b2b/brands';
  },
  getBrandsByName() {
    return '/b2b/brands/searchByName';
  },
  getBrand(uid) {
    return '/b2b/brands/' + uid;
  },
  removeCertificateForCompany(uid, mediaID) {
    return '/b2b/brands/' + uid + '/certificate/' + mediaID;
  },
  createFactory() {
    return '/b2b/factories/new';
  },
  updateFactory(uid) {
    return '/b2b/factories/' + uid;
  },
  updateFactoryProfiles(uid) {
    return '/b2b/factories/' + uid + '/profiles';
  },
  getFactories() {
    return '/b2b/factories';
  },
  getFactoriesByName() {
    return '/b2b/factories/searchByName';
  },
  getFactory(uid) {
    return '/b2b/factories/' + uid;
  },
  createB2BCustomer() {
    return '/b2b/b2bCustomers/create';
  },
  updateB2BCustomer(uid) {
    return '/b2b/b2bCustomers/update/' + uid;
  },
  getB2BCustomers() {
    return '/b2b/b2bCustomers';
  },
  getPersonnelDetail(id) {
    return '/b2b/b2bCustomers/get/' + id;
  },
  getB2BCustomerDeptList() {
    return '/b2b/dept/tree/list';
  },
  createB2BCustomerDept() {
    return '/b2b/dept/save';
  },
  deleteB2BCustomerDept(id) {
    return '/b2b/dept/delete/' + id;
  },
  getB2BCustomerRoleGroupList() {
    return '/b2b/role/group/list';
  },
  saveB2BCustomerRoleGroup() {
    return '/b2b/role/group/save';
  },
  removeB2BCustomerRoleGroup(id) {
    return '/b2b/role/group/delete/' + id;
  },
  getB2BCustomerRoleGroupDetails(id) {
    return '/b2b/role/group/get/' + id;
  },
  // 启/禁用角色
  changeRoleState(id) {
    return '/b2b/role/group/enable/or/disable/' + id;
  },
  getB2BCustomer(uid) {
    return '/b2b/b2bCustomers/' + uid;
  },
  getRoleList() {
    return '/b2b/role/tree/list';
  },
  createRole() {
    return '/b2b/roles/create';
  },
  getRoles() {
    return '/b2b/roles';
  },
  getAllRoles() {
    return '/b2b/roles';
  },
  getRole(uid) {
    return '/b2b/roles/' + uid;
  },
  createUserGroup() {
    return '/b2b/userGroups/create';
  },
  updateUserGroup() {
    return '/b2b/userGroups/update';
  },
  getUserGroups() {
    return '/b2b/userGroups';
  },
  getUserGroup(uid) {
    return '/b2b/userGroups/' + uid;
  },
  createB2BUnit() {
    return '/b2b/b2bUnits';
  },
  getB2BUnits() {
    return '/b2b/b2bUnits';
  },
  getB2BUnit(uid) {
    return '/b2b/b2bUnits/' + uid;
  },
  createAddress() {
    return '/b2b/company/addresses';
  },
  updateAddress(id) {
    return '/b2b/company/addresses/' + id;
  },
  removeAddress(id) {
    return '/b2b/company/addresses/' + id;
  },
  getAddresses() {
    return '/b2b/company/addresses';
  },
  getAddress(id) {
    return '/b2b/company/addresses/' + id;
  },
  getCategories() {
    return '/b2b/categories/categories';
  },
  getCategory(code) {
    return '/b2b/categories/category/' + code;
  },
  createCategories() {
    return '/b2b/categories';
  },
  // 小类，级联（二级）
  getMinorCategories() {
    return '/b2b/categories/cascaded';
  },
  getMajorCategories() {
    return '/b2b/categories/majors';
  },
  getApparelProduct(code) {
    return '/b2b/products/apparel/' + code;
  },
  getSampleProduct(code) {
    return '/b2b/sample/clothes/' + code;
  },
  onShelfProduct(code) {
    return '/b2b/products/apparel/' + code + '/on';
  },
  offShelfProduct(code) {
    return '/b2b/products/apparel/' + code + '/off';
  },
  deleteProduct(code) {
    return '/b2b/products/apparel/' + code + '/deleted';
  },
  createApparelProduct() {
    return '/b2b/products/apparel/create';
  },
  createSampleProduct() {
    return '/b2b/sample/clothes/create';
  },
  updateOfApparelProduct(code) {
    return '/b2b/products/apparel/' + code;
  },
  updateOfSampleProduct(code) {
    return '/b2b/sample/clothes/' + code;
  },
  updateBasicOfApparelProduct(code) {
    return '/b2b/products/apparel/' + code + '/basic';
  },
  updateVariantsOfApparelProduct(code) {
    return '/b2b/products/apparel/' + code + '/variants';
  },
  updateAttributesOfApparelProduct(code) {
    return '/b2b/products/apparel/' + code + '/attributes';
  },
  updateImagesOfApparelProduct(code) {
    return '/b2b/products/apparel/' + code + '/images';
  },
  getRequirementOrder(code) {
    return '/b2b/orders/requirement/' + code;
  },
  getQuotesByRequirementOrder(code) {
    return '/b2b/orders/requirement/' + code + '/quotes';
  },
  cancelledRequirementOrder(code) {
    return '/b2b/orders/requirement/cancelled/' + code;
  },
  recommendRequirementOrderToFactory(code, uid) {
    return '/b2b/orders/requirement/' + code + '/factory/' + uid + '/recommend';
  },
  getRecommendFactories(code) {
    return '/b2b/orders/requirement/' + code + '/factories';
  },
  createRequirementOrder() {
    return '/b2b/orders/requirement/new';
  },
  updateRequirementOrder(code) {
    return '/b2b/orders/requirement/' + code + '/request';
  },
  getQuote(code) {
    return '/b2b/orders/quote/' + code;
  },
  createQuote() {
    return '/b2b/orders/quote/create';
  },
  updateQuote(code) {
    return '/b2b/orders/quote/' + code;
  },
  approveQuote(code) {
    return '/b2b/orders/quote/' + code + '/approve';
  },
  rejectQuote(code) {
    return '/b2b/orders/quote/' + code + '/reject';
  },
  cancelQuote(code) {
    return '/b2b/orders/quote/' + code + '/cancel';
  },
  getPurchaseOrder(code) {
    return '/b2b/orders/purchase/' + code;
  },
  updateDeliveryAddressOfPurchaseOrder(code) {
    return '/b2b/orders/purchase/' + code + '/deliveryAddress';
  },
  updateProgressOfPurchaseOrder(code, id) {
    return '/b2b/orders/purchase/' + code + '/progress/' + id;
  },
  updateProgressForBatch(code) {
    return '/b2b/orders/purchase/' + code + '/progresses';
  },
  // 生成唯一码
  generateUniqueCode(code) {
    return '/b2b/orders/purchase/' + code + '/unique';
  },
  // 根据唯一码获取订单明细
  getDetailsForUniqueCode(code) {
    return '/b2b/orders/purchase/unique/' + code;
  },
  // 关联唯一码
  linkUniqueCode(code) {
    return '/b2b/orders/purchase/link/' + code;
  },
  createPurchaseOrder() {
    return '/b2b/orders/purchase/create';
  },
  createOfflinePurchaseOrder() {
    return '/b2b/orders/purchase/createByOffline';
  },
  updateOfflinePurchaseOrder() {
    return '/b2b/orders/purchase/updateByOffline';
  },
  createPurchaseOrderOfQuote(quote) {
    return '/b2b/orders/purchase/create/' + quote;
  },
  // 创建发货单
  createShippingOrder(code) {
    return '/b2b/orders/purchase/' + code + '/createShippingOrder';
  },
  // 创建全部发货单
  confirmShipping(code) {
    return '/b2b/orders/purchase/' + code + '/confirmShipping';
  },
  // 删除发货单
  deleteShippingOrder(id) {
    return '/b2b/orders/purchase/deleteShippingOrder/' + id;
  },
  // 创建收货单
  createDeliveryOrder(code) {
    return '/b2b/orders/purchase/' + code + '/createDeliveryOrder';
  },
  // 创建并提交收货单
  createAndCommitDeliveryOrder(code) {
    return '/b2b/orders/purchase/' + code + '/createAndCommitDeliveryOrder';
  },
  // 提交收货单
  commitDeliveryOrder() {
    return '/b2b/orders/purchase/commitDeliveryOrder';
  },
  // 保存收货单
  updateDeliveryOrder() {
    return '/b2b/orders/purchase/updateDeliveryOrder';
  },
  // 撤回收货单
  withdrawDeliveryOrder(code) {
    return '/b2b/orders/purchase/' + code + '/recallDelivery';
  },
  // 确认收货单
  confirmDeliveryOrder(code) {
    return '/b2b/orders/purchase/' + code + '/confirmDelivery';
  },
  // 拒绝收货单
  rejectDeliveryOrder(code) {
    return '/b2b/orders/purchase/' + code + '/rejectDelivery';
  },
  // 创建对账单
  createReconciliationOrder(code) {
    return '/b2b/orders/purchase/' + code + '/createReconciliationOrder';
  },
  // 创建并提交对账单
  createAndCommitReconciliationOrder(code) {
    return '/b2b/orders/purchase/' + code + '/createAndCommitReconciliationOrder';
  },
  // 提交对账单
  commitReconciliationOrder() {
    return '/b2b/orders/purchase/commitReconciliationOrder';
  },
  // 撤回对账单
  withdrawReconciliationOrder() {
    return '/b2b/orders/purchase/recallReconciliationOrder';
  },
  // 确认对账单
  confirmReconciliation(code) {
    return '/b2b/orders/purchase/' + code + '/confirmReconciliation';
  },
  // 拒绝对账单
  rejectReconciliation(code) {
    return '/b2b/orders/purchase/' + code + '/rejectReconciliation';
  },
  // 确认线下生产订单
  confirmProductionByOffline(code) {
    return '/b2b/orders/purchase/' + code + '/confirmProductionByOffline';
  },
  getProductionProgressReports() {
    return '/b2b/reports/productionProgresses';
  },
  getProofing(code) {
    return '/b2b/orders/proofing/' + code;
  },
  updateDeliveryAddressOfProofing(code) {
    return '/b2b/orders/proofing/' + code + '/deliveryAddress';
  },
  createProofing(quote) {
    return '/b2b/orders/proofing/create/' + quote;
  },
  removeMedia(mediaID) {
    return '/b2b/media/' + mediaID
  },
  getAmountFlowDetail(id) {
    return '/b2b/amountFlow/' + id
  },
  findAmountFlows() {
    return '/b2b/amountFlow'
  },
  getBill(id) {
    return '/b2b/bill/' + id;
  },
  createPaymentOrder(id) {
    return '/b2b/orders/purchase/confirmPayment/' + id;
  },
  updatePaymentOrder() {
    return '/b2b/orders/purchase/updatePaymentOrder';
  },
  deletePaymentOrder(id) {
    return '/b2b/orders/purchase/deletePaymentOrder/' + id;
  },
  createReceiptOrder(id) {
    return '/b2b/orders/purchase/confirmReceipt/' + id;
  },
  updateReceiptOrder() {
    return '/b2b/orders/purchase/updateReceiptOrder';
  },
  deleteReceiptOrder(id) {
    return '/b2b/orders/purchase/deleteReceiptOrder/' + id;
  },
  getCooperators() {
    return '/b2b/cooperator';
  },
  getCooperator(id) {
    return '/b2b/cooperator/' + id;
  },
  createCooperator() {
    return '/b2b/cooperator/create';
  },
  updateCooperator() {
    return '/b2b/cooperator/update';
  },
  deleteCooperator(id) {
    return '/b2b/cooperator/delete/' + id;
  },
  getPayPlans() {
    return '/b2b/payPlan';
  },
  getPayPlan(id) {
    return '/b2b/payPlan/' + id;
  },
  createPayPlan() {
    return '/b2b/payPlan/create';
  },
  updatePayPlan(id) {
    return '/b2b/payPlan/update/' + id;
  },
  deletePayPlan(id) {
    return 'b2b/payPlan/delete/' + id;
  },
  // deletePayPlan (id) {
  //   return 'b2b/payPlan/delete/' + id;
  // },
  updateUserInfo(uid) {
    return 'b2b/b2bCustomers/' + uid + '/updateUserInfo';
  },
  // 公司产能
  getCapacityList() {
    return 'b2b/factory/capacity/list';
  },
  getCapacityByCode(code) {
    return 'b2b/factory/capacity/get/' + code;
  },
  // 品牌查询产能列表
  searchCapacity() {
    return 'b2b/factory/capacity/search';
  },
  // 产能切换状态
  capacitySwitchStatus(code) {
    return 'b2b/factory/capacity/switch/status/' + code;
  },
  // 产能刷新
  capacityRefresh(code) {
    return 'b2b/factory/capacity/refresh/' + code;
  },
  // 保存
  capacitySave() {
    return 'b2b/factory/capacity/save';
  },
  /// 创建生产进度单据
  createProductionProgressOrder(id) {
    return 'b2b/orders/purchase/progress/' + id + '/order';
  },
  /// 作废生产进度单据
  deleteProductionProgressOrder(id, orderId) {
    return 'b2b/orders/purchase/progress/' + id + '/order/' + orderId;
  },
  /// 修改生产进度单据
  updateProductionProgressOrder(id, orderId) {
    return 'b2b/orders/purchase/progress/' + id + '/order/' + orderId;
  },
  /// 生意/订单/合同/财务统计
  reportsTab1() {
    return 'b2b/company/reports/tab1';
  },
  /// 上线倒计时/交货倒计时统计
  reportsProgress() {
    return 'b2b/company/reports/progress';
  },
  checkTempName() {
    return 'b2b/user/agreement/temp/check';
  },
  /// 未读消息统计
  countUnreadMsg(uid) {
    return 'b2b/user/' + uid + '/unread/msg/count';
  },

  /// 获取消息列表（消息盒子）
  getMsgList(uid) {
    return 'b2b/user/' + uid + '/msg/list';
  },

  /// 消息标记为未读
  unReadMsgs(uid) {
    return 'b2b/user/' + uid + '/msg/update/to/unread';
  },
  /// 消息标记为已读
  readMsgs(uid) {
    return 'b2b/user/' + uid + '/msg/update/to/read';
  },
  deleteMsgs(uid) {
    return 'b2b/user/' + uid + '/msg/delete';
  },
  /// 将所有未读消息标记为已读
  readAllMsg(uid) {
    return 'b2b/user/' + uid + '/msg/read';
  },
  // 删除员工
  removeB2BCustomer(id) {
    return 'b2b/companies/remove/sub/account/' + id;
  },
  // 改变员工账号启/禁用状态
  changeLoginDisabled(uid) {
    return 'b2b/users/' + uid + '/active';
  },
  // 设置部门负责人
  setDepartmentHead(uid) {
    return 'b2b/dept/update/manager/' + uid;
  },
  // 添加物料
  saveMaterials() {
    return '/b2b/materials/save';
  },
  // 获取物料列表(弹窗组件选择)
  getMaterialsListBySelect() {
    return '/b2b/materials/searchBySelect';
  },
  // 获取物料列表
  getMaterialsList() {
    return '/b2b/materials/search';
  },
  // 获取物料详情
  getMaterialDetails(id) {
    return '/b2b/materials/' + id;
  },
  // 获取外发订单列表
  getoutboundOrdersList() {
    return '/b2b/out/order/search';
  },
  // 获取外发工单列表
  getoutboundProductionList() {
    return '/b2b/out/order/production/search';
  },
  // 创建外发订单
  createOutboundOrder() {
    return '/b2b/out/order/save';
  },
  // 创建外发订单(款式外发)
  createOutboundOrderWithClothes() {
    return '/b2b/out/order/save/with/clothes';
  },
  // 获取外发订单详情
  getoutboundOrderDetail(id) {
    return '/b2b/out/order/' + id;
  },
  // 编辑外发订单详情
  updateOutboundOrder() {
    return '/b2b/orders/outbound/update';
  },
  // 接单
  acceptOutboundOrder(code) {
    return '/b2b/orders/outbound/' + code + '/production';
  },
  // 拒绝接单
  rejectedOutboundOrder(code) {
    return '/b2b/orders/outbound/' + code + '/rejectedConfirm';
  },
  // 取消外发订单
  cancelOutboundOrder(code) {
    return '/b2b/orders/outbound/' + code + '/cancelling';
  },
  // 获取节点方案列表
  getProgressPlan() {
    return '/b2b/progress/plan';
  },
  // 新建节点方案
  createProgressPlan() {
    return '/b2b/progress/plan/create';
  },
  // 更新节点方案
  updateProgressPlan(id) {
    return '/b2b/progress/plan/update/' + id;
  },
  // 获取节点方案详情
  getProgressPlanDetail(id) {
    return '/b2b/progress/plan/' + id;
  },
  // 启用节点方案
  enableProgressPlan(id) {
    return '/b2b/progress/plan/enable/' + id;
  },
  // 禁用节点方案
  disableProgressPlan(id) {
    return '/b2b/progress/plan/disEnable/' + id;
  },
  // 删除节点方案
  deleteProgressPlan(id) {
    return '/b2b/progress/plan/delete/' + id;
  },
  // 获取节点列表
  getProgressPhaseList() {
    return '/b2b/progress/phase';
  },
  // 获取对账方案列表
  getReconciliationPlan() {
    return '/b2b/reconciliationPlan';
  },
  // 新建对账方案
  createReconciliationPlan() {
    return '/b2b/reconciliationPlan/create';
  },
  // 更新对账方案
  updateReconciliationPlan(id) {
    return '/b2b/reconciliationPlan/update/' + id;
  },
  // 获取对账方案详情
  getReconciliationPlanDetail(id) {
    return '/b2b/reconciliationPlan/' + id;
  },
  // 启用对账方案
  enableReconciliationPlan(id) {
    return '/b2b/reconciliationPlan/enable/' + id;
  },
  // 禁用对账方案
  disableReconciliationPlan(id) {
    return '/b2b/reconciliationPlan/disEnable/' + id;
  },
  // 删除对账方案
  deleteReconciliationPlan(id) {
    return '/b2b/reconciliationPlan/delete/' + id;
  },
  // 获取代办列表
  getToDoList() {
    return '/b2b/todo/task/list';
  },
  // 跟新为已读
  updateToRead(id) {
    return '/b2b/todo/task/read/' + id;
  },
  // 获取审核列表
  getAuditList() {
    return '/b2b/audit/order/order/list';
  },
  // 审核任务
  taskAudit() {
    return '/b2b/audit/order/order/audit';
  },
  // 审核撤回
  revokeTask(id) {
    return '/b2b/audit/order/order/revoke/' + id;
  },
  // 获取进度工单列表
  getProgressOrderList() {
    return '/b2b/sheets/progress/work';
  },
  // 获取进度工单详情
  getProgressOrderDetail(code) {
    return '/b2b/sheets/progress/work/' + code;
  },
  // 获取采购任务列表
  getPurchaseTaskList() {
    return '/b2b/purchase/task/search';
  },
  // 根据id获取采购任务
  getPurchaseTask(id) {
    return '/b2b/purchase/task/' + id;
  },
  // 添加采购任务
  savePurchaseTask() {
    return '/b2b/purchase/task/save'
  },
  // 创建生产工单
  createProductionOrder() {
    return '/b2b/orders/production/work/create';
  },
  // 更新进度工单
  updateProgressOrder() {
    return '/b2b/sheets/progress/work/update';
  },
  // 设置进度节点时间
  updateProgressDate() {
    return '/b2b/sheets/progress/work/update/progresses/date'
  },
  // 分配工单任务
  allocatingProductionOrder() {
    return '/b2b/production/task/order/update/merchandiser'
  },
  // 创建进度工单
  createProgressOrder(id) {
    return '/b2b/orders/production/work/create/' + id;
  },
  // 销售订单状态统计
  salesOrderStateCount() {
    return '/b2b/sales/production/order/state/count';
  },
  // 待接订单状态统计
  pendingOrderStateCount() {
    return '/b2b/out/order/pending/state/count';
  },
  // 生产工单状态统计
  productionOrderStateCount() {
    return '/b2b/production/task/order/state/count';
  },
  // 外发生产工单状态统计
  outProductionOrderStateCount() {
    return '/b2b/production/task/order/out/state/count';
  },
  // 外发订单状态统计
  outboundOrderStateCount() {
    return '/b2b/out/order/state/count';
  },
  // 进度工单状态统计
  progressOrderStateCount() {
    return '/b2b/orders/production/work/state/phase/count';
  },
  // 发货单状态统计
  shippingOrderStateCount() {
    return '/b2b/sheets/shipping/state/count';
  },
  // 收发货任务状态统计
  receivedispatchStateCount() {
    return '/b2b/sheets/receivedispatch/state/count';
  },
  // 退货单状态统计
  returnSheetStateCount() {
    return '/b2b/sheets/return/state/count';
  },
  // 复议单列表状态统计
  reconsiderOrderStateCount() {
    return '/b2b/sheets/reconsider/state/count';
  },
  // 对账任务列表状态统计
  reconciliationTaskStateCount() {
    return '/b2b/sheets/reconciliation_task/state/count';
  },
  // 对账单列表状态统计
  reconciliationSheetStateCount() {
    return '/b2b/sheets/reconciliation/state/count';
  },
  // 收货单列表状态统计
  receiptSheetStateCount() {
    return '/b2b/sheets/receipt/state/count';
  },
  // 对账单（收货方审核）列表状态统计
  reconciliationSheetAuditStateCount() {
    return '/b2b/sheets/reconciliation/auditState/count';
  },
  // 应收账款列表
  getReceivableList() {
    return '/b2b/payment/bill/receivables/search';
  },
  // 应收账单统计
  getReceivableCount() {
    return '/b2b/payment/bill/receivables/state/count';
  },
  // 应付账款列表
  getPaymentList() {
    return '/b2b/payment/bill/search';
  },
  // 应付账款统计
  getPaymentCount() {
    return '/b2b/payment/bill/state/count';
  },
  // 根据id获取应付单
  getPaymentDetail(id) {
    return '/b2b/payment/bill/' + id;
  },
  // 添加发票
  appendInvoice() {
    return '/b2b/payment/bill/add/invoice';
  },
  // 添加请款单
  appendPaymentRequest() {
    return '/b2b/payment/request/save';
  },
  // 请款单列表
  getPaymentRequestList() {
    return '/b2b/payment/request/search';
  },
  // 请款单状态统计
  getPaymentRequestCount() {
    return '/b2b/payment/request/state/count';
  },
  // 财务请款单
  getFinancePaymentRequest() {
    return '/b2b/payment/request/finance/search';
  },
  // 财务请款单状态统计
  getFinancePaymentRequestCount() {
    return '/b2b/payment/request/finance/state/count';
  },
  // 根据id获取请款单
  getPaymentRequestDetail(id) {
    return '/b2b/payment/request/' + id;
  },
  // 添加付款单
  appendPaymentRecord(id) {
    return '/b2b/payment/request/add/payment/records/' + id;
  },
  // 付款确认
  paymentRequestPayConfirm(id) {
    return '/b2b/payment/request/pay/confirm/' + id;
  },
  // 查询订单可请款金额
  getRequestAmount(id) {
    return '/b2b/payment/bill/amount/' + id;
  }
};

let TENANT_APIS = {
  getApparelProducts() {
    return '/b2b/products/apparel/all';
  },
  getSampleProducts() {
    return '/b2b/sample/clothes/all';
  },
  getRequirementOrders() {
    return '/b2b/orders/requirement/all';
  },
  getAllRequirementOrders() {
    return this.getRequirementOrders();
  },
  getQuotes() {
    return '/b2b/orders/quote/all';
  },
  getPurchaseOrders() {
    return '/b2b/orders/purchase/all';
  },
  getProofings() {
    return '/b2b/orders/proofing/all';
  },
  createOperationCourse() {
    return '/b2b/guideline/create';
  },
  updateOperationCourse() {
    return '/b2b/guideline/update';
  },
  deleteOperationCourse(id) {
    return '/b2b/guideline/delete/' + id;
  },
  getOperationCourses() {
    return '/b2b/guideline';
  },
  getOperationCourse(id) {
    return '/b2b/guideline/' + id;
  },
  synchronizeProgress(code, targetCode) {
    return '/b2b/orders/purchase/' + code + '/synchronizeProgress/' + targetCode;
  },
  rejectedCashOut(id) {
    return '/b2b/companyWallet/cashOutRejected/' + id;
  },
  completedCashOut(id) {
    return '/b2b/companyWallet/cashOutCompleted/' + id;
  },
  findBills() {
    return '/b2b/bill/all'
  },
  getContractsList() {
    return '/b2b/user/agreement/list';
  },
  getContractDetail(code) {
    return '/b2b/user/agreement/get/' + code;
  },
  getSeals() {
    return '/b2b/user/seal/list';
  },
  getTemplatesListPt() {
    return '/b2b/agreement/temp/list';
  },
  getTemplates(code) {
    return '/b2b/user/agreement/temp/get/' + code;
  },
  getTemplatesList() {
    return '/b2b/user/agreement/temp/list';
  },
  saveTemplate() {
    return '/b2b/user/agreement/temp/save';
  },
  deleteTemplate(code) {
    return '/b2b/user/agreement/temp/delete/' + code;
  },
  saveSeal() {
    return '/b2b/user/seal/save';
  },
  delSeal(code) {
    return '/b2b/user/seal/delete/' + code;
  },
  saveContract() {
    return '/b2b/user/agreement/save';
  },
  // saveContract () {
  //   return '/b2b/user/agreement/save';
  // },
  personalAuthentication() {
    return '/b2b/fdd/api/save/personal/verify/data';
  },
  enterpriseAuthentication() {
    return '/b2b/fdd/api/save/enterprise/verify/data';
  },
  getAuthenticationState() {
    return '/b2b/cert/state';
  },
  getAuthenticationInfo() {
    return '/b2b/cert/personal/cert/info';
  },
  getAuthenticationEnterprise() {
    return '/b2b/cert/enterprise/cert/info';
  },
  refuseContract(code) {
    return '/b2b/user/agreement/reject/sign/' + code;
  },
  revokeContract(code) {
    return '/b2b/user/agreement/revoke/' + code;
  },
  previewPdf(code) {
    return '/b2b/user/agreement/preview/pdf/' + code;
  },
  orderContractClick() {
    return '/b2b/user/agreement/order/validate';
  },
  platformOffShelfProduct(code) {
    return '/b2b/products/apparel/' + code + '/platformOff';
  },
  platformDeletedShelfProduct(code) {
    return '/b2b/products/apparel/' + code + '/platformDeleted';
  },
  platformCancelledRequirementOrder(code) {
    return '/b2b/orders/requirement/platformCancelled/' + code;
  },
  platformCancelQuote(code) {
    return '/b2b/orders/quote/' + code + '/platformCancel';
  },
  platformCancellingOfProofing(code) {
    return '/b2b/orders/proofing/' + code + '/platformCancelling';
  },
  forbiddenCompany(uid) {
    return '/b2b/companies/forbidden/' + uid;
  },
  cannelForbiddenCompany(uid) {
    return '/b2b/companies/cannelForbidden/' + uid;
  },
  // 根据类型获取活动产品页面信息
  getProductPlate(type) {
    return '/b2b/products/plate/' + type;
  },
  createProductPlate() {
    return '/b2b/products/plate/create';
  },
  // 获取轮播图
  getCarouselsList(type) {
    return '/b2b/carousels/list/' + type;
  },
  updateAllCarousels() {
    return '/b2b/carousels/updateAll';
  },

  //销售计划
  salesPlanSave(needAudit) {
    return '/b2b/sales/production/order/save?submitAudit=' + needAudit;
  },

  //销售订单
  salesOrderSave(needAudit) {
    return '/b2b/sales/production/order/save/order?submitAudit=' + needAudit;
  },
};
Object.assign(TENANT_APIS, COMMON_APIS);

let NONE_TENANT_APIS = {
  getApparelProducts() {
    return '/b2b/products/apparel';
  },
  getSampleProducts() {
    return '/b2b/sample/clothes';
  },
  deleteSampleProduct(code) {
    return '/b2b/sample/clothes/' + code + '/deleted';
  },
  getRequirementOrders() {
    return '/b2b/orders/requirement';
  },
  getAllRequirementOrders() {
    return '/b2b/orders/requirement/all';
  },
  getQuotes() {
    return '/b2b/orders/quote';
  },
  getPurchaseOrders() {
    return '/b2b/orders/purchase/search';
  },
  //   getPurchaseOrders() {
  //   return '/b2b/orders/purchase';
  // },
  confirmDeliveringOfProductionOrder(code) {
    return '/b2b/orders/purchase/' + code + '/delivering';
  },
  getProofings() {
    return '/b2b/orders/proofing';
  },
  confirmDeliveringOfProofing(code) {
    return '/b2b/orders/proofing/' + code + '/delivering';
  },
  cancellingOfProofing(code) {
    return '/b2b/orders/proofing/' + code + '/cancelling';
  },
  cancellingOfPurchaseOrder(code) {
    return '/b2b/orders/purchase/' + code + '/cancelling';
  },
  changeCannelStatus(code) {
    return '/b2b/orders/purchase/' + code + '/changeCannelStatus';
  },
  completedOfPurchaseOrder(code) {
    return '/b2b/orders/purchase/' + code + '/shipped';
  },
  completedOfProofing(code) {
    return '/b2b/orders/proofing/' + code + '/shipped';
  },
  payProofings(code) {
    return '/b2b/orders/proofing/' + code + '/paid';
  },
  payProofingsImage(code) {
    return '/b2b/checkout/multi/wechat/pay/' + code;
  },
  cashOutCanceled(code) {
    return '/b2b/checkout/multi/wechat/pay/' + code;
  },
  cashOutApply(amount) {
    return '/b2b/amountFlow/cashOut/' + amount;
  },
  getBills() {
    return '/b2b/bill';
  },
  getWallet() {
    return '/b2b/companyWallet';
  },
  getContractsList() {
    return '/b2b/user/agreement/list';
  },
  getSealsList() {
    return '/b2b/user/seal/list';
  },
  getTemplatesListPt() {
    return '/b2b/agreement/temp/list';
  },
  getTemplates(code) {
    return '/b2b/user/agreement/temp/get/' + code;
  },
  getTemplatesList() {
    return '/b2b/user/agreement/temp/list';
  },
  saveTemplate() {
    return '/b2b/user/agreement/temp/save';
  },
  deleteTemplate(code) {
    return '/b2b/user/agreement/temp/delete/' + code;
  },
  saveSeal() {
    return '/b2b/user/seal/save';
  },
  delSeal(code) {
    return '/b2b/user/seal/delete/' + code;
  },
  saveContract() {
    return '/b2b/user/agreement/save';
  },
  deleteContract(code) {
    return '/b2b/user/agreement/delete/' + code;
  },
  downContract(code) {
    return '/b2b/user/agreement/get/download/token/' + code;
  },
  flowContract(code, sealCode) {
    return '/b2b/user/agreement/start/flow/' + code + '?sealCode=' + sealCode;
  },
  personalAuthentication() {
    return '/b2b/fdd/api/save/personal/verify/data';
  },
  enterpriseAuthentication() {
    return '/b2b/fdd/api/save/enterprise/verify/data';
  },
  getAuthenticationState() {
    return '/b2b/cert/state';
  },
  getAuthenticationInfo() {
    return '/b2b/cert/personal/cert/info';
  },
  getAuthenticationEnterprise() {
    return '/b2b/cert/enterprise/cert/info';
  },
  getContractDetail(code) {
    return '/b2b/user/agreement/get/' + code;
  },
  refuseContract(code) {
    return '/b2b/user/agreement/reject/sign/' + code;
  },
  revokeContract(code) {
    return '/b2b/user/agreement/revoke/' + code;
  },
  previewPdf(code) {
    return '/b2b/user/agreement/preview/pdf/' + code;
  },
  orderContractClick() {
    return '/b2b/user/agreement/order/validate';
  },
  getOldSalesOrderList() {
    return '/b2b/b2b/orders/sales';
  },
  getSalesOrderDetails(code) {
    return '/b2b/b2b/orders/sales/' + code;
  },
  updateConsignment(code) {
    return '/b2b/b2b/orders/sales/update/consignment/' + code;
  },
  cannelSalesOrder(code) {
    return '/b2b/b2b/orders/sales/' + code + '/cancel/order';
  },
  confirmReceived(code) {
    return '/b2b/b2b/orders/sales/' + code + '/confirmReceived';
  },
  orderRefundApply() {
    return '/b2b/sales/order/refund/apply';
  },
  getRefundDetail(code) {
    return '/b2b/sales/order/refund/apply/' + code;
  },
  auditRefundApply() {
    return '/b2b/sales/order/refund/audit/apply';
  },
  cancelRefundApply(code) {
    return '/b2b/sales/order/refund/apply/cancel/' + code;
  },
  reminderSalesOrderDelivery(code) {
    return '/b2b/b2b/orders/sales/' + code + '/reminder/delivery';
  },


  //销售计划
  salesPlanSave(needAudit) {
    return '/b2b/sales/production/order/save?submitAudit=' + needAudit;
  },
  //销售订单
  salesOrderSave(needAudit) {
    return '/b2b/sales/production/order/save/order?submitAudit=' + needAudit;
  },
  // 更新销售订单行
  updateSalesOrderRow() {
    return '/b2b/sales/production/order/update/entry';
  },
  //销售计划撤回
  salesPlanWithdraw(id) {
    return '/b2b/sales/production/order/revoke/audit/' + id;
  },
  //拒绝销售订单
  refuseSalesOrder(id) {
    return '/b2b/sales/production/order/reject/outboundOrder/' + id;
  },
  //唯一码导入销售订单
  importSalesOrderByUniqueCode(code) {
    return '/b2b/sales/production/order/create/from/uniqueCode/' + code;
  },
  //销售计划订单列表
  getSalesOrderList() {
    return '/b2b/sales/production/order/search';
  },
  //待接销售订单列表
  getPendingSalesOrderList() {
    return '/b2b/out/order/pending/accept/search';
  },
  //销售计划订单详情
  getSalesProductionOrderDetails(id) {
    return '/b2b/sales/production/order/' + id;
  },
  //生产任务
  getProductionTaskList() {
    return '/b2b/production/task/search';
  },
  //生产任务详情
  getProductionTaskDetails(id) {
    return '/b2b/production/task/detail/' + id;
  },
  //生产工单
  getProductionOrders() {
    return '/b2b/production/task/order/search';
  },
  //生产工单详情
  getProductionOrderDetail(id) {
    return '/b2b/production/task/order/' + id;
  },

  //设置生产进度预计完成时间
  setProgressDate(code) {
    return '/b2b/sheets/progress/work/' + code + '/update/progresses';
  },

  //节点完成
  finshProgress(code, id) {
    return '/b2b/sheets/progress/work/' + code + '/finish/progress/' + id;
  },

  //外发订单生成唯一码
  generateUniqueCodeForSale(code) {
    return '/b2b/orders/outbound/' + code + '/unique';
  },

  //根据任务id查生产订单
  searchProductionByTaskIds() {
    return '/b2b/orders/production/work/search';
  },

  //根据任务id查外发订单
  searchPurchaseByTaskIds() {
    return '/b2b/orders/outbound/search';
  },

  // 创建发货单================================新生产工单
  createShippingOrderV2(code) {
    return '/b2b/orders/production/work/' + code + '/createShippingOrder';
  },
  // 创建全部发货单
  confirmShippingV2(code) {
    return '/b2b/orders/production/work/' + code + '/confirmShipping';
  },
  // 删除发货单
  deleteShippingOrderV2(id) {
    return '/b2b/orders/production/work/deleteShippingOrder/' + id;
  },
  // 创建收货单
  createDeliveryOrderV2(code) {
    return '/b2b/orders/production/work/' + code + '/createDeliveryOrder';
  },
  // 创建并提交收货单
  createAndCommitDeliveryOrderV2(code) {
    return '/b2b/orders/production/work/' + code + '/createAndCommitDeliveryOrder';
  },
  // 提交收货单
  commitDeliveryOrderV2() {
    return '/b2b/orders/production/work/commitDeliveryOrder';
  },
  // 保存收货单
  updateDeliveryOrderV2() {
    return '/b2b/orders/production/work/updateDeliveryOrder';
  },
  // 撤回收货单
  withdrawDeliveryOrderV2(code) {
    return '/b2b/orders/production/work/' + code + '/recallDelivery';
  },
  // 确认收货单
  confirmDeliveryOrderV2(code) {
    return '/b2b/orders/production/work/' + code + '/confirmDelivery';
  },
  // 拒绝收货单
  rejectDeliveryOrderV2(code) {
    return '/b2b/orders/production/work/' + code + '/rejectDelivery';
  },
  // 创建对账单
  createReconciliationOrderV2(code) {
    return '/b2b/orders/production/work/' + code + '/createReconciliationOrder';
  },
  // 创建并提交对账单
  createAndCommitReconciliationOrderV2(code) {
    return '/b2b/orders/production/work/' + code + '/createAndCommitReconciliationOrder';
  },
  // 保存
  updateReconciliationOrderV2() {
    return '/b2b/orders/production/work/updateReconciliationOrder';
  },
  // 保存并提交
  updateAndCommitReconciliationOrderV2() {
    return '/b2b/orders/production/work/updateAndCommitReconciliationOrder';
  },
  // 提交对账单
  commitReconciliationOrderV2() {
    return '/b2b/orders/production/work/commitReconciliationOrder';
  },
  // 撤回对账单
  withdrawReconciliationOrderV2() {
    return '/b2b/orders/production/work/recallReconciliationOrder';
  },
  // 确认对账单
  confirmReconciliationV2(code) {
    return '/b2b/orders/production/work/' + code + '/confirmReconciliation';
  },
  // 拒绝对账单
  rejectReconciliationV2(code) {
    return '/b2b/orders/production/work/' + code + '/rejectReconciliation';
  },


  /**---------------       收发货           ---------------**/

  // 收发任务列表
  shippingTaskList() {
    return '/b2b/sheets/receivedispatch';
  },

  // 收发任务详情
  shippingTaskDetail(id) {
    return '/b2b/sheets/receivedispatch/' + id;
  },

  // 发货单列表
  shippingOrderList() {
    return '/b2b/sheets/shipping';
  },

  // 发货完结
  shippingFinish(id) {
    return '/b2b/sheets/receivedispatch/finishDelivery/' + id;
  },

  // 发货单详情
  shippingOrderDetail(id) {
    return '/b2b/sheets/shipping/' + id;
  },

  // 创建发货单
  shippingOrderCreate() {
    return '/b2b/sheets/shipping/create';
  },

  //创建收货单
  receiptOrderCreate() {
    return '/b2b/sheets/receipt/create';
  },

  //创建自管收货单
  selfReceiptOrderCreate() {
    return '/b2b/sheets/receipt/createByTask';
  },

  //收货单列表
  receiptOrderList() {
    return '/b2b/sheets/receipt';
  },

  // 收货单详情
  receiptOrderDetail(id) {
    return '/b2b/sheets/receipt/' + id;
  },

  // 创建退货单
  returnOrderCreate() {
    return '/b2b/sheets/return/create';
  },

  // 跳过退货
  cancelReturn(id) {
    return '/b2b/sheets/shipping/cancelReturn/' + id;
  },

  // 跳过复议
  cancelReconsider(id) {
    return '/b2b/sheets/shipping/cancelReconsider/' + id;
  },

  // 退货单详情
  returnOrderDetail(id) {
    return '/b2b/sheets/return/' + id;
  },

  // 退货单列表
  returnOrderList() {
    return '/b2b/sheets/return';
  },

  //确认退货单
  confirmReturnOrder(id) {
    return '/b2b/sheets/return/confirm/' + id;
  },

  //创建复议单
  reconsiderOrderCreate() {
    return '/b2b/sheets/reconsider/create';
  },


  //复议单列表
  reconsiderOrderList() {
    return '/b2b/sheets/reconsider';
  },

  //复议单详情
  reconsiderOrderDetail(id) {
    return '/b2b/sheets/reconsider/' + id;
  },

  //同意复议单
  acceptReconsider() {
    return '/b2b/sheets/reconsider/confirm';
  },

  //拒绝复议单
  rejectReconsider(id) {
    return '/b2b/sheets/reconsider/reject/' + id;
  },

  //==========================================对账单

  //对账任务列表
  reconciliationTaskList() {
    return '/b2b/sheets/reconciliation_task';
  },

  //对账任务详情
  reconciliationTaskDetail(id) {
    return '/b2b/sheets/reconciliation_task/' + id;
  },

  //创建对账单
  reconciliationCreate() {
    return '/b2b/sheets/reconciliation/create';
  },

  //更新对账单
  reconciliationUpdate() {
    return '/b2b/sheets/reconciliation/update';
  },

  //对账单列表
  reconciliationList() {
    return '/b2b/sheets/reconciliation';
  },

  //对账详情
  reconciliationDetail(id) {
    return '/b2b/sheets/reconciliation/' + id;
  },

  //确认对账
  reconciliationAccept(id) {
    return '/b2b/sheets/reconciliation/confirm/' + id;
  },

  //拒绝对账
  reconciliationReject(id) {
    return '/b2b/sheets/reconciliation/reject/' + id;
  },

  //唯一码检索
  uniqueCodeCheck(code) {
    return '/b2b/out/order/preview/' + code;
  },

  //外发订单-取消订单
  outboundOrderCancel() {
    return '/b2b/out/order/cancel';
  },

  //自创外接订单-取消订单
  saleOrderProductionCancel() {
    return '/b2b/sales/production/order/cancel';
  },

  //外发订单-取消订单-处理
  outboundOrderCancelHandle() {
    return '/b2b/out/order/handling/cancel';
  },

  //外发订单-撤回
  outboundOrderWithdraw(id) {
    return '/b2b/out/order/revoke/' + id;
  },

  //订单-作废
  outboundOrderDelete(id) {
    return '/b2b/sales/production/order/' + id;
  },

  //批量导入样衣
  muliteClothesCreate() {
    return '/b2b/sample/clothes/multiple/all/create';
  },
};
Object.assign(NONE_TENANT_APIS, COMMON_APIS);

export {
  TENANT_APIS,
  NONE_TENANT_APIS
}
