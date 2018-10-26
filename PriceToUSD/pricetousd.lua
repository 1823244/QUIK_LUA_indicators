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


--�����������
file = nil


--[[	����������� � ��������� ����
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

--[[	������������� ����������
���������� �����, ������� ���������� ���������� ����� � ����������. 
--]]
function Init()
	--�����������
	file = io.open(getScriptPath().."\\pricetousd.log", "a+t")
	--log("init return 2")

	return 1

end

--[[	���������� ����������

������� ���������� ��� ����������� ����� ��� ��������� ������������ ������ � ��������� ������ ��� ����������. 
���������
	index � ������ ������ � ��������� ������. ���������� � �1�.
--]]
function OnCalculate(index)

	usd = nil
	usd = getParamEx('CETS','USD000UTSTOM','last')
	
	if usd~=nil then
		return C(index)/tonumber(usd.param_value)
	end
		
	return 1
	
end

