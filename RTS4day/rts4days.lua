--проверка гипотезы Олейника о том, что индекс РТС не растет более 4-х дней подряд
--отметка появляется над свечой, если рост длился более 4- дней

Settings=
{
	Name = "RTS 4 DAYS ENS",
	line = 
	{
		{
			Name = "RTS 4 days FALSE",
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
	file = io.open(getScriptPath().."\\rts4days.log", "a+t")
	--log("init return 2")

	return 1

end

--[[	вычисление индикатора

Функция вызывается при поступлении новой или изменении существующей свечки в источнике данных для индикатора. 
Параметры
	index – индекс свечки в источнике данных. Начинается с «1».
--]]
function OnCalculate(index)

	log("OnCalculate("..tostring(index)..")")
	log("------------------------------------")
	log("bar = "..tostring(index))

	--ЕНС здесь движемся в прошлое, от текущего бара index
	
	local days = 0 --счетчик дней роста
	
	
	for i = index, index-4, -1 do
	
		log("i = "..tostring(i))
		if C(i)~=nil and O(i)~=nil then
			if C(i)>O(i) then		
				--в этот день росли
				days=days+1
			else 
				days = 0
			end
		end
	
		log("days = "..tostring(days))
	end
	
	if days > 4 then
		return H(index)+2
	end
		
	return nil
	
end

