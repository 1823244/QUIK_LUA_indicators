������ ����� �������� ������� ������� ������� ����������� ��������� QUIK.
����� ��������������� "��� ����". ����������� ����� ������ �� ���� ����������.
 
����������:
���������� ������� LuaIndicators �� ������, � ����� � ���������� QUIK.
 ����� ����� � ���������, � ���� � ��������, ������ ��������� �������� ���������� �� ������.
 ��� ������� �� ����������� ���������� � ������� *.

���������:
��� ������� ����������� ��� ����� ��������� �� ���������, �.�, �������� �� ��� �� �����������.
��� ������� ������� ���������������� ������� ������� � ������� 1. 
�.�. ���� ���� ����� ������ ��������� ������, ��� ����� ��������� �������� ���� ������� ������� � ������ ������� �������.
��� ������� �������� �� ���������� �������� ������.

������ ����������� ��������, ���������� �������� ��������� �����:
  ����� "Round" ������� ������ ���������� ������ ���������� �������� ����������.
  ����� "Multiply" � ������� ����� ������� ����������� �� ������� ���������� �������� ����������.
  ����� "Horizontal_line" ������������� ��� ����������� �������������� �������������� �����, 
                    ���� ��� �� �����, ���������� ������� � �������� ����� �����, �������� "off".

������ ����� ����������� ��� �������� ������� ������� �����������, ������ ��� ���������� ���������� �� ������.

��� ��������, ��� ������� ���� Moving Average ���������� ������� �������� ���������:
   SMA,MMA,EMA,WMA,SMMA,VMA = "SMA","MMA","EMA","WMA","SMMA","VMA"

������ ���� ����������, ��� �������� � ���� ���� ����� ����������� ��� ��� ������� �������.
� ������ �����, ������������ ��� ��������� �������:
  BOOLEAN function CandleExist(NUMBER I, [TABLE data_source]) --������� ��������� ������� ������.
   ������� �������� ������������� � ��������� ��������� �� ������ ������ �������, �� ����� � ������ � ������� ������� ��� DataSource
   I - ��������� ������ �� ��������� ������.
   data_source - �������� �� ������������, ��������� �� �������, ��� �������� DataSource
   
  NUMBER function Squeeze(NUMBER I, NUMBER P) --������������� ��� �������� ��������
   ������ ������� ��������� �� ��������� ������� ���������� �� �������� ���������� �� ���� ������, 
   � ������� ������ �� ������ ����������. ��� ��������� ������ � ����� ��������, ������ ��������, ��� ����������, �������� ������.
   I - ��������� ������ �� ��������� ������.
   P - ��������� ����������, �� ������� ����� ������� ������. 
   
  NUMBER function ConvertValue(TABLE T, NUMBER ...) --������������� ��� ���������� �������� ���������� ��� ��������� �� �����������.
   T - ������� � ������� ������ ���� ��������� Multiply (����������� ���������) 
     � Round (����� ������ �� ������� ���������� ����������).
   ... - ������������ ���������� ���������� �������, �������� ������� ������� ��������� ��� ��������.
  
  NUMBER function GetValue(NUMBER I, STRING VT, [TABLE data_source]) --������������� ��� ��������� �������� �� ��������� ����������.
  ���:
   I - ��������� ������ �� ��������� ������.
   VT - ��������� ����� ������ ������ �� ��������� �����. 
     ��� ��������, � ���� ������ ���������, ��� ������� ���� ������:
     OPEN,HIGH,LOW,CLOSE,VOLUME,MEDIAN,TYPICAL,WEIGHTED,DIFFERENCE,ANY = "O","H","L","C","V","M","T","W","D","A"
   data_source - �������� �� ������������, ��������� �� �������, ��� �������� DataSource

������� ������� ���������� ����� ��� ���������:
  NUMBER func(NUMBER I, TABLE Fsettings, [TABLE data_source])
  ���:
   I - ������������ ��������, ������ ��������� ����� �� OnCalculate ��� ����� �������� � �������
   Fsettings - �� ������������ ��������, ������� ���������� ��������� ����������
   data_source - �� ������������ ��������, ��������� �� Lua ������� �������� 
                ��������  ��� �������� ������ ��������� ����� CreateDataSource,
				���� �� �����, �� ������ ��� ������� ������� �� ��������� ������ �������.


