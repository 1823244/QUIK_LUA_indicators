Settings = {
Name = "*PC (Price Channel)", 
Period = 10,
line = {{
		Name = "Horizontal line",
		Type = TYPE_LINE, 
		Color = RGB(140, 140, 140)
		},
		{
		Name = "PC", 
		Type = TYPE_LINE, 
		Color = RGB(221, 44, 44)
		},
		{
		Name = "PC - upper", 
		Type = TYPE_LINE, 
		Color = RGB(0, 206, 0)
		},
		{
		Name = "PC - lower", 
		Type = TYPE_LINE, 
		Color = RGB(0, 162, 232)
		}
		},
Round = "off",
Multiply = 1,
Horizontal_line="off"
}

function Init()
	func = PC()
	return #Settings.line
end

function OnCalculate(Index) 
	return tonumber(Settings.Horizontal_line), ConvertValue(Settings, func(Index, Settings))
end

function PC() --Price Channel ("PC")
	local H_tmp={}
	local L_tmp={}
	local it = {p=0, l=0}
return function (I, Fsettings, ds)
local Fsettings=(Fsettings or {})
local P = (Fsettings.Period or 10)
if (P>0) then
	if I == 1 then
		H_tmp={}
		L_tmp={}
		it = {p=0, l=0}
	end
	if CandleExist(I,ds) then
		if I~=it.p then it={p=I, l=it.l+1} end
		H_tmp[Squeeze(it.l,P-1)+1] = GetValue(it.p,HIGH,ds)
		L_tmp[Squeeze(it.l,P-1)+1] = GetValue(it.p,LOW,ds)
		if it.l >= P then
			local val_h = math.max(unpack(H_tmp))
			local val_l = math.min(unpack(L_tmp))
			return (val_h+val_l)/2,val_h,val_l
		end
	end
end
return nil,nil,nil
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