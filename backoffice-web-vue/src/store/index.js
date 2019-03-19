import Vue from 'vue';
import Vuex from 'vuex';

Vue.use(Vuex);

import {
  EnumsModule,
  UsersModule,
  UserGroupsModule,
  RolesModule,
  EmployeesModule,
  FactoriesModule,
  BrandsModule,
  IndustrialClustersModule,
  LabelsModule,
  ColorsModule,
  SizesModule,
  CategoriesModule,
  ApparelProductsModule,
  RequirementOrdersModule,
  PurchaseOrdersModule,
  QuotesModule,
  ProofingsModule
} from './modules';

import {
  BrandEmployeesModule,
  BrandMembersModule,
  BrandMemberRequestsModule,
  BrandOrgsModule,
  BrandRolesModule,
} from './brand/modules';

import {
  FactoryEmployeesModule,
  FactoryOrgsModule,
  FactoryRolesModule,
} from './factory/modules';

// 状态管理
const state = {
  sideSliderState: false,
  timeout: false
};

const getters = {};

// mutations
const mutations = {
  sideSliderState_get(state, payload) {
    // 类别
    state.sideSliderState = payload;
  },
};

// actions
const actions = {
  sideSliderState_set({dispatch, commit, state}, payload) {
    commit('sideSliderState_get', payload);
  }
};

export default new Vuex.Store({
  modules: {
    EnumsModule,
    // tenant
    UsersModule,
    UserGroupsModule,
    RolesModule,
    EmployeesModule,
    FactoriesModule,
    BrandsModule,
    IndustrialClustersModule,
    LabelsModule,
    ColorsModule,
    SizesModule,
    CategoriesModule,
    ApparelProductsModule,
    RequirementOrdersModule,
    PurchaseOrdersModule,
    QuotesModule,
    ProofingsModule,
    // brand
    BrandEmployeesModule,
    BrandMembersModule,
    BrandMemberRequestsModule,
    BrandOrgsModule,
    BrandRolesModule,
    // factory
    FactoryEmployeesModule,
    FactoryOrgsModule,
    FactoryRolesModule,
  },
  state,
  getters,
  mutations,
  actions
});
