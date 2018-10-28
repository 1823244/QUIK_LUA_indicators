Settings = {
Name = "*A/D (Accumulation/Distribution)", 
line = {{
		Name = "Horizontal line",
		Type = TYPE_LINE, 
		Color = RGB(140, 140, 140)
		},
		{
		Width = 3,
		Name = "A/D_Up", 
		Type = TYPE_HISTOGRAM, 
		Color = RGB(0, 206, 0)
		},
		{
		Width = 3,
		Name = "A/D_Down", 
		Type = TYPE_HISTOGRAM, 
		Color = RGB(221, 44, 44)
		}
		},
Round = "off",
Multiply = 1,
Horizontal_line="0"
}

function Init()
	func = AD()
	return #Settings.line
end

function OnCalculate(Index)
local Out = ConvertValue(Settings, func(Index, Settings))
local HL = tonumber(Settings.Horizontal_line)
	if Out then
		if Out > (HL or 0) then
			return HL,Out,nil
		else
			return HL,nil,Out
		end
	else
		return HL,nil,nil
	end
end

function AD() --Accumulation/Distribution ("AD")
	local tmp = {pp=nil, p=nil}
	local it = {p=0, l=0}
return function (I, Fsettings, ds)
	if I == 1 then
		tmp = {pp=nil, p=nil}
		it = {p=0, l=0}
	end
	if CandleExist(I,ds) then
		if I~=it.p then 
			it={p=I, l=it.l+1}
			tmp.pp = tmp.p
		end
		local CLH=(2*GetValue(it.p,CLOSE,ds)-GetValue(it.p,HIGH,ds) - GetValue(it.p,LOW,ds))*GetValue(it.p,VOLUME,ds)
		local HL=GetValue(it.p,HIGH,ds) - GetValue(it.p,LOW,ds)
		if HL==0 then 
			tmp.p = tmp.pp or 0
		else
			tmp.p = CLH/HL + (tmp.pp or 0)
		end
		if it.l==1 then
			if HL == 0 then return 0
			else return CLH/HL end
		else
			return tmp.p
		end
	end
return nil
end
end


SMA,MMA,EMA,WMA,SMMA,VMA = "SMA","MMA","EMA","WMA","SMMA","VMA"
OPEN,HIGH,LOW,CLOSE,VOLUME,MEDIAN,TYPICAL,WEIGHTED,DIFFERENCE,ANY = "O","H","L","C","V","M","T","W","D","A"

function CandleExist(I,ds)
return (type(C)=="function" and C(I)~=nil) or
	(type(ds)=="table" and (ds[I]~=nil or (type(ds.Size)=="function" and (I>0) and (I<=ds:Size()))))
end

function Squeeze(I,P)
	return math.fmod(I-1,P+1)
end

function ConvertValue(T,...)
local function r(V, R) 
	if R and string.upper(R)== "ON" then R=0 end
	if V and tonumber(R) then
		if V >= 0 then return math.floor(V * 10^R + 0.5) / 10^R
		else return math.ceil(V * 10^R - 0.5) / 10^R end
	else return V end
end
	if arg.n > 0 then
		for i = 1, arg.n do
			arg[i]=arg[i] and r(arg[i] * ((T and T.Multiply) or 1), (T and T.Round) or "off")
		end
		return unpack(arg)
	else return nil end
end

function GetValue(I,VT,ds) 
VT=(VT and string.upper(string.sub(VT,1,1))) or ANY
	if VT == OPEN then			--Open
		return (O and O(I)) or (ds and ds:O(I))
	elseif VT == HIGH then 		--High
		return (H and H(I)) or (ds and ds:H(I))
	elseif VT == LOW then		--Low
		return (L and L(I)) or (ds and ds:L(I))
	elseif VT == CLOSE then		--Close
		return (C and C(I)) or (ds and ds:C(I))
	elseif VT == VOLUME then		--Volume
		return (V and V(I)) or (ds and ds:V(I)) 
	elseif VT == MEDIAN then		--Median
		return ((GetValue(I,HIGH,ds) + GetValue(I,LOW,ds)) / 2)
	elseif VT == TYPICAL then	--Typical
		return ((GetValue(I,MEDIAN,ds) * 2 + GetValue(I,CLOSE,ds))/3)
	elseif VT == WEIGHTED then	--Weighted
		return ((GetValue(I,TYPICAL,ds) * 3 + GetValue(I,OPEN,ds))/4) 
	elseif VT == DIFFERENCE then	--Difference
		return (GetValue(I,HIGH,ds) - GetValue(I,LOW,ds))
	else							--Any
		return (ds and ds[I])
	end
return nil
end