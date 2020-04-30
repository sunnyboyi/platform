export default {
  items: [
    // {
    //   title: true,
    //   name: '云工厂',
    //   class: '',
    //   wrapper: {
    //     element: 'span',
    //     attributes: {}
    //   }
    // },
    {
      name: '首页',
      url: '/dashboard',
      icon: 'el-icon-s-home'
    },
    {
      name: '订单',
      url: '/order',
      icon: 'el-icon-s-order',
      children: [{
          name: '报价订单',
          url: '/order/quote',
          icon: 'iconNone',
          meta: {
            requiresAuth: true,
            permissions: ['QUOTE_ORDER']
          }
        },
        {
          name: '打样订单',
          url: '/order/proofing',
          icon: 'iconNone',
          meta: {
            requiresAuth: true,
            permissions: ['PROOFING_ORDER']
          }
        },
        {
          name: '生产订单',
          url: '/order/purchase',
          icon: 'iconNone',
          meta: {
            requiresAuth: true,
            permissions: ['PURCHASE_ORDER']
          }
        },
        {
          name: '销售订单',
          url: '/order/sales',
          icon: 'iconNone',
        },
        {
          name: '销售计划',
          url: '/order/salesProduction',
          icon: 'iconNone',
        }
        // {
        //   name: '生产进度',
        //   url: '/order/production',
        //   icon: 'iconNone'
        // }
      ]
    },
    {
      name: '合同',
      url: '/contract',
      icon: 'el-icon-s-marketing',
      children: [{
          name: '合同管理',
          url: '/contract/manage',
          icon: 'iconNone',
          meta: {
            requiresAuth: true,
            permissions: ['AGREEMENT']
          }
        },
        {
          name: '合同模板',
          url: '/contract/template',
          icon: 'iconNone',
          meta: {
            requiresAuth: true,
            permissions: ['AGREEMENT_TMPL']
          }
        },
        {
          name: '签章管理',
          url: '/contract/seal',
          icon: 'iconNone',
          meta: {
            requiresAuth: true,
            permissions: ['AGREEMENT_SEAL']
          }
        },
        // {
        //   name: '下单',
        //   url: '/orderPurchase',
        //   icon: 'iconNone',
        // },
        // {
        //   name: '创建合同',
        //   url: '/manage/createContract',
        //   icon: 'iconNone',
        // },
        // {
        //   name: 'markdown',
        //   url: '/unclassified/markDown',
        //   icon: 'iconNone',
        // },
      ]
    },
    // {
    //   name: '其他',
    //   url: '/miscs',
    //   children: [
    //     {
    //       name: '样衣管理',
    //       icon: 'fa fa-check',
    //       children: [
    //         {
    //           name: '样衣',
    //           url: '/miscs/sample/sampleProduct',
    //           icon: 'iconNone',
    //         },
    //         {
    //           name: '样衣借还记录',
    //           url: '/miscs/sample/sampleCheckoutHist',
    //           icon: 'iconNone',
    //         }
    //       ]
    //     },
    //     {
    //       name: '供应商',
    //       url: '/miscs/supplier',
    //       icon: 'iconNone',
    //     },
    //     {
    //       name: '钱包',
    //       url: '/miscs/wallet',
    //       icon: 'iconNone',
    //     }
    //   ]
    // },
    {
      name: '产品',
      url: '/product',
      icon: 'el-icon-goods',
      children: [{
          name: '产品管理',
          url: '/product/apparel',
          icon: 'iconNone',
          meta: {
            requiresAuth: true,
            permissions: ['PRODUCT']
          }
        },
        {
          name: '样衣管理',
          url: '/product/sample',
          icon: 'iconNone',
          // meta: {
          //   requiresAuth: true,
          //   permissions: ['PRODUCT_SAMPLEPRODUCT']
          // }
        },
        // {
        //   name: '样衣借还记录',
        //   url: '/miscs/sample/sampleCheckoutHist',
        //   icon: 'iconNone',
        // }
        {
          name: '产能配置',
          url: '/product/capacity',
          icon: 'iconNone',
          meta: {
            requiresAuth: true,
            permissions: ['FACTORY_CAPACITY']
          }
        },
        {
          name: '物料管理',
          url: '/product/material',
          icon: 'iconNone',
        }
      ]
    },
    {
      name: '公司',
      url: '/account',
      icon: 'el-icon-office-building',
      children: [
        // {
        //   name: '认证信息',
        //   url: '/account/authentication',
        //   icon: 'iconNone'
        // },
        {
          name: '主页',
          url: '/account/index',
          icon: 'iconNone',
          meta: {
            requiresAuth: true,
            permissions: ['ENT_INFO']
          }
        },
        {
          name: '认证中心',
          url: '/account/Authentication',
          icon: 'iconNone',
          meta: {
            requiresAuth: true,
            permissions: ['CERT']
          }
        },
        // {
        //   name: '员工',
        //   url: '/account/b2b-customer',
        //   icon: 'iconNone',
        //   meta: {
        //     requiresAuth: true,
        //     permissions: ['COMPANY_B2BCUSTOMER']
        //   }
        // },
        {
          name: '合作商',
          url: '/account/cooperator',
          icon: 'iconNone',
          meta: {
            requiresAuth: true,
            permissions: ['COMPANY_COOPERATOR']
          }
        },
        // {
        //   name: '组织架构',
        //   url: '/account/b2b-unit',
        //   icon: 'iconNone'
        // },
        // {
        //   name: '角色',
        //   url: '/account/role',
        //   icon: 'iconNone'
        // },
        {
          name: '地址管理',
          url: '/account/address',
          icon: 'iconNone',
          meta: {
            requiresAuth: true,
            permissions: ['COMPANY_ADDRESS']
          }
        },
        {
          name: '账务配置',
          url: '/account/setting/payPlan',
          icon: 'iconNone',
          meta: {
            requiresAuth: true,
            permissions: ['FACTORY_PAYPLAN']
          }
        },
      ]
    },
    {
      name: '报表',
      url: '/report',
      icon: 'el-icon-s-data',
      children: [{
          name: '生产进度',
          url: '/report/production-progress',
          icon: 'iconNone',
          meta: {
            requiresAuth: true,
            permissions: ['REPORT_PRODUCTION_PROGRESS']
          }
        },
        // {
        //   name: '收货单',
        //   url: '/report/receipt',
        //   icon: 'iconNone',
        // },
      ]
    },
    {
      name: '其他',
      url: '/miscs',
      icon: 'el-icon-coin',
      children: [{
        name: '钱包',
        url: '/miscs/wallet',
        icon: 'iconNone',
        meta: {
          requiresAuth: true,
          permissions: ['COMPANY_WALLET']
        }
      }]
    }
  ]
}
