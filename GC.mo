package GC
  model Customer
    Real mean_interarrive_time(start = 1.0);
    Integer generation_count(start = 0);
    Real generation_time(start = 1.0);
    parameter Integer seed_in(start = 1);
    Real real_seed(start = Get_Seed(seed_in));
    Boolean event1(start = false);
    Modelica.Blocks.Interfaces.BooleanOutput event_customer_send annotation(Placement(visible = true, transformation(origin = {108, -4}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  algorithm
    event_customer_send := false;
    event1 := time >= pre(generation_time);
    when event1 then
      event_customer_send := true;
      generation_count := pre(generation_count) + 1;
      (real_seed, mean_interarrive_time) := Uniform(real_seed, 0.75, 1.25);
      generation_time := pre(generation_time) + mean_interarrive_time;
    end when;
    annotation(Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2}), graphics = {Bitmap(origin = {-55, 62}, extent = {{111, -114}, {-3, 4}}, imageSource = "iVBORw0KGgoAAAANSUhEUgAAAHwAAACECAYAAABS30/KAAAABmJLR0QA/wD/AP+gvaeTAAAEVUlEQVR4nO3dz2sUZxzH8feapdXGtngRjUrpLylGb/4AT+rBQz1Ie+q94MlL8R/opVCoCO2tp17EFhEV9SAICv5CqlQQwf7KqVW0FAmGtKk0bg+z0s26u/PMzPPMM/t8Py94QNjMzHf3nZjJ7mYCIiIiIiIiIlKXVuwBavYqsAOYAiaAR8At4I+YQ4l/24CzwALQ6VuLwDVgX7TpxJsJ4AjwjBdDD1qngMkok0plLeA73EL3rpvAygjzSkWfUjz283Wi/nGlik3Av5QP3gE+qH1qKe0bqsXukJ29yxh4CZilevAOsLHm2YNbFnuAAN4DXve0r+2e9tMYKQaf8riv9R731QgpBpcRUgz+wOO+7nvclwTSBh7j56TtjZpnl5KOUj32ndqnltI2Ak/REy+mfEH52Oex99Lx2JsAzlE89l1gVYR5xYM28CXuL4+ewd+TNhKR3gDRZe37lN7iJLak9BW+AthA9lXs0wLwG/DE836loNeAj4GTwJ/4eWZt1JoDLgCf4PcFGsnRBg6Sfd8NHXnYmgc+w///JtJnDXCdeKH71wywJeg9NmyK7AGOHbl/zZL92CceTQK3iR932HpIdsIonhwmftS8dT7YvTfmHaq/8lXXej/QY2DKV8QP6bouBXoMzGiRvc0odkjXtUj2k0RjNf09bZsZryc5lgF7Yg8xStODvxV7gBLejj3AKE0Pvjb2ACU0euamB38l9gAlNPr3y5seXDxrxx6gojngZ2A5MB34WDNkT6NuAFYHPlYw4/4V/gOwFfiwhmMd6h7r2xqOFcy4B5eCFNwYBTdGwY1JJXgn9gDjIpXg4kjBjVFwYxTcGAU3JpXgOkt3lEpwcaTgxii4MQpuTCrBddLmKJXg4kjBjVFwYxTcGAU3JpXgOkt3lEpwcaTgxii4MU0P/nfO7X/VMsVSCzm3580cVdOD38y5/UYtUyz1fcXbJccpBl9e41f+/yvAbw75GJ9rf/dYEwy/OOBdsl9slAomgWMsfWCvsPQvDtUZHLKL6Pf/IZ3LjNflSRpvDbALeHfAbUWCPwU+767fC2zXG/y5dcDu7vGlRkWCz/dsd63AdoOCj52mn7SJZ6kE11OrjlIJLo4U3BgFN0bBjVFwY1IJrrN0R6kEF0cKboyCG6PgxqQSXCdtjlIJLo4U3BgFN0bBjVFwY1IJrrN0R6kEF0cKboyCG6Pgxii4MakE11m6o1SCiyMFN0bBjVFwY1IJrpM2R6kEF0cKboyCG6Pgxii4MakE11m6o1SCiyMFN0bBjVFwYxTcmFSCF7mMdu+VGItc6no+/0OaL5Xgs8BDx4/9seffPzlu0wHuFZpIgjuM2zVTD/Rss9Nxm4u13AMpZBXwC6PDXQbafdt9nbPNE2A6/PhSxnqGX7z+JNl1zvu1gSPA4oBtZoCtwaeuUSv2AAG0gH3AXuBlYA44DVzN2W4a+AhYDTwj+8Q5DvwTbFIRERERERERSdp/5PL935/nB3oAAAAASUVORK5CYII=")}));
  end Customer;

  package Server
    model JVM
      parameter Real eden_limit_level(start = 100);
      parameter Real survive_limit_level(start = 50);
      parameter Real old_limit_level(start = 80);
      Boolean event1(start = false);
      Boolean survive_flag(start = false);
      Real require_eden(start = 0.0);
      Real response_time(start = 0.0);
      Real each_response_time(start = 0.0);
      Real m_gc_time(start = 0.0);
      parameter Integer seed_in(start = 2);
      Real real_seed(start = Get_Seed(seed_in));
      Real eden_gc_percent(start = 0.0);
      Real survive_gc_percent(start = 0.0);
      Real survive_remainder_percent(start = 0.0);
      Real old_gc_percent(start = 0.0);
      Real total_memeory_use(start = 0.0);
      Real total_new_use(start = 0.0);
      Real total_old_use(start = 0.0);
      Integer customer_type;
      Modelica.Blocks.Interfaces.BooleanInput event_user_come annotation(Placement(visible = true, transformation(origin = {-96, 14}, extent = {{20, -20}, {-20, 20}}, rotation = 0), iconTransformation(origin = {-86, 36}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
      Modelica.Blocks.Interfaces.RealInput eden_level annotation(Placement(visible = true, transformation(origin = {88, 64}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {98, 64}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
      Modelica.Blocks.Interfaces.RealInput survive0_level annotation(Placement(visible = true, transformation(origin = {88, 36}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {96, 34}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
      Modelica.Blocks.Interfaces.RealInput survive1_level annotation(Placement(visible = true, transformation(origin = {88, 8}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {94, 6}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
      Modelica.Blocks.Interfaces.RealInput old_level annotation(Placement(visible = true, transformation(origin = {88, -20}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {92, -18}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
      Modelica.Blocks.Interfaces.RealInput perm_level annotation(Placement(visible = true, transformation(origin = {88, -50}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {96, -48}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
      Modelica.Blocks.Interfaces.RealOutput eden_out annotation(Placement(visible = true, transformation(origin = {62, 66}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {72, 66}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Modelica.Blocks.Interfaces.RealOutput survive0_out annotation(Placement(visible = true, transformation(origin = {60, 34}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {60, 34}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Modelica.Blocks.Interfaces.RealOutput survive1_out annotation(Placement(visible = true, transformation(origin = {58, 8}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {58, 8}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Modelica.Blocks.Interfaces.RealOutput old_out annotation(Placement(visible = true, transformation(origin = {54, -18}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {54, -18}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Modelica.Blocks.Interfaces.RealOutput perm_out annotation(Placement(visible = true, transformation(origin = {52, -48}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {52, -48}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    algorithm
      event1 := edge(event_user_come);
      when event1 then
        (require_eden, customer_type) := GetCustomer(real_seed);
        real_seed := Random_Num(real_seed);
        eden_out := eden_level;
        if customer_type == 1 then
          (real_seed, each_response_time) := Uniform(real_seed, 1.5, 2.5);
        else
          (real_seed, each_response_time) := Uniform(real_seed, 2, 3);
        end if;
        if eden_limit_level < require_eden + eden_out then
          (real_seed, eden_gc_percent) := Uniform(real_seed, 0.15, 0.25);
          eden_out := eden_level * eden_gc_percent;
          (real_seed, m_gc_time) := Uniform(real_seed, 0.05, 0.15);
          each_response_time := each_response_time + eden_level * (1 - eden_gc_percent) * m_gc_time / eden_limit_level;
          (real_seed, survive_gc_percent) := Uniform(real_seed, 0.25, 0.35);
          (real_seed, survive_remainder_percent) := Uniform(real_seed, 0.1, 0.3);
          if survive_flag then
            old_out := old_level + survive0_level * survive_remainder_percent;
            survive1_out := survive0_level * survive_remainder_percent + eden_out;
            survive0_out := 0;
            if survive1_out > survive_limit_level then
              each_response_time := each_response_time + 5.0;
            end if;
          else
            old_out := old_level + survive1_level * survive_remainder_percent;
            survive0_out := survive1_level * survive_remainder_percent + eden_out;
            survive1_out := 0;
            if survive0_out > survive_limit_level then
              each_response_time := each_response_time + 5.0;
            end if;
          end if;
          survive_flag := not survive_flag;
          if old_out > old_limit_level then
            (real_seed, old_gc_percent) := Uniform(real_seed, 0.2, 0.4);
            old_out := old_level * old_gc_percent;
            each_response_time := each_response_time + old_level / 100;
          else
            old_out := old_out;
          end if;
        end if;
        total_memeory_use := eden_out + survive0_out + survive1_out + old_out;
        total_new_use := eden_out + survive0_out + survive1_out;
        total_old_use := old_out;
        perm_out := perm_level;
        eden_out := require_eden + eden_out;
        response_time := response_time + each_response_time;
      end when;
    end JVM;

    model Eden
      parameter Real eden_size(start = 100.0);
      Real current_level(start = 0.0);
      Boolean event1;
      Modelica.Blocks.Interfaces.RealInput eden_in annotation(Placement(visible = true, transformation(origin = {-42, 48}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-42, 48}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
      Modelica.Blocks.Interfaces.RealOutput eden_out annotation(Placement(visible = true, transformation(origin = {-40, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-40, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    algorithm
      event1 := eden_in <> pre(eden_in);
      when event1 then
        current_level := eden_in;
        eden_out := current_level;
        event1 := false;
      end when;
      annotation(Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})));
    end Eden;

    model Survive
      parameter Real survive_size(start = 100.0);
      Real current_level(start = 0.0);
      Boolean event1;
      Modelica.Blocks.Interfaces.RealInput survive_in annotation(Placement(visible = true, transformation(origin = {-42, 48}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-42, 48}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
      Modelica.Blocks.Interfaces.RealOutput survive_out annotation(Placement(visible = true, transformation(origin = {-40, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-40, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    algorithm
      event1 := survive_in <> pre(survive_in);
      when event1 then
        current_level := survive_in;
        survive_out := current_level;
        event1 := false;
      end when;
      annotation(Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})));
    end Survive;

    model Old
      parameter Real old_size(start = 100.0);
      Real current_level(start = 0.0);
      Boolean event1;
      Modelica.Blocks.Interfaces.RealInput old_in annotation(Placement(visible = true, transformation(origin = {-42, 48}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-42, 48}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
      Modelica.Blocks.Interfaces.RealOutput old_out annotation(Placement(visible = true, transformation(origin = {-40, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-40, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    algorithm
      event1 := old_in <> pre(old_in);
      when event1 then
        current_level := old_in;
        old_out := current_level;
        event1 := false;
      end when;
      annotation(Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})));
    end Old;

    model Perm
      annotation(Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})));
    end Perm;
    annotation(Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})));
  end Server;

  package TestCase
    model test
      parameter Real a;
      parameter Real b;
      parameter Real c;
      Server.Eden eden1(eden_size = 100.0) annotation(Placement(visible = true, transformation(origin = {48, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Server.JVM jVM1(eden_limit_level = a, survive_limit_level = b, old_limit_level = c) annotation(Placement(visible = true, transformation(origin = {0, 2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Server.Survive survive0 annotation(Placement(visible = true, transformation(origin = {48, 14}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Server.Survive survive1 annotation(Placement(visible = true, transformation(origin = {48, -12}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Server.Old old1 annotation(Placement(visible = true, transformation(origin = {48, -38}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Customer customer1 annotation(Placement(visible = true, transformation(origin = {-66, 2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    equation
      eden1.eden_in = pre(jVM1.eden_out);
      survive0.survive_in = pre(jVM1.survive0_out);
      survive1.survive_in = pre(jVM1.survive1_out);
      old1.old_in = pre(jVM1.old_out);
      jVM1.eden_level = pre(eden1.eden_out);
      jVM1.event_user_come = pre(customer1.event_customer_send);
      jVM1.survive0_level = pre(survive0.survive_out);
      jVM1.survive1_level = pre(survive1.survive_out);
      jVM1.old_level = pre(old1.old_out);
      jVM1.perm_level = 0;
    end test;

    model TestMu
      parameter Real aa(start = 128);
      parameter Real bb(start = 1024);
      parameter Real cc(start = 128);
      test test1(a = aa, b = bb, c = cc) annotation(Placement(visible = true, transformation(origin = {-80, 54}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      test test2(a = aa, b = bb, c = cc * 2) annotation(Placement(visible = true, transformation(origin = {-40, 56}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      test test3(a = aa, b = bb, c = cc * 4) annotation(Placement(visible = true, transformation(origin = {10, 54}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      test test4(a = aa, b = bb, c = cc * 8) annotation(Placement(visible = true, transformation(origin = {48, 56}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      test test5(a = aa * 2, b = bb, c = cc) annotation(Placement(visible = true, transformation(origin = {-76, 14}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      test test6(a = aa * 2, b = bb, c = cc * 2) annotation(Placement(visible = true, transformation(origin = {-42, 18}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      test test7(a = aa * 2, b = bb, c = cc * 4) annotation(Placement(visible = true, transformation(origin = {22, 18}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      test test8(a = aa * 2, b = bb, c = cc * 8) annotation(Placement(visible = true, transformation(origin = {52, 16}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      test test9(a = aa * 4, b = bb, c = cc) annotation(Placement(visible = true, transformation(origin = {-80, 54}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      test test10(a = aa * 4, b = bb, c = cc * 2) annotation(Placement(visible = true, transformation(origin = {-40, 56}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      test test11(a = aa * 4, b = bb, c = cc * 4) annotation(Placement(visible = true, transformation(origin = {10, 54}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      test test12(a = aa * 4, b = bb, c = cc * 8) annotation(Placement(visible = true, transformation(origin = {48, 56}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      test test13(a = aa * 4 * 2, b = bb, c = cc) annotation(Placement(visible = true, transformation(origin = {-76, 14}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      test test14(a = aa * 4 * 2, b = bb, c = cc * 2) annotation(Placement(visible = true, transformation(origin = {-42, 18}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      test test15(a = aa * 4 * 2, b = bb, c = cc * 4) annotation(Placement(visible = true, transformation(origin = {22, 18}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      test test16(a = aa * 4 * 2, b = bb, c = cc * 8) annotation(Placement(visible = true, transformation(origin = {52, 16}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      annotation(Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})));
    end TestMu;
    annotation(Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})));
  end TestCase;

  function check_servive_level
    input Real servive_level;
    input Real servive_limit;
    output Real remainder;
  algorithm
    remainder := 0;
    if servive_level > servive_limit then
      remainder := servive_level * 0.2;
    end if;
    annotation(Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})));
  end check_servive_level;

  function find_min_value
    input Integer arr_size;
    input Real[arr_size] arr;
    output Integer result;
  protected
    Integer k(start = 1);
    Real small(start = 100000);
  algorithm
    k := 1;
    small := 10000000.0;
    while k <> arr_size loop
      if small > arr[k] then
        small := arr[k];
        result := k;
      end if;
      k := k + 1;
    end while;
  end find_min_value;

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

  function GetCustomer
    input Real real_seed;
    output Real required_memory;
    output Integer customer_type;
    Real rand_num;
    Real rand_num2;
    Real Normal;
    Real Normal2;
  algorithm
    required_memory := 0;
    rand_num := Random_Num(real_seed);
    rand_num2 := Random_Num(rand_num);
    Normal := Nom(rand_num);
    Normal2 := Nom(rand_num2);
    if Normal <= 0.8 then
      required_memory := 20;
      customer_type := 1;
    else
      required_memory := 60;
      customer_type := 2;
    end if;
    required_memory := required_memory * (1 + Normal2 - 0.5);
  end GetCustomer;
  annotation(Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})));
end GC;