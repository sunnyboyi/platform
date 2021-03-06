import http from '@/common/js/http';

const state = {
  keyword: '',
  currentPageNumber: 0,
  currentPageSize: 10,
  page: {
    number: 0, // 当前页，从0开始
    size: 10, // 每页显示条数
    totalPages: 1, // 总页数
    totalElements: 0, // 总数目数
    content: [] // 当前页数据
  },
  formData: {
    title: '',
    subTitle: '',
    picture: [],
    type: '',
    sequenceProducts: []
  },
  promoteProductList: [],
  promoteProductSelectList: [],
  promoteProductSeasonList: [],
  promoteProductLiveList: [],
  promoteProductForYouList: [],
  bannerFormData: [{
    media: {},
    url: '',
    type: 'CT005',
    active: true
  }, {
    media: {},
    url: '',
    type: 'CT005',
    active: true
  }],
  carouselFormData: [{
    media: {},
    url: '',
    type: 'CT004',
    active: true
  }, {
    media: {},
    url: '',
    type: 'CT004',
    active: true
  }, {
    media: {},
    url: '',
    type: 'CT004',
    active: true
  }, {
    media: {},
    url: '',
    type: 'CT004',
    active: true
  }],
  carouselFactoryFormData: [{
    media: {},
    url: '',
    type: 'CT002',
    active: true
  }, {
    media: {},
    url: '',
    type: 'CT002',
    active: true
  }, {
    media: {},
    url: '',
    type: 'CT002',
    active: true
  }, {
    media: {},
    url: '',
    type: 'CT002',
    active: true
  }],
  carouselBrandFormData: [{
    media: {},
    url: '',
    type: 'CT003',
    active: true
  }, {
    media: {},
    url: '',
    type: 'CT003',
    active: true
  }, {
    media: {},
    url: '',
    type: 'CT003',
    active: true
  }, {
    media: {},
    url: '',
    type: 'CT003',
    active: true
  }],
};

const mutations = {
  currentPageNumber: (state, currentPageNumber) => state.currentPageNumber = currentPageNumber,
  currentPageSize: (state, currentPageSize) => state.currentPageSize = currentPageSize,
  keyword: (state, keyword) => state.keyword = keyword,
  page: (state, page) => state.page = page,
  carouselFormData: (state, carouselFormData) => state.carouselFormData = carouselFormData,
  carouselBrandFormData: (state, carouselBrandFormData) => state.carouselBrandFormData = carouselBrandFormData,
  carouselFactoryFormData: (state, carouselFactoryFormData) => state.carouselFactoryFormData = carouselFactoryFormData,
  bannerFormData: (state, bannerFormData) => state.bannerFormData = bannerFormData,
  promoteProductList: (state, promoteProductList) => state.promoteProductList = promoteProductList,
  promoteProductSelectList: (state, promoteProductSelectList) => state.promoteProductSelectList = promoteProductSelectList,
  promoteProductSeasonList: (state, promoteProductSeasonList) => state.promoteProductSeasonList = promoteProductSeasonList,
  promoteProductLiveList: (state, promoteProductLiveList) => state.promoteProductLiveList = promoteProductLiveList,
  promoteProductForYouList: (state, promoteProductForYouList) => state.promoteProductForYouList = promoteProductForYouList
};

const actions = {
  async search ({dispatch, commit, state}, {url, keyword, page, size}) {
    commit('keyword', keyword);
    commit('currentPageNumber', page);
    if (size) {
      commit('currentPageSize', size);
    }

    const response = await http.post(url, {
      keyword: state.keyword}, {
      page: state.currentPageNumber,
      size: state.currentPageSize
    });

    // console.log(JSON.stringify(response));
    if (!response['errors']) {
      commit('page', response);
    }
  },
  refresh ({dispatch, commit, state}, {url}) {
    const keyword = state.keyword;
    const currentPageNumber = state.currentPageNumber;
    const currentPageSize = state.currentPageSize;

    dispatch('search', {url, keyword, page: currentPageNumber, size: currentPageSize});
  }
};

const getters = {
  keyword: state => state.keyword,
  currentPageNumber: state => state.currentPageNumber,
  currentPageSize: state => state.currentPageSize,
  page: state => state.page,
  carouselFormData: state => state.carouselFormData,
  carouselBrandFormData: state => state.carouselBrandFormData,
  carouselFactoryFormData: state => state.carouselFactoryFormData,
  bannerFormData: state => state.bannerFormData,
  promoteProductList: state => state.promoteProductList,
  promoteProductSelectList: state => state.promoteProductSelectList,
  promoteProductSeasonList: state => state.promoteProductSeasonList,
  promoteProductLiveList: state => state.promoteProductLiveList,
  promoteProductForYouList: state => state.promoteProductForYouList
};

export default {
  namespaced: true,
  state,
  mutations,
  actions,
  getters
}
