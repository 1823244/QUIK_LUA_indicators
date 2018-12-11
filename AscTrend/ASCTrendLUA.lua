Settings=
{
	Name = "ASCTrend LUA 2",
	RISK = 3,
	line = 
	{
		{
			Name = "asc_buy",
			Color = RGB(40,240,250),
			Type = TYPE_POINT,
			Width = 6
		}---[[
		,{
			Name = "asc_sell",
			Color = RGB(255,140,250),
			Type = TYPE_POINT,
			Width = 6
		}
		--]]
	}
}

value10=nil
value11=nil
x1 = nil
x2 = nil
min_rates_total = nil
WPR_Handle = {}

--[[	инициализаци€ индикатора
--]]
function Init()
	x1=67+Settings.RISK
	x2=33-Settings.RISK
	value10=2
	value11=value10
	min_rates_total = math.max( 3 + Settings.RISK * 2, 4 ) + 1
	return 2
end

--[[	вычисление индикатора
‘ункци€ вызываетс€ при поступлении новой или изменении существующей свечки в источнике данных дл€ индикатора. 
ѕараметры
	index Ц индекс свечки в источнике данных. Ќачинаетс€ с Ђ1ї.
--]]
function OnCalculate(index)
	if index < min_rates_total then
		return nil, nil
	end
	Vel = 0
	WPR={}
	local bar = index
	Range=0
	AvgRange=0
	-- здесь движемс€ в прошлое, от текущего бара bar
	for count = bar, bar-9, -1 do
		local H_bar = H(count)
		if H_bar == nil then
			return nil, nil
		end
		local L_bar = L(count)
		if L_bar == nil then
			return nil, nil
		end
			
		AvgRange = AvgRange + math.abs(H_bar - L_bar)
	end
	Range = AvgRange/10
	count = bar
	TrueCount = 0
	-- движемс€ от бара bar в прошлое	
	while count > bar-9 and TrueCount < 1 do
	
		local O_bar = O(count)
		local C_bar = C(count-1)
		if O_bar == nil then
			return nil, nil
		end
		if C_bar == nil then
			return nil, nil
		end
		
		if math.abs( O_bar - C_bar ) >= Range * 2 then
			TrueCount = TrueCount + 1
		end
		count = count - 1
	end
	if TrueCount>=1 then
		MRO1=count
	else
		MRO1=-1
	end
	count = bar
	TrueCount = 0
	-- движемс€ от бара bar в прошлое
	while count > bar-6 and TrueCount < 1 do
	
		local C_bar = O(count)
		local C3_bar = C(count-3)
		if C_bar == nil then
			return nil, nil
		end
		if C3_bar == nil then
			return nil, nil
		end
		
		if math.abs( C3_bar - C_bar ) >= Range * 4.6 then
			TrueCount = TrueCount + 1
		end
		count = count - 1
	end
	if TrueCount>=1 then
		MRO2=count
	else
		MRO2=-1
	end
	if MRO1>-1 then
		value11=0
	else
		value11=value10
	end
	if MRO2>-1 then
		value11=1
	else
		value11=value10
	end
	WPR_Handle[0] = iWPR(bar, 3)
	WPR_Handle[1] = iWPR(bar, 4)
	WPR_Handle[2] = iWPR(bar, 3+Settings.RISK*2)
	--получить из индикатора WPR одно значение. 
	WPR[0] = WPR_Handle[value11]
	if WPR[0] == nil then
		return nil, nil
	end
	value2 = 100 - math.abs(tonumber(WPR[0]))
	value3 = 0
	if value2 < x2 then
		iii=1
		--go to past
		while bar-iii > 1 do
			WPR_Handle[0] = iWPR(bar-iii, 3)
			WPR_Handle[1] = iWPR(bar-iii, 4)
			WPR_Handle[2] = iWPR(bar-iii, 3+Settings.RISK*2)
			WPR[0] = WPR_Handle[value11]
			if WPR[0] == nil then
				return nil, nil
			end
			Vel=100-math.abs(tonumber(WPR[0]))
			if(Vel >= x2 and Vel <= x1) then
				iii = iii + 1
			else 
				break
			end
		end
		if Vel > x1 then
		
			local H_bar = H(bar)
			if H_bar == nil then
				return nil, nil
			end		
			value3 = H_bar + Range*0.5
			return nil, value3
		end
	end
	if value2 > x1 then
		iii=1
		while bar-iii > 1 do
			WPR_Handle[0] = iWPR(bar-iii, 3)
			WPR_Handle[1] = iWPR(bar-iii, 4)
			WPR_Handle[2] = iWPR(bar-iii, 3+Settings.RISK*2)
			WPR[0] = WPR_Handle[value11]
			if WPR[0] == nil then
				return nil, nil
			end
			Vel=100-math.abs(tonumber(WPR[0]))
			if(Vel>=x2 and Vel<=x1) then
				iii = iii + 1
			else 
				break
			end
		end
		if Vel < x2 then
			local L_bar = L(bar)
			if L_bar == nil then
				return nil, nil
			end			
			value3=L_bar-Range*0.5
			return value3, nil
		end
	end
	return nil, nil
end

--[[	функци€ вычислени€ индикатора Williams percent range
ѕараметры
	index - индекс текущей свечи
	n - количество периодов (свечей), включа€ последнюю,т.е.:
	если n=3, тогда считаем по 4-м свечам, от index-3 по index включительно
--]]
function iWPR(index, n)
--[[ формула WPR
			HIGH(n)-CLOSE
	WRP = -------------------- * 100
			HIGH(n)-LOW(n)
Where:
	CLOSE Ч is last closing price;
	HIGH(n) Ч is the highest high over a number (n) of previous periods;
	LOW(n) Ч is the lowest low over a number (n) of previous periods.
--]]
	if index < n + 1 then
		return nil
	else
		--let's find highest and lowest values
		local highestHigh = H(index - n)
		if highestHigh == nil then
			highestHigh = 0
		end		
		local lowestLow = L(index - n)
		if lowestLow == nil then
			lowestLow = 0
		end	
		for i = index - n + 1, index do
			local H_bar = H(i)
			if H_bar == nil then
				return nil, nil
			end
			if H_bar > highestHigh then
				highestHigh = H_bar
			end
			local L_bar = L(i)
			if L_bar == nil then
				return nil, nil
			end
			if L_bar < lowestLow then
				lowestLow = L_bar
			end
		end
		local C_bar = C(index)
		if C_bar == nil then
			return nil, nil
		end
		wpr = ((highestHigh - C_bar) / (highestHigh - lowestLow)) * (-100)
		return wpr	
	end
end