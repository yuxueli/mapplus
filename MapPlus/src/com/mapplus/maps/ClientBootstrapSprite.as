	//Created by yuxueli 2011.6.6
package com.mapplus.maps {
    import com.adobe.serialization.json.*;
    import flash.display.*;

    public class ClientBootstrapSprite extends Sprite {

        public static var StandardMapTypes:Object = {
            terms_of_use:"http://www.google.com/intl/zh-CN_ALL/help/terms_maps.html",
            tile_urls:{
				map_urls:["http://mt0.google.cn/vt/lyrs=m@170000000&hl=zh-CN&gl=cn&", "http://mt1.google.cn/vt/lyrs=m@170000000&hl=zh-CN&gl=cn&", "http://mt2.google.cn/vt/lyrs=m@170000000&hl=zh-CN&gl=cn&", "http://mt3.google.cn/vt/lyrs=m@170000000&hl=zh-CN&gl=cn&"],
				//map_urls:["http://mt0.google.cn/vt/lyrs=m@169000000&hl=zh-CN&gl=cn&", "http://mt1.google.cn/vt/lyrs=m@169000000&hl=zh-CN&gl=cn&", "http://mt2.google.cn/vt/lyrs=m@169000000&hl=zh-CN&gl=cn&", "http://mt3.google.cn/vt/lyrs=m@169000000&hl=zh-CN&gl=cn&"],
                //map_urls:["http://mt0.google.com/vt/lyrs=m@146&hl=zh-CN&src=api&", "http://mt1.google.com/vt/lyrs=m@146&hl=zh-CN&src=api&"],
				satellite_urls:["http://mt0.google.cn/vt/lyrs=s@104&hl=zh-CN&gl=cn&", "http://mt1.google.cn/vt/lyrs=s@104&hl=zh-CN&gl=cn&","http://mt2.google.cn/vt/lyrs=s@104&hl=zh-CN&gl=cn&", "http://mt3.google.cn/vt/lyrs=s@104&hl=zh-CN&gl=cn&"],
				//satellite_urls:["http://mt0.google.cn/vt/lyrs=s@104&gl=cn&", "http://mt1.google.cn/vt/lyrs=s@104&gl=cn&"],
                //hybrid_urls:["http://mt0.google.com/vt/lyrs=h@146&hl=zh-CN&src=api&", "http://mt1.google.com/vt/lyrs=h@146&hl=zh-CN&src=api&"],
				//hybrid_urls:["http://mt0.google.com/vt/lyrs=h@146&hl=zh-CN&gl=cn&", "http://mt1.google.com/vt/lyrs=h@146&hl=zh-CN&gl=cn&"],//增加地名道路
				hybrid_urls:["http://mt0.google.cn/vt/imgtp=png32&lyrs=h@169000000&hl=zh-CN&gl=cn&","http://mt1.google.cn/vt/imgtp=png32&lyrs=h@169000000&hl=zh-CN&gl=cn&","http://mt2.google.cn/vt/imgtp=png32&lyrs=h@169000000&hl=zh-CN&gl=cn&","http://mt3.google.cn/vt/imgtp=png32&lyrs=h@169000000&hl=zh-CN&gl=cn&"],
				physical_urls:["http://mt0.google.cn/vt/lyrs=t@128,r@169000000&hl=zh-CN&gl=cn&", "http://mt1.google.cn/vt/lyrs=t@128,r@169000000&hl=zh-CN&gl=cn&","http://mt2.google.cn/vt/lyrs=t@128,r@169000000&hl=zh-CN&gl=cn&", "http://mt3.google.cn/vt/lyrs=t@128,r@169000000&hl=zh-CN&gl=cn&"],
				//physical_urls:["http://mt0.google.com/vt/lyrs=t@128,r@146&hl=zh-CN&src=api&", "http://mt1.google.com/vt/lyrs=t@128,r@146&hl=zh-CN&src=api&"],
                bingmap_urls:["http://r0.tiles.ditu.live.com/tiles/r", "http://r1.tiles.ditu.live.com/tiles/r"],
                mapabc_urls:["http://emap0.mapabc.com/mapabc/maptile?v=w2.61&", "http://emap1.mapabc.com/mapabc/maptile?v=w2.61&"],
                qqmap_urls:["http://p0.map.soso.com/maptiles/", "http://p1.map.soso.com/maptiles/","http://p2.map.soso.com/maptiles/", "http://p3.map.soso.com/maptiles/"]
            },
            messages:{
                normal_map:"Google地图",
                normal_map_abbreviated:"Google地图",
                show_street_map:"Google地图",
                hybrid_map:"混合地图",
                hybrid_map_abbreviated:"混合地图",
                show_imagery_with_street_names:"显示标有街道名称的图片",
                terrain_map:"地形",
                terrain_map_abbreviated:"地形",
                show_street_map_with_terrain:"显示地形地图",
                keyhole_map:"卫星",
                keyhole_map_abbreviated:"卫星",
                show_satellite_imagery:"显示卫星图片",
                bing_map:"Bing地图",
                bing_map_abbreviated:"Bing地图",
                show_bing_map:"微软地图",
                mapabc_map:"MapABC地图",
                mapabc_map_abbreviated:"MapABC地图",
                show_mapabc_map:"MapABC地图",
                qq_map:"Soso地图",
                qq_map_abbreviated:"Soso地图",
                show_qq_map:"Soso地图",
                decimal_point:".",
                thousands_separator:",",
                terms:"关于数据",
                map_error_tile:"很抱歉，在这一缩放级别的地图上未找到此区域。\n请缩小地图，扩大视野范围。\n",
                keyhole_error_tile:"很抱歉，在此缩放级别的卫星图像上，未找到该区域。\n请缩小图像，扩大视野范围。\n",
                zoom_in:"放大",
                zoom_out:"缩小",
                zoom_set:"单击设置缩放水平",
                zoom_drag:"拖动缩放",
                pan_left:"向左平移",
                pan_right:"向右平移",
                pan_up:"向上平移",
                pan_down:"向下平移",
                last_result:"返回上一结果",
                click_to_see_on_google:"点击可在 Google 地图上参看该区域",
                kilometers_abbreviated:"公里",
                miles_abbreviated:"英里",
                meters_abbreviated:"米",
                feet_abbreviated:"英尺",
                infowindow_button_fullsize:"全屏显示",
                tab_basics:"地址",
                tab_details:"详细资料",
                walking_directions_do_not_know_sidewalks:"注意 : 此路线可能缺乏部分人行道信息。",
                walking_directions_beta:"步行路线正在测试中。",
                walking_directions_use_caution:"在不熟悉的区域行走时使用警告。",
                loading_dot_dot_dot:"正在载入...",
                unable_to_load:"无法载入...",
                layerscontrol_more:"查看更多",
                tilt_camera_up:"上倾视图。",
                tilt_camera_down:"下倾视图。",
                tilt_camera_left:"左倾视图。",
                tilt_camera_right:"右倾视图。"
            },
            satellite_token:"fzwq1Naq0QL7N4JfbAx_9i9nmiezjM_mtAIe-A",
            copyrights:{
                map_prefix:"地图数据 ©2011",
                satellite_prefix:"Imagery ©2011",
                google:"©2011 Google",
                bing_prefix:"地图数据 ©2011",
                mapabc_prefix:"地图数据 ©2011",
                qq_prefix:"地图数据 ©2011"
            },
            preferences:{metric_scale:false},
            request_domain:"*",
            accept_language:"zh-CN,zh;q=0.8",
            onion_urls:["http://mt0.google.com/mapslt", "http://mt1.google.com/mapslt", "http://mt2.google.com/mapslt", "http://mt3.google.com/mapslt"]
        };
        public static var json:String = '{"terms_of_use":"http://www.google.com/intl/zh-CN_ALL/help/terms_maps.html","tile_urls":{"map_urls":["http://mt0.google.com/vt/lyrs=m@146\\x26hl=zh-CN\\x26src=api\\x26","http://mt1.google.com/vt/lyrs=m@146\\x26hl=zh-CN\\x26src=api\\x26"],"satellite_urls":["http://khm0.google.com/kh/v=80\\x26","http://khm1.google.com/kh/v=80\\x26"],"hybrid_urls":["http://mt0.google.com/vt/lyrs=h@146\\x26hl=zh-CN\\x26src=api\\x26","http://mt1.google.com/vt/lyrs=h@146\\x26hl=zh-CN\\x26src=api\\x26"],"physical_urls":["http://mt0.google.com/vt/lyrs=t@126,r@146\\x26hl=zh-CN\\x26src=api\\x26","http://mt1.google.com/vt/lyrs=t@126,r@146\\x26hl=zh-CN\\x26src=api\\x26"],"bingmap_urls":["http://r0.tiles.ditu.live.com/tiles/r","http://r1.tiles.ditu.live.com/tiles/r"]},"messages":{"decimal_point":".","thousands_separator":",","terms":"使用条款","normal_map":"地图","normal_map_abbreviated":"地图","bing_map":"BING地图","bing_map_abbreviated":"BING地图","map_error_tile":"很抱歉，在这一缩放级别的地图上未找到此区域。\\x3cp\\x3e请缩小地图，扩大视野范围。\\x3c/p\\x3e","keyhole_map":"卫星","keyhole_map_abbreviated":"卫星","keyhole_error_tile":"很抱歉，在此缩放级别的卫星图像上，未找到该区域。\\x3cp\\x3e请缩小图像，扩大视野范围。\\x3c/p\\x3e","hybrid_map":"混合地图","hybrid_map_abbreviated":"混合地图","terrain_map":"地形","terrain_map_abbreviated":"地形","zoom_in":"放大","zoom_out":"缩小","zoom_set":"单击设置缩放水平","zoom_drag":"拖动缩放","pan_left":"向左平移","pan_right":"向右平移","pan_up":"向上平移","pan_down":"向下平移","last_result":"返回上一结果","show_street_map":"显示街道地图","show_satellite_imagery":"显示卫星图片","show_imagery_with_street_names":"显示标有街道名称的图片","show_street_map_with_terrain":"显示地形地图","show_bing_map":"微软地图","click_to_see_on_google":"点击可在 Google 地图上参看该区域","kilometers_abbreviated":"公里","miles_abbreviated":"英里","meters_abbreviated":"米","feet_abbreviated":"英尺","infowindow_button_fullsize":"全屏显示","tab_basics":"地址","tab_details":"详细资料","walking_directions_do_not_know_sidewalks":"注意 \\x26ndash; 此路线可能缺乏部分人行道信息。","walking_directions_beta":"步行路线正在测试中。","walking_directions_use_caution":"在不熟悉的区域行走时使用警告。","loading_dot_dot_dot":"正在载入...","unable_to_load":"无法载入...","layerscontrol_more":"查看更多","tilt_camera_up":"上倾视图。","tilt_camera_down":"下倾视图。","tilt_camera_left":"左倾视图。","tilt_camera_right":"右倾视图。"},"satellite_token":"fzwq1Naq0QL7N4JfbAx_9i9nmiezjM_mtAIe-A","copyrights":{"map_prefix":"地图数据 \\x26#169;2011","satellite_prefix":"Imagery \\x26#169;2011","google":"\\x26#169;2011 Google"},"preferences":{"metric_scale":false},"request_domain":"*","accept_language":"zh-CN,zh;q=0.8","onion_urls":["http://mt0.google.com/mapslt","http://mt1.google.com/mapslt","http://mt2.google.com/mapslt","http://mt3.google.com/mapslt"]}';
		public static var libUrl:String = "http://mapplus.googlecode.com/svn/trunk/MapPlus.swf";
		//public static var libUrl:String = "http://202.102.112.25/MapPlus.swf";
        private var bootstrapLoader:Loader;
        private var urlCallback:Function;

        public function ClientBootstrapSprite(){
            super();
            this.name = PConstants.MASTER_NAME;
        }
        public static function parseJson(param1:String):Object{
            var jsonFixer:* = null;
            var fixedJson:* = null;
            var decoder:* = null;
            var param1:* = param1;
            var json:* = param1;
            jsonFixer = /\\x([0-9a-fA-F][0-9a-fA-F])/g;
            fixedJson = json.replace(jsonFixer, "\\u00$1");
            decoder = new JSONDecoder(fixedJson, true);
            trace(decoder.getValue().toString());
            return (decoder.getValue());
            var _slot1:* = e;
            Log.log(((((((_slot1.name + ":") + _slot1.message) + ":") + _slot1.at) + ":") + _slot1.text));
            return ({});
        }

        public function getLibUrl():String{
            return (libUrl);
        }
        public function getJson():String{
            return (json);
        }
        public function release():void{
            while (this.numChildren != 0) {
                this.removeChild(this.getChildAt(0));
            };
        }
        public function getConfigData():Object{
            return (StandardMapTypes);
        }
        public function getBootstrapLoader():Loader{
            return (this.bootstrapLoader);
        }
        public function setUrl(param1:String):void{
            this.urlCallback(param1);
        }
        public function setUrlCallback(param1:Function):void{
            this.urlCallback = param1;
        }
        public function getLogLevel():int{
            return (Log.level);
        }
        public function getBootstrapConfiguration():Object{
            return (BootstrapConfiguration.getInstance());
        }
        public function setBootstrapLoader(param1:Loader):void{
            this.bootstrapLoader = param1;
        }

    }
}//package com.mapplus.maps 
