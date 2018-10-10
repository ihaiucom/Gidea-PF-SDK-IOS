var loadingView = (function () {
    function loadingView() {
        this.sOS = conchConfig.getOS();
        if (this.sOS == "Conch-ios") {
            this.bridge = PlatformClass.createClass("JSBridge");
        }
        else if (this.sOS == "Conch-android") {
            this.bridge = PlatformClass.createClass("demo.JSBridge");
        }
    }
    Object.defineProperty(loadingView.prototype, "loadingAutoClose", {
        get: function () {
            return this._loadingAutoClose;
        },
        set: function (value) {
            this._loadingAutoClose = value;
        },
        enumerable: true,
        configurable: true
    });
    Object.defineProperty(loadingView.prototype, "showTextInfo", {
        get: function () {
            return this._showTextInfo;
        },
        set: function (value) {
            this._showTextInfo = value;
            if (this.bridge) {
                if (this.sOS == "Conch-ios") {
                    this.bridge.call("showTextInfo:", value);
                }
                else if (this.sOS == "Conch-android") {
                    this.bridge.call("showTextInfo", value);
                }
            }
        },
        enumerable: true,
        configurable: true
    });
    loadingView.prototype.bgColor = function (value) {
        if (this.bridge) {
            if (this.sOS == "Conch-ios") {
                this.bridge.call("bgColor:", value);
            }
            else if (this.sOS == "Conch-android") {
                this.bridge.call("bgColor", value);
            }
        }
    };
    loadingView.prototype.setFontColor = function (value) {
        if (this.bridge) {
            if (this.sOS == "Conch-ios") {
                this.bridge.call("setFontColor:", value);
            }
            else if (this.sOS == "Conch-android") {
                this.bridge.call("setFontColor", value);
            }
        }
    };
    loadingView.prototype.setTips = function (value) {
        if (this.bridge) {
            if (this.sOS == "Conch-ios") {
                this.bridge.call("setTips:", value);
            }
            else if (this.sOS == "Conch-android") {
                this.bridge.call("setTips", value);
            }
        }
    };
    loadingView.prototype.loading = function (value) {
        if (this.bridge) {
            if (this.sOS == "Conch-ios") {
                this.bridge.call("loading:", value);
            }
            else if (this.sOS == "Conch-android") {
                this.bridge.call("loading", value);
            }
        }
    };
    loadingView.prototype.hideLoadingView = function () {
        this.bridge.call("hideSplash");
    };
    return loadingView;
}());



var GameApplication = (function(){

    function GameApplication() 
    {
        this.sOS = conchConfig.getOS();
        if (this.sOS == "Conch-ios")
        {
            this.BridgeClass = PlatformClass.createClass("GameApplication");
            this.bridge = this.BridgeClass.newObject(); 
        }
        else if (this.sOS == "Conch-android") 
        {
            this.BridgeClass = PlatformClass.createClass("GameApplication");
            this.bridge = this.BridgeClass.newObject(); 
        }

    }


    GameApplication.prototype.getInfo = function () 
    {
        console.log("GameApplication.getInfo");

        if (this.bridge) 
        {
            this.getIDFA();
            this.getIDFV();
            this.getBundleIdentifier();
        }
    };

    GameApplication.prototype.getIDFA = function () 
    {
        var __this = this;
        if (this.bridge) 
        {
            this.bridge.callWithBack(
                function(uid)
                {

                    console.log("gameApplication.IDFA = " + uid);
                    __this.IDFA = uid;
                },
                "getIDFA");
        }
    };


    GameApplication.prototype.getIDFV = function () 
    {
        var __this = this;
        if (this.bridge) 
        {
            this.bridge.callWithBack(
                function(uid)
                {
                    console.log("gameApplication.IDFV = " + uid);
                    __this.IDFV = uid;
                },
                "getIDFV");
        }
    };

    GameApplication.prototype.getBundleIdentifier = function () 
    {
        var __this = this;
        if (this.bridge) 
        {
            this.bridge.callWithBack(
                function(uid)
                {
                    console.log("gameApplication.BundleIdentifier = " + uid);
                    __this.BundleIdentifier = uid;
                    window.appSetting.appId = uid;
                    console.log("getBundleIdentifier window.appSetting.appId=" + window.appSetting.appId);
                },
                "getBundleIdentifier");
        }
    };



    GameApplication.prototype.openURL = function (url) 
    {
        if (this.bridge) 
        {
            this.bridge.call("openURL:", url);
        }
    };
                       
                       




    /////////////////////////////////////
    // 通知 js事件
    /////////////////////////////////////

    /*
     （3）回调方法：applicationWillResignActive:
     本地通知：UIApplicationWillResignActiveNotification
     触发时机：从活动状态进入非活动状态。
     适宜操作：这个阶段应该保存UI状态（例如游戏状态）。
     */

    GameApplication.prototype.applicationWillResignActive = function () 
    {
        console.log("event: gameApplication.applicationWillResignActive");
    }


    /**
     (4）回调方法：applicationDidEnterBackground:
     本地通知：UIApplicationDidEnterBackgroundNotification
     触发时机：程序进入后台时调用。
     适宜操作：这个阶段应该保存用户数据，释放一些资源（例如释放数据库资源）。
     */

    GameApplication.prototype.applicationDidEnterBackground = function () 
    {
        console.log("event: gameApplication.applicationDidEnterBackground");
    }



    /**
     （5）回调方法：applicationWillEnterForeground：
     本地通知：UIApplicationWillEnterForegroundNotification
     触发时机：程序进入前台，但是还没有处于活动状态时调用。
     适宜操作：这个阶段应该恢复用户数据。
     */

    GameApplication.prototype.applicationWillEnterForeground = function () 
    {
        console.log("event: gameApplication.applicationWillEnterForeground");
    }

    /**
     （2）回调方法：applicationDidBecomeActive：
     本地通知：UIApplicationDidBecomeActiveNotification
     触发时机：程序进入前台并处于活动状态时调用。
     适宜操作：这个阶段应该恢复UI状态（例如游戏状态）。
     */

    GameApplication.prototype.applicationDidBecomeActive = function () 
    {
        console.log("event: gameApplication.applicationDidBecomeActive");
    }

    /**
     （6）回调方法：applicationWillTerminate:
     本地通知：UIApplicationWillTerminateNotification
     触发时机：程序被杀死时调用。
     适宜操作：这个阶段应该进行释放一些资源和保存用户数据。
     */
     
    GameApplication.prototype.applicationWillTerminate = function () 
    {
        console.log("event: gameApplication.applicationWillTerminate");
    }


    return GameApplication;

}());

console.log("window.appSetting.appId=" + window.appSetting.appId);

window.loadingView = new loadingView();
window.gameApplication = new GameApplication();

window.gameApplication.getInfo();
// window.gameApplication.openURL("https://testflight.apple.com/v1/app/1434375733");



if(window.loadingView)
{
    window.loadingView.loadingAutoClose=false;//true代表当动画播放完毕，自动进入游戏。false为开发者手动控制
    window.loadingView.bgColor("#000000");//设置背景颜色
    window.loadingView.setFontColor("#FFFFFF");//设置字体颜色
    window.loadingView.setTips([]);//设置tips数组，会随机出现
}
window.onLayaInitError=function(e)
{
	console.log("onLayaInitError error=" + e);
	alert("加载游戏失败，可能由于您的网络不稳定，请退出重进");
}
