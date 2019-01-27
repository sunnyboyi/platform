// The Vue build version to load with the `import` command
// (runtime-only or standalone) has been set in webpack.base.conf with an alias.
import Vue from "vue";
import BootstrapVue from "bootstrap-vue";
import ElementUI from "element-ui";
import router from "./router";
import store from "./store/index.js";
import {formatDate, enumTranslate,timestampToTime,postponedDays} from "./common/js/filters";
import HttpServletPlugin from "./plugins/HttpServletPlugin.js";
import http from "./common/js/http";

import App from "./App";

//时间过滤器
Vue.filter("formatDate", time => {
  if (time === null) {
    return "";
  }
  let date = new Date(time);
  return formatDate(date, "yyyy-MM-dd hh:mm");
});
Vue.filter("enumTranslate", (enumVal, enumType) => {
  return enumTranslate(enumVal, enumType);
});
//时间戳转成日期字符串格式
Vue.filter("timestampToTime", function(timestamp){
  if(timestamp == null){
    return "";
  }
  return timestampToTime(timestamp);
});
// 计算延期天数
Vue.filter('postponedDays', function(timestamp){
  return postponedDays(timestamp);
});
Vue.use(BootstrapVue);
Vue.use(HttpServletPlugin);
Vue.use(ElementUI, {size: "small"});
Vue.prototype.fn = {};
Vue.prototype.$http = http;
//根据命令设置导航数据
import _nav from '@/_nav.js'
import _nav_brand from '@/_nav_brand.js'
import _nav_factory from '@/_nav_factory.js'

Vue.prototype.CONFIG = {
  nav(type = process.env.NAV) {
    return type == 'FACTORY' ? _nav_factory : (type == 'BRAND' ? _nav_brand : _nav);
  },
};

Vue.mixin({
  data(){
    return {
      defaultDateValueFormat: "yyyy-MM-dd'T'HH:mm:ssZ"
    }
  },
  methods: {
    // 统一错误处理mixin
    getErrorMessage(error) {
      const data = error.response.data;

      console.log("DEBUG: " + JSON.stringify(data["errors"]));
      if (data["errors"] && data["errors"].length) {
        return data["errors"][0].message;
      }

      return "未知错误";
    }
  }
});
/* eslint-disable no-new */
new Vue({
  el: "#app",
  router,
  store,
  template: "<App/>",
  components: {
    App
  }
});