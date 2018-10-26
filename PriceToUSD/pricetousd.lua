--price of instrument in USD

Settings=
{
	Name = "AENS Price in USD",
	line = 
	{
		{
			Name = "Price in USD",
			Color = RGB(0,0,255),
			Type = TYPE_LINE,
			Width = 2
		}
	}
}


--логирование
file = nil


--[[	логирование в текстовый файл
--]]
function log(s)
	--[[
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
	file = io.open(getScriptPath().."\\pricetousd.log", "a+t")
	--log("init return 2")

	return 1

end

--[[	вычисление индикатора

Функция вызывается при поступлении новой или изменении существующей свечки в источнике данных для индикатора. 
Параметры
	index – индекс свечки в источнике данных. Начинается с «1».
--]]
function OnCalculate(index)

	usd = nil
	usd = getParamEx('CETS','USD000UTSTOM','last')
	
	if usd~=nil then
		return C(index)/tonumber(usd.param_value)
	end
		
	return 1
	
end

