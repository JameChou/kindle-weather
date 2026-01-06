import {INow} from "../types/now.ts";
import {formatDate, formatTime, formatWeekday} from "../utils/util.ts";
import {formatLunar, toLunar} from "lunar";


/**
 * 头部展示区域，包含天气信息
 * @constructor
 */
export function WeatherNow({now}: { now: INow }) {
	// 从 URL 中获取城市名称
	const params = new URLSearchParams(location.search);
	const cityName = params.get('city') || '南京市';
    const {lunar} = toLunar(new Date());
    const lunarDateStr = formatLunar(lunar)

	return (
		<header className="min-h-0 flex-[2] flex border-b-4 border-b-black"
		        aria-label="当前天气信息">
			{/* 左侧时间显示 */}
			<div className="flex flex-col p-20 gap-20 justify-center">
				<i className={`qi-${now?.icon} text-[350px] leading-[350px]`}
				   aria-label="天气图标"/>

				{/* 当前时间 */}
				<p className="text-xl flex-none">
					<span>当前时间: {formatTime()}</span> / <span>天气更新时间: {formatTime(new Date(now?.obsTime))}</span>
				</p>
			</div>

            <div className="flex flex-col p-20 ml-auto justify-center">
                <p className="text-7xl flex-none font-bold">
                    <span>{formatDate()}</span>
                </p>
                <p className="text-7xl flex-none text-center mt-2">
                    <span>{formatWeekday()}</span>
                </p>
                <p className="text-5xl flex-none text-center mt-9">
                    <span>{lunarDateStr}</span>
                </p>
            </div>

			{/* 右侧天气信息 */}
			<div className="flex flex-col p-20 ml-auto items-end justify-between">
				<h1 className="text-5xl" aria-label="城市名称">{cityName}</h1>

				{/* 温度显示 */}
				<p className="text-[280px] font-bold font-cabin-sketch">
					{now?.temp}°
				</p>

				{/* 天气描述 */}
				<p className="text-3xl">{now?.text}</p>
			</div>
		</header>
	);
}
