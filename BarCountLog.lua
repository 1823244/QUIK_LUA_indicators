--выводит в лог информацию о всех барах, начиная с первого

Settings=
{
	Name = "BarCountLog",
	line = 
	{
		{
			Name = "Bar count to log",
			Color = RGB(255,140,250),
			Type = TYPE_POINT,
			Width = 5
		}
	}
}


--логирование
file = nil


--[[	логирование в текстовый файл
--]]
function log(s)
	---[[
	local x = tostring(Settings.Name)
	if file ~= nil then
		file:write(x.." : "..s.."\n")
		file:flush()
	end
	--]]
end

--[[	инициализация индикатора
Возвращает число, которое определяет количество линий в индикаторе. 
--]]
function Init()
	--логирование
	file = io.open(getScriptPath().."\\bar_count_to_log.log", "a+t")
	--log("init return 2")

	return 1

end

--[[	вычисление индикатора

Функция вызывается при поступлении новой или изменении существующей свечки в источнике данных для индикатора. 
Параметры
	index – индекс свечки в источнике данных. Начинается с «1».
--]]
function OnCalculate(index)

	local res = nil
	
	log("------------------------------------")
	log("bar = "..tostring(index))
	openB = O(index)
	if openB == nil then 
		openB = ''
	end
	log("O = "..tostring(openB))
	
	highB = H(index)
	if highB == nil then 
		highB = ''
	end	
	log("H = "..tostring(highB))
	
	lowB = L(index)
	if lowB == nil then 
		lowB = ''
	end	
	log("L = "..tostring(lowB))
	
	closeB = C(index)
	if closeB == nil then 
		closeB = ''
		res = nil
	else
		res = closeB/2
	end	
	log("C = "..tostring(closeB))
	
	
	log("V = "..tostring(V(index)))
	
	DateTime = T(index)
	log("T = "..tostring( DateTime.year )..'-'..tostring( DateTime.month )..'-'..tostring( DateTime.day )..' '..tostring(DateTime.hour)..':'..tostring(DateTime.min))

	
	--log("index = "..tostring(index))
	return res

	
	
end

