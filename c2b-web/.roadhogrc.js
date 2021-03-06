const mock = process.env.NODE_ENV || '';
const pxtorem = require('postcss-pxtorem');

export default {
    "entry": "src/index.js",
    "disableCSSModules": false,
    "cssModulesExclude": ["./src/global.less"],
    "publicPath": "/dist/c2b/",
    "hash": true,
    "theme": "./theme.config.js",
    "resolve": {
        "extensions": ['.js', '.jsx', '.json'],
    },
    "autoprefixer": {
        "browsers": [
            "iOS >= 8", "Android >= 4"
        ]
    },
    "proxy": {
        "/c2b": {
            "target": "https://47.106.112.137",
            "changeOrigin": true,
            "secure": false
        },
        "/imageserver/api/render/image": {
            "target": "https://47.106.112.137",
            "changeOrigin": true,
            "secure": false
        },
        "/authorizationserver": {
            "target": "https://47.106.112.137",
            "changeOrigin": true,
            "secure": false
        }

    },
    "extraBabelPlugins": [
        "transform-runtime", ['import', { 'libraryName': 'antd-mobile', 'libraryDirectory': 'lib', 'style': true }]
    ],
    extraPostCSSPlugins: [
        pxtorem({
            rootValue: 100,
            propWhiteList: [],
        }),
    ],
    externals: {
        'react': 'React',
        'react-dom': 'ReactDOM',
    },
    "env": {
        "development": {
            "extraBabelPlugins": [
                "dva-hmr", ["module-resolver", {
                    "alias": {
                        "utils": '/utils',
                        "underscore": "lodash",
                        "~": "./src",
                        "assets": ["./src/assets"],
                        "components": ["./src/components"],
                        "routes": ["./src/routes"]
                    }
                }]
            ]
        },
        "production": {
            "extraBabelPlugins": [
                "dva-hmr", ["module-resolver", {

                    "alias": {
                        "utils": '/utils',
                        "underscore": "lodash",
                        "~": "./src",
                        "utils": '/utils',
                        "underscore": "lodash",
                        "~": "./src",
                        "assets": ["./src/assets"],
                        "components": ["./src/components"],
                        "routes": ["./src/routes"]
                    }
                }]
            ]
        }
    },
    "xdllPlugin": {
        "plugins": ["transform-decorators-legacy"],
        "exclude": [
            "babel-runtime"
        ],
        "include": [
            "dva/router",
            "dva/saga",
            "dva/fetch"
        ]
    }
}