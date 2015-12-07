package RNG
  function Get_Seed
    input Integer Seed;
    output Real First;
  protected
    Real[100] zrng;
  algorithm
    zrng := {1973272912.0, 281629770.0, 20006270.0, 1280689831.0, 2096730329.0, 1933576050.0, 913566091.0, 246780520.0, 1363774876.0, 604901985.0, 1511192140.0, 1259851944.0, 824064364.0, 150493284.0, 242708531.0, 75253171.0, 1964472944.0, 1202299975.0, 233217322.0, 1911216000.0, 726370533.0, 403498145.0, 993232223.0, 1103205531.0, 762430696.0, 1922803170.0, 1385516923.0, 76271663.0, 413682397.0, 726466604.0, 336157058.0, 1432650381.0, 1120463904.0, 595778810.0, 877722890.0, 1046574445.0, 68911991.0, 2088367019.0, 748545416.0, 622401386.0, 2122378830.0, 640690903.0, 1774806513.0, 2132545692.0, 2079249579.0, 78130110.0, 852776735.0, 1187867272.0, 1351423507.0, 1645973084.0, 1997049139.0, 922510944.0, 2045512870.0, 898585771.0, 243649545.0, 1004818771.0, 773686062.0, 403188473.0, 372279877.0, 1901633463.0, 498067494.0, 2087759558.0, 493157915.0, 597104727.0, 1530940798.0, 1814496276.0, 536444882.0, 1663153658.0, 855503735.0, 67784357.0, 1432404475.0, 619691088.0, 119025595.0, 880802310.0, 176192644.0, 1116780070.0, 277854671.0, 1366580350.0, 1142483975.0, 2026948561.0, 1053920743.0, 786262391.0, 1792203830.0, 1494667770.0, 1923011392.0, 1433700034.0, 1244184613.0, 1147297105.0, 539712780.0, 1545929719.0, 190641742.0, 1645390429.0, 264907697.0, 620389253.0, 1502074852.0, 927711160.0, 364849192.0, 2049576050.0, 638580085.0, 547070247.0};
    First := zrng[Seed];
  end Get_Seed;

  function Uniform
    input Real Seed;
    input Real Under;
    input Real Upper;
    output Real Next_Num;
    output Real y;
  protected
    Real Temp_Num;
  algorithm
    if Under >= Upper then
      terminate("function Uniform error (Under >= Upper)");
    end if;
    Temp_Num := Random_Num(Seed);
    Next_Num := Temp_Num;
    Temp_Num := Nom(Temp_Num);
    y := Under + (Upper - Under) * Temp_Num;
  end Uniform;

  function Normal
    input Real Seed;
    input Real Mean;
    input Real Sigma;
    output Real Next_Seed;
    output Real y;
  protected
    Real Sum;
    Real Temp_Num;
  algorithm
    Sum := 0;
    Temp_Num := Seed;
    for i in 1:12 loop
      Temp_Num := Random_Num(Temp_Num);
      Sum := Sum + Nom(Temp_Num);
    end for;
    Next_Seed := Temp_Num;
    y := (Sum - 6.0) * Sigma + Mean;
  end Normal;

  function Exponential
    input Real Seed;
    input Real Mean;
    output Real Next_Seed;
    output Real y;
  protected
    Real Temp_Num;
  algorithm
    Temp_Num := Random_Num(Seed);
    Next_Seed := Temp_Num;
    Temp_Num := Nom(Temp_Num);
    y := (-1 * Mean) * Modelica.Math.log(Temp_Num);
  end Exponential;

  function Weibul
    input Real Seed;
    input Real lambda;
    input Real alfa;
    output Real Next_Num;
    output Real y;
  protected
    Real Temp_Num;
  algorithm
    if lambda <= 0.0 or alfa <= 1.0 then
      terminate(" function Weibul error (lambda <=0.0  or alfa >= 1.0)");
    end if;
    Temp_Num := Random_Num(Seed);
    Next_Num := Temp_Num;
    Temp_Num := Nom(Temp_Num);
    y := (-1 / lambda * Modelica.Math.log(1.0 - Temp_Num)) ^ (1 / alfa);
  end Weibul;

  function Erlang
    input Real Seed;
    input Real alfa;
    input Integer beta;
    output Real Next_Num;
    output Real y;
  protected
    Real Temp_Num = Seed;
    Real ER = 1;
  algorithm
    if beta < 1 then
      teminate("Erlang error");
    end if;
    for i in 1:beta loop
      Temp_Num := Random_Num(Temp_Num);
      ER := ER * Temp_Num;
    end for;
    Next_Num := Temp_Num;
    y := -1 * alfa * Modelica.Math.log(ER);
  end Erlang;

  function NegBin
    annotation(Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})));
  end NegBin;

  function Random_Num
    input Real Seed;
    output Real Num;
  protected
    constant Real MODULUS = 2147483647.0;
    constant Real CO = 630360016.0;
  algorithm
    Num := mod(CO * Seed, MODULUS);
  end Random_Num;

  function Nom
    input Real Seed;
    output Real Num;
  protected
    constant Real MODULUS = 2147483647.0;
    constant Real CO = 630360016.0;
  algorithm
    Num := Seed / MODULUS;
  end Nom;

  function Check_D
    input Real Seed;
    output Real Next_Num;
    output Real y;
  protected
    Real Temp_Num;
  algorithm
    Temp_Num := Random_Num(Seed);
    Next_Num := Temp_Num;
    Temp_Num := Nom(Temp_Num);
    y := mod(8 * Temp_Num, 8) + 1;
  end Check_D;

  function Check_Real
    input Real Seed;
    output Real Next_Num;
    output Integer y;
  protected
    Real Temp_Num;
  algorithm
    Temp_Num := Random_Num(Seed);
    Next_Num := Temp_Num;
    Temp_Num := Nom(Temp_Num);
    Temp_Num := 100 * Temp_Num;
    if Temp_Num <= 46 then
      y := 1;
    elseif Temp_Num <= 52 then
      y := 2;
    elseif Temp_Num <= 58 then
      y := 3;
    elseif Temp_Num <= 63 then
      y := 4;
    elseif Temp_Num <= 70 then
      y := 5;
    elseif Temp_Num <= 78 then
      y := 6;
    elseif Temp_Num <= 88 then
      y := 7;
    else
      y := 8;
    end if;
  end Check_Real;
  annotation(Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})));
end RNG;