--������ ������� ���������� Moving Average �� ������������� ������ �����:
dofile(getWorkingFolder().."\\LuaIndicators\\MA.lua")
tbl = {[1]=2587.5, [2]=2588.5, [3]=2585.1, [4]=2583.7, [5]=2582.6, [6]=2581.2, [7]=2579.2, [8]=2574.7,
	[9]=2571.5, [10]=2570.8, [11]=2569.9, [12]=2569.7, [13]=2567.2, [14]=2569.3, [15]=2566.1, [16]=2567, 
	[17]=2563.3, [18]=2565.2, [19]=2564.3, [20]=2565.9, [21]=2568.5, [22]=2572.2, [23]=2572, [24]=2572, [25]=2571.3}
function main() 
  func = MA()
  t_id = AllocTable()
  AddColumn(t_id,1,"Price",true,QTABLE_INT_TYPE,10)
  AddColumn(t_id,2,"MA",true,QTABLE_INT_TYPE,10)
  CreateWindow(t_id)
  SetWindowCaption(t_id,"MA")
  for i=1,#tbl do
   ma_out=func(i, {Period=3, Metod = EMA, VType=ANY}, {[i]=tbl[i]})
   tmp=InsertRow(t_id,-1)
   SetCell(t_id,tmp,1,tostring(tbl[i]),tbl[i])
   SetCell(t_id,tmp,2,tostring(ma_out),ma_out)
  end 
end

--������ ������� ���������� Moving Average �� ��������� ������ ���������� ����� CreateDataSource:
dofile(getWorkingFolder().."\\LuaIndicators\\MA.lua")
function main() 
  func = MA()
  t_id = AllocTable()
  AddColumn(t_id,1,"Price",true,QTABLE_INT_TYPE,10)
  AddColumn(t_id,2,"MA",true,QTABLE_INT_TYPE,10)
  CreateWindow(t_id)
  SetWindowCaption(t_id,"MA")
  ds = CreateDataSource("TQBR", "LKOH", INTERVAL_M5) 
  sleep(100)
  for i=1,ds:Size() do
   ma_out=func(i, {Period=3, Metod = EMA, VType=ANY}, ds)
   tmp=InsertRow(t_id,-1)
   SetCell(t_id,tmp,1,tostring(ds:C(i)),ds:C(i))
   SetCell(t_id,tmp,2,tostring(ma_out),ma_out)
  end 
end

������ ����������� � ������:
"AD"	--Accumulation/Distribution ("AD")
"AC"	--Accelerator/Decelerator Oscillator ("AC")
"ADX"	--Average Directional Movement Index ("ADX")
"AMA"	--Adaptive Moving Average ("AMA")
"AO"	--Awesome Oscillator ("AO")
"ALLIGATOR"	--Alligator ("ALLIGATOR")
"ATR"	--Average True Range ("ATR")
"BWMFI"	--Bill Williams Market Facilitation Index ("BWMFI")
"BEARS"	--Bears Power ("BEARS")
"BB"	--Bollinger Bands ("BB")
"BULLS"	--Bulls Power ("BULLS")
"CCI"	--Commodity Channel Index ("CCI")
"CMO"	--Chande Momentum Oscillator ("CMO")
"CO"	--Chaikin Oscillator ("CO")
"CV"	--Chaikin�s Volatility ("CV")
"EFI"	--Elder's Force Index ("EFI")
"ENVELOPES"	--Envelopes ("ENVELOPES")
"FRACTALS"	--Fractals ("FRACTALS")
"ICHIMOKU"	--Ichimoku ("ICHIMOKU")
"MACD"	--Moving Average Convergence/Divergence ("MACD")
"MACDH"	--MACD Histogram ("MACDH")
"MOMENTUM"	--Momentum ("MOMENTUM")
"MFI"	--Money FLow Index ("MFI")
"MA"	--Moving Average ("MA")
"OBV"	--On Balance "Volume" ("OBV")
"PSAR"	--Parabolic SAR ("PSAR")
"PC"	--Price Channel ("PC")
"PO"	--Price Oscillator ("PO")
"ROC"	--Rate Of Change ("ROC")
"RSI"	--Relative Strength Index ("RSI")
"RVI"	--Relative Vigor Index ("RVI")
"SROC"	--Smoothed Rate Of Change ("SROC")
"SD"	--Standard Deviation ("SD")
"SO"	--Stochastic Oscillator ("SO")
"TR"	--True Range ("TR")
"TRIX"	--Triple Exponential Moving Average ("TRIX")
"VHF"	--Vertical Horizontal Filter ("VHF")
"VO"	--"Volume" Oscillator ("VO")
"WR"	--Williams� Percent Range ("WR")
"WAD"	--Williams� Accumulation/ Distribution ("WAD")
