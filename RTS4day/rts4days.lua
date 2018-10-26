--�������� �������� �������� � ���, ��� ������ ��� �� ������ ����� 4-� ���� ������
--������� ���������� ��� ������, ���� ���� ������ ����� 4- ����

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
	file = io.open(getScriptPath().."\\rts4days.log", "a+t")
	--log("init return 2")

	return 1

end

--[[	���������� ����������

������� ���������� ��� ����������� ����� ��� ��������� ������������ ������ � ��������� ������ ��� ����������. 
���������
	index � ������ ������ � ��������� ������. ���������� � �1�.
--]]
function OnCalculate(index)

	log("OnCalculate("..tostring(index)..")")
	log("------------------------------------")
	log("bar = "..tostring(index))

	--��� ����� �������� � �������, �� �������� ���� index
	
	local days = 0 --������� ���� �����
	
	
	for i = index, index-4, -1 do
	
		log("i = "..tostring(i))
		if C(i)~=nil and O(i)~=nil then
			if C(i)>O(i) then		
				--� ���� ���� �����
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

