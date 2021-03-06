export default {
  items: [
    // {
    //   title: true,
    //   name: '平台',
    //   class: '',
    //   wrapper: {
    //     element: 'span',
    //     attributes: {}
    //   }
    // },
    {
      name: '主页',
      url: '/dashboard',
      icon: 'el-icon-s-home'
    },
    {
      name: '产品',
      url: '/product',
      icon: 'el-icon-goods',
      children: [{
          name: '服装产品',
          url: '/product/apparel',
          icon: 'iconNone'
        },
        {
          name: '分类',
          url: '/product/category',
          icon: 'iconNone'
        },
        {
          name: '颜色',
          url: '/product/color',
          icon: 'iconNone'
        },
        {
          name: '尺码',
          url: '/product/size',
          icon: 'iconNone'
        }
      ]
    },
    {
      name: '商家',
      url: '/backoffice/customer',
      icon: 'el-icon-money',
      children: [{
          name: '品牌',
          url: '/user/brand',
          icon: 'iconNone'
        },
        {
          name: '工厂',
          url: '/user/factory',
          icon: 'iconNone'
        },
      ]
    },
    {
      name: '订单',
      icon: 'el-icon-s-order',
      url: '/order',
      children: [{
          name: '需求订单',
          url: '/order/requirement',
          icon: 'iconNone'
        },
        {
          name: '报价单',
          url: '/order/quote',
          icon: 'iconNone'
        },
        {
          name: '生产订单',
          url: '/order/purchase',
          icon: 'iconNone'
        },
        {
          name: '打样订单',
          url: '/order/proofing',
          icon: 'iconNone'
        },
      ]
    },
    {
      name: '公司',
      url: '/account',
      icon: 'el-icon-user-solid',
      children: [
        {
          name: '员工',
          url: '/account/employee',
          icon: 'el-icon-user'
        },
        {
          name: '用户组',
          url: '/account/user-group',
          icon: 'iconNone'
        },
        {
          name: '角色',
          url: '/account/role',
          icon: 'iconNone'
        }
      ]
    },
    // {
    //   name: '报表',
    //   url: '/report',
    //   icon: 'el-icon-s-data',
    //   children: [{
    //       name: '生产进度',
    //       url: '/report/production-progress',
    //       icon: 'iconNone',
    //     },
    //     // {
    //     //   name: '收货单',
    //     //   url: 'receipt',
    //     //   icon: 'iconNone',
    //     // },
    //   ]
    // },
    {
      name: '其他',
      url: '/miscs',
      icon: 'el-icon-coin',
      children: [
        // {
        //   name: '合同',
        //   icon: 'iconNone',
        //   children: [{
        //       name: '合同',
        //       url: '/contract/manage/contract',
        //       icon: 'iconNone',
        //     },
        //     {
        //       name: '合同模板',
        //       url: '/contract/template/template',
        //       icon: 'iconNone',
        //     },
        //     {
        //       name: '印章',
        //       url: '/contract/seal/seal',
        //       icon: 'iconNone',
        //     },
        //   ]
        // },
        {
          name: '轮播图配置',
          url: '/miscs/carousel',
          icon: 'iconNone'
        },
        {
          name: '产业集群配置',
          url: '/miscs/industrial-cluster',
          icon: 'iconNone'
        },
        {
          name: '标签配置',
          url: '/miscs/label',
          icon: 'iconNone'
        },
        {
          name: '使用教程',
          url: '/miscs/operationCourse',
          icon: 'iconNone'
        },
        {
          name: '提现',
          url: '/miscs/cashOutManager',
          icon: 'iconNone',
        },
        {
          name: '产品运营活动',
          url: '/miscs/promote',
          icon: 'iconNone',
        },
        // {
        //   name: '未分类',
        //   icon: 'iconNone',
        //   children: [{
        //       name: '下单',
        //       url: '/orderPurchase',
        //       icon: 'iconNone',
        //     },
        //     {
        //       name: '印章',
        //       url: '/unclassified/sealManagement',
        //       icon: 'iconNone',
        //     },
        //     // {
        //     //   name: '创建合同',
        //     //   url: '/unclassified/createContract',
        //     //   icon: 'iconNone',
        //     // },
        //     {
        //       name: '合同模板',
        //       url: '/unclassified/contractTemplate',
        //       icon: 'iconNone',
        //     }
        //   ]
        // },
      ]
    }
  ]
};
