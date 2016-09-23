//Created by yuxueli 2011.6.6
package com.mapplus.maps.core {
    import flash.geom.*;
    import com.mapplus.maps.*;
    import com.mapplus.maps.interfaces.*;

    public class BaiduProjection implements IProjection {

        public static const BAIDU_ZOOM_LEVEL_ZERO_RANGE:Number = 0x0100;
        private static const EARTHRADIUS:Number = 6370996.81;
        private static const MCBAND:Object = [12890594.86, 8362377.87, 5591021, 3481989.83, 1678043.12, 0];
        private static const LLBAND:Object = [75, 60, 45, 30, 15, 0];
        private static const MC2LL:Object = [[1.41052617211625E-8, 8.98305509648872E-6, -1.9939833816331, 200.98243831068, -187.240370381555, 91.6087516669843, -23.3876564960334, 2.57121317296198, -0.03801003308653, 17337981.2], [-7.43585638956554E-9, 8.98305509772624E-6, -0.78625201886289, 96.3268759975985, -1.85204757529826, -59.3693590548588, 47.4003354929674, -16.5074193106389, 2.28786674699375, 10260144.86], [-3.03088346089883E-8, 8.98305509983578E-6, 0.30071316287616, 59.7429361844228, 7.357984074871, -25.3837100266474, 13.4538052111091, -3.29883767235584, 0.32710905363475, 6856817.37], [-1.98198130493055E-8, 8.98305509977953E-6, 0.03278182852591, 40.3167852770574, 0.65659298677277, -4.44255534477492, 0.85341911805263, 0.12923347998204, -0.04625736007561, 4482777.06], [3.09191371068437E-9, 8.98305509681215E-6, 6.995724062E-5, 23.109343041449, -0.00023663490511, -0.6321817810242, -0.00663494467273, 0.03430082397953, -0.00466043876332, 2555164.4], [2.89087114477688E-9, 8.98305509580541E-6, -3.068298E-8, 7.47137025468032, -3.53937994E-6, -0.02145144861037, -1.234426596E-5, 0.00010322952773, -3.23890364E-6, 826088.5]];
        private static const LL2MC:Object = [[-0.0015702102444, 111320.702061694, 1.7044805245352E15, -1.03389873760423E16, 2.61126678566039E16, -3.51496691766537E16, 2.65957007184039E16, -1.07250124541882E16, 1.80081991295047E15, 82.5], [0.000827782451617253, 111320.702046358, 647795574.667161, -4082003173.64132, 10774905663.5114, -15171875531.5156, 12053065338.6217, -5124939663.57747, 913311935.951203, 67.5], [0.00337398766765, 111320.702020216, 4481351.04589036, -23393751.1993166, 79682215.4718646, -115964993.279725, 97236711.1560214, -43661946.3375282, 8477230.50113523, 52.5], [0.00220636496208, 111320.702020913, 51751.8611284113, 3796837.74947025, 992013.739779101, -1221952.21711287, 1340652.69700907, -620943.699098431, 144416.929380624, 37.5], [-0.000344196350436839, 111320.702057686, 278.235398077275, 2485758.69003539, 6070.75096324338, 54821.1834535212, 9540.60663330424, -2710.55326746645, 1405.48384412173, 22.5], [-0.000321813587861313, 111320.702070161, 0.00369383431289, 823725.640279572, 0.46104986909093, 2351.34314133129, 1.58060784298199, 8.77738589078284, 0.37238884252424, 7.45]];

        private var _wrapper:Object;
        private var pixelRange:Array;
        private var pixelsPerLonDegree:Array;
        private var pixelOrigo:Array;
        private var pixelsPerLonRadian:Array;

        public function BaiduProjection(param1:Number){
            super();
            var _loc_2:* = NaN;
            var _loc_3:int;
            var _loc_4:* = NaN;
            this.pixelsPerLonDegree = [];
            this.pixelsPerLonRadian = [];
            this.pixelOrigo = [];
            this.pixelRange = [];
            _loc_2 = BAIDU_ZOOM_LEVEL_ZERO_RANGE;
            _loc_3 = 0;
            while (_loc_3 < param1) {
                _loc_4 = (_loc_2 / 2);
                this.pixelsPerLonDegree.push((_loc_2 / 360));
                this.pixelsPerLonRadian.push((_loc_2 / (2 * Math.PI)));
                this.pixelOrigo.push(new Point(_loc_4, _loc_4));
                this.pixelRange.push(_loc_2);
                _loc_2 = (_loc_2 * 2);
                _loc_3++;
            };
        }
        public function getWrapWidth(zoom:Number):Number{
            return (this.pixelRange[zoom]);
        }
        public function tileCheckRange(tile:Point, zoom:Number, tilesize:Number):Boolean{
            var _loc_4:Number = NaN;
            var _loc_5:Number = NaN;
            _loc_4 = this.pixelRange[zoom];
            if ((((tile.y < 0)) || (((tile.y * tilesize) >= _loc_4)))){
                return (false);
            };
            if ((((tile.x < 0)) || (((tile.x * tilesize) >= _loc_4)))){
                _loc_5 = Math.floor((_loc_4 / tilesize));
                tile.x = (tile.x % _loc_5);
                if (tile.x < 0){
                    tile.x = (tile.x + _loc_5);
                };
            };
            return (true);
        }
        public function fromLatLngToPixel(latLng:LatLng, zoom:Number):Point{
            var _loc_3:Point;
            var _loc_4:Number;
            var _loc_5:Number;
            var _loc_6:Number;
            var au:Point;
            var aw:Object;
            var av:int;
            var e:Point;
            if ((((latLng.lat() == 0)) || ((latLng.lng() == 0)))){
                _loc_3 = null;
                _loc_4 = NaN;
                _loc_5 = NaN;
                _loc_6 = NaN;
                _loc_3 = this.pixelOrigo[zoom];
                _loc_4 = (_loc_3.x + (latLng.lng() * this.pixelsPerLonDegree[zoom]));
                _loc_5 = Util.bound(Math.sin(Util.degreesToRadians(latLng.lat())), -0.9999, 0.9999);
                _loc_6 = (_loc_3.y + ((0.5 * Math.log(((1 + _loc_5) / (1 - _loc_5)))) * -(this.pixelsPerLonRadian[zoom])));
                return (new Point(_loc_4, _loc_6));
            };
            au = new Point(latLng.lng(), latLng.lat());
            av = 0;
            while (av < LLBAND.length) {
                if (au.y >= LLBAND[av]){
                    aw = LL2MC[av];
                    break;
                };
                av++;
            };
            if (!(aw)){
                av = (LLBAND.length - 1);
                while (av >= 0) {
                    if (au.y <= LLBAND[av]){
                        aw = LL2MC[av];
                        break;
                    };
                    av--;
                };
            };
            e = this.convertor(au, aw);
            return (e);
        }
        public function fromPixelToLatLng(pixel:Point, zoom:Number, opt_nowrap:Boolean=false):LatLng{
            var _loc_4:Point;
            var _loc_5:Number;
            var _loc_6:Number;
            var _loc_7:Number;
            var av:Point;
            var ax:Object;
            var aw:int;
            var au:Point;
            var e:LatLng;
            if ((((pixel.x < 400)) || ((pixel.y < 400)))){
                _loc_4 = null;
                _loc_5 = NaN;
                _loc_6 = NaN;
                _loc_7 = NaN;
                _loc_4 = this.pixelOrigo[zoom];
                _loc_5 = ((pixel.x - _loc_4.x) / this.pixelsPerLonDegree[zoom]);
                _loc_6 = ((pixel.y - _loc_4.y) / -(this.pixelsPerLonRadian[zoom]));
                _loc_7 = Util.radiansToDegrees(((2 * Math.atan(Math.exp(_loc_6))) - (Math.PI / 2)));
                return (new LatLng(_loc_7, _loc_5, opt_nowrap));
            };
            av = pixel;
            aw = 0;
            while (aw < MCBAND.length) {
                if (av.y >= MCBAND[aw]){
                    ax = MC2LL[aw];
                    break;
                };
                aw++;
            };
            au = this.convertor(av, ax);
            e = new LatLng(au.y, au.x);
            return (e);
        }
        private function convertor(av:Point, aw:Object):Point{
           if (((!(av)) || (!(aw)))){
                return (null);
            };
            var e:* = (aw[0] + (aw[1] * Math.abs(av.x)));
            var au:* = (Math.abs(av.y) / aw[9]);
            var ax:* = ((((((aw[2] + (aw[3] * au)) + ((aw[4] * au) * au)) + (((aw[5] * au) * au) * au)) + ((((aw[6] * au) * au) * au) * au)) + (((((aw[7] * au) * au) * au) * au) * au)) + ((((((aw[8] * au) * au) * au) * au) * au) * au));
            e = (e * ((av.x < 0) ? -1 : 1));
            ax = (ax * ((av.y < 0) ? -1 : 1));
            return (new Point(e, ax));
        }
        public function get wrapper():Object{
            return (this._wrapper);
        }
        public function set wrapper(param1:Object):void{
            this._wrapper = param1;
        }
        public function get interfaceChain():Array{
            return (["IProjection"]);
        }

    }
}//package com.mapplus.maps.core 
