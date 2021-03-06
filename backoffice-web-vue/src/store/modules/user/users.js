import axios from 'axios';
import http from '@/common/js/http';
import router from '@/router';
import {
  createNamespacedHelpers
} from 'vuex';

const CLIENT_ID = 'nbyjy';
const CLIENT_SECRET = 'password';
const GRANT_TYPE_PASSWORD = 'password';
const GRANT_TYPE_REFRESH_TOKEN = 'refresh_token';

const state = {
  currentUser: null,
  authorized: false,
  token: '',
  expiresIn: 0,
  refreshToken: '',
  authenticationInfo: {
    companyState: '',
    companyType: '',
    personalState: ''
  },
  permissions: [],
  dataPermission: []
};
const mutations = {
  authorized(state, authorized) {
    sessionStorage.setItem('authorized', authorized);
    state.authorized = authorized;
  },
  token(state, token) {
    sessionStorage.setItem('token', token);
    state.token = token;
  },
  expiresIn(state, expiredIn) {
    localStorage.setItem('expiresIn', expiredIn);
    state.expiresIn = expiredIn;
  },
  refreshToken(state, refreshToken) {
    localStorage.setItem('refreshToken', refreshToken);
    state.refreshToken = refreshToken;
  },
  currentUser(state, currentUser) {
    sessionStorage.setItem('currentUser', JSON.stringify(currentUser));
    state.currentUser = currentUser;
  },
  authenticationInfo(state, authenticationInfo) {
    sessionStorage.setItem('authenticationInfo', JSON.stringify(authenticationInfo));
    state.authenticationInfo = authenticationInfo;
  },
  permissions(state, permissions) {
    sessionStorage.setItem('permissions', JSON.stringify(permissions));
    state.permissions = permissions;
  },
  dataPermission(state, data) {
    if (data != null && data.length > 0) {
      let dataPermission = {};
      data.forEach(item => {
        dataPermission[item.code] = item.permission;
      })
      sessionStorage.setItem('dataPermission', JSON.stringify(dataPermission));
      state.dataPermission = dataPermission;
    }
  }
};
const actions = {
  async login({
    dispatch,
    commit,
    state
  }, {
    username,
    password
  }) {
    const response = await http.post('/authorizationserver/oauth/token?' +
      'username=' + username +
      '&password=' + password +
      '&client_id=' + CLIENT_ID +
      '&client_secret=' + CLIENT_SECRET +
      '&grant_type=' + GRANT_TYPE_PASSWORD);

    //请求报错
    if (response['errors']) {
      alert(response['errors'][0].message);
      return;
    }

    //密码校验不正确
    if (response['error']) {
      console.log(JSON.stringify(response));
      if (response['error'] == 'invalid_grant') {
        alert('账号密码不正确');
      }
      return;
    }

    //其他情况
    if (!response['access_token']) {
      alert('网络连接错误');
      return;
    }


    axios.defaults.headers.common['Authorization'] = 'Bearer ' + response['access_token'];

    commit('token', response['access_token']);
    commit('expiresIn', response['expires_in']);
    commit('refreshToken', response['refresh_token']);
    commit('authorized', true);

    // 获取当前登录用户信息
    const userInfo = await http.get('/b2b/users/' + username + '/profile');
    axios.defaults.headers.common['company'] = userInfo['companyCode'];
    // 'type' : 'TENANT', 'BRAND', 'FACTORY',
    // userInfo['type'];
    // console.log(JSON.stringify(userInfo));
    commit('currentUser', userInfo);

    // 获取认证信息
    // const url = this.apis().getAuthenticationState();
    const result = await http.get('/b2b/cert/state');
    if (!result['errors']) {
      commit('authenticationInfo', result.data);

    }

    // 获取用户权限
    const uid = state.currentUser.uid;
    const res = await http.get('/b2b/b2bCustomers/role/' + uid);
    if (res.code === 0) {
      this.$message.error(res.msg);
      return;
    }
    commit('permissions', res.data.roleList);
    commit('dataPermission', res.data.dataPermissionList);
    //存储登录用户username

    //分割子账号名称
    let strArray = username.split(':');
    localStorage.setItem('userName', strArray[0]);
    if (strArray.length == 2) {
      localStorage.setItem('employeeUserName', strArray[1]);
    }
    router.push('/');
  },
  async getProfile({
    dispatch,
    commit,
    state
  }, {
    uid
  }) {
    console.log(JSON.stringify(state.currentUser));
    // 获取当前登录用户信息
    const userInfo = await http.get('/b2b/users/' + uid + '/profile');
    axios.defaults.headers.common['company'] = userInfo['companyCode'];
    commit('currentUser', userInfo);

    // 获取认证信息
    // const url = this.apis().getAuthenticationState();
    const result = await http.get('/b2b/cert/state');
    if (!result['errors']) {
      commit('authenticationInfo', result.data);
    }
    location.reload();
  },
  async refreshToken({
    dispatch,
    commit,
    state
  }) {
    const response = await http.post('/authorizationserver/oauth/token?' +
      '&client_id=' + CLIENT_ID +
      '&client_secret=' + CLIENT_SECRET +
      '&grant_type=' + GRANT_TYPE_REFRESH_TOKEN +
      '&refresh_token=' + state.refreshToken);
    if (response['errors']) {
      alert(response['errors'][0].message);
      return;
    }
    axios.defaults.headers.common['Authorization'] = 'Bearer ' + response['access_token'];
    commit('token', response['access_token']);
    commit('expiresIn', response['expires_in']);
    commit('refreshToken', response['refresh_token']);
  }
};
const getters = {
  currentUser() {
    if (!state.currentUser) {
      return JSON.parse(sessionStorage.getItem('currentUser'));
    }
    return state.currentUser;
  },
  token() {
    return 'Bearer ' + sessionStorage.getItem('token');
    // return 'Bearer ' + state.token;
  },
  authenticationInfo(){
    return JSON.parse(sessionStorage.getItem('authenticationInfo'));
  },
  permissions() {
    if (state.permissions.length <= 0) {
      return JSON.parse(sessionStorage.getItem('permissions'));
    }
    return state.permissions;
  },
  dataPermission() {
    if (state.dataPermission.length <= 0) {
      return JSON.parse(sessionStorage.getItem('dataPermission'));
    }
    return state.dataPermission;
  }
};

export default {
  /* namespaced: true, */
  state,
  mutations,
  actions,
  getters
}
