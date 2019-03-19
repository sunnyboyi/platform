const COMMON_APIS = {
  // 小类，级联（二级）
  getMinorCategories() {
    return '/b2b/categories/cascaded';
  },
  getMajorCategories() {
    return '/b2b/categories/majors';
  },
  getAllStyles() {
    return '/djwebservices/styles/all';
  },
  getAllColors() {
    return '/djwebservices/colors/all';
  },
  getAllSizes() {
    return '/djwebservices/sizes/all';
  },
  getApparelProduct(code) {
    return '/b2b/products/apparel/' + code;
  },
  createApparelProduct() {
    return '/b2b/products/apparel/create';
  },
  getPurchaseOrder(code) {
    return '/b2b/orders/requirement/' + code;
  },
  createPurchaseOrder() {
    return '/b2b/orders/requirement/new';
  },
  removeMedia(mediaID) {
    return '/djwebservices/media/' + mediaID
  }
};

let TENANT_APIS = {
  getApparelProducts() {
    return '/b2b/products/apparel/all';
  },
  getPurchaseOrders() {
    return '/b2b/orders/requirement/all';
  }
};
Object.assign(TENANT_APIS, COMMON_APIS);

let NON_TENANT_APIS = {
  getApparelProducts() {
    return '/b2b/products/apparel';
  },
  getPurchaseOrders() {
    return '/b2b/orders/requirement';
  },
};
Object.assign(NON_TENANT_APIS, COMMON_APIS);

export {
  TENANT_APIS,
  NON_TENANT_APIS
}
