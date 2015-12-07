package inventory
  model Factory
    Integer order_amount(start = 0, fixed = false);
    parameter Real delivery_lag;
    Modelica.Blocks.Interfaces.IntegerInput in_ annotation(Placement(visible = true, transformation(origin = {100, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 180), iconTransformation(origin = {100, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Blocks.Interfaces.IntegerOutput out_ annotation(Placement(visible = true, transformation(origin = {100, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Boolean external_event(start = false), internal_event(start = false);
    Real order_time;
  algorithm
    out_ := 0;
    external_event := in_ <> pre(in_);
    internal_event := time > order_time;
    when {external_event, internal_event} then
      if external_event then
        order_time := time + delivery_lag;
        order_amount := in_;
      end if;
      if internal_event then
        out_ := order_amount;
      end if;
    end when;
    annotation(Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})));
  end Factory;

  model Company
    parameter Real order(start = 10.0);
    Real next_order(start = order);
    Integer order_amount(start = 0, fixed = false);
    Integer send_amount(start = 0, fixed = false);
    Integer storage(start = 60, fixed = false);
    Integer cal_stor(start = 0, fixed = false);
    Real ordering_cost(start = 0.0, fixed = false);
    Real shortage_cost(start = 0.0, fixed = false);
    Real holding_cost(start = 0.0, fixed = false);
    Real t_o_c(start = 0.0, fixed = false);
    Real t_s_c(start = 0.0, fixed = false);
    Real t_h_c(start = 0.0, fixed = false);
    Real total_cost(start = 0.0, fixed = false);
    parameter Integer min_storage;
    parameter Integer max_storage;
    Modelica.Blocks.Interfaces.IntegerInput cus_in annotation(Placement(visible = true, transformation(origin = {100, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 180), iconTransformation(origin = {100, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Blocks.Interfaces.IntegerInput fac_in annotation(Placement(visible = true, transformation(origin = {-100, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Blocks.Interfaces.IntegerOutput fac_out annotation(Placement(visible = true, transformation(origin = {-100, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 180), iconTransformation(origin = {-100, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
    Modelica.Blocks.Interfaces.IntegerOutput cus_out annotation(Placement(visible = true, transformation(origin = {100, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
    Boolean cus_external_event(start = false), fac_external_event(start = false), amount_internal_event(start = false), time_internal_event(start = false);
  algorithm
    fac_out := 0;
    cus_out := 0;
    shortage_cost := 0.5 * cal_stor;
    holding_cost := storage * 0.1;
    t_s_c := pre(t_s_c) + shortage_cost;
    t_h_c := pre(t_h_c) + holding_cost;
    total_cost := t_s_c + t_o_c + t_h_c;
    cus_external_event := cus_in <> pre(cus_in);
    fac_external_event := fac_in <> pre(fac_in);
    amount_internal_event := order_amount > 0;
    time_internal_event := next_order <= time;
    when {cus_external_event, fac_external_event, amount_internal_event, time_internal_event} then
      if cus_external_event then
        send_amount := cus_in;
        if send_amount <= storage then
          cus_out := send_amount;
          storage := pre(storage) - cus_out;
        else
          cus_out := storage;
          cal_stor := pre(cal_stor) + send_amount - storage;
          storage := 0;
        end if;
        if storage < min_storage then
          order_amount := max_storage - storage;
        end if;
      end if;
      if fac_external_event then
        if fac_in >= cal_stor then
          storage := pre(storage) + fac_in - cal_stor;
          cal_stor := 0;
        else
          cal_stor := pre(cal_stor) - fac_in;
        end if;
      end if;
      if time_internal_event then
        next_order := pre(next_order) + order;
        if amount_internal_event then
          fac_out := order_amount;
          ordering_cost := 32 + order_amount * 3.0;
          t_o_c := pre(t_o_c) + ordering_cost;
          order_amount := 0;
        end if;
      end if;
    end when;
    annotation(Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})));
  end Company;

  model Customer
    parameter Integer seed_in(start = 1);
    parameter Real need(start = 4.0);
    //Integer seed_next(start = seed_in);
    Real next_need(start = need);
    Boolean internal_event(start = false);
    Integer total_demand(start = 0);
    Real real_seed(start = Get_Seed(seed_in));
    Real rand_num(start = 0.0);
    Real Normal(start = 0.0);
    constant Real MODULUS = 2147483647.0;
    constant Real CO = 630360016.0;
    Modelica.Blocks.Interfaces.IntegerInput in_ annotation(Placement(visible = true, transformation(origin = {-100, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Blocks.Interfaces.IntegerOutput out_ annotation(Placement(visible = true, transformation(origin = {-100, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 180), iconTransformation(origin = {-100, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  algorithm
    out_ := 0;
    internal_event := time >= pre(next_need);
    when internal_event then
      rand_num := Random_Num(real_seed);
      Normal := Nom(rand_num);
      if Normal >= 0.0 and Normal < 1.0 / 6.0 then
        out_ := 1;
      elseif Normal >= 1.0 / 6.0 and Normal < 0.5 then
        out_ := 2;
      elseif Normal >= 0.5 and Normal < 5.0 / 6.0 then
        out_ := 3;
      else
        out_ := 4;
      end if;
      next_need := pre(next_need) + need;
      total_demand := pre(total_demand) + out_;
      real_seed := rand_num;
    end when;
    annotation(Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})));
  end Customer;

  model Test
    inventory.Factory factory1(delivery_lag = 5) annotation(Placement(visible = true, transformation(origin = {-80, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    inventory.Company company1(order = 10, min_storage = 20, max_storage = 60) annotation(Placement(visible = true, transformation(origin = {-20, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    inventory.Customer customer1(seed_in = 1, need = 4) annotation(Placement(visible = true, transformation(origin = {40, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  algorithm
    customer1.in_ := pre(company1.cus_out);
    company1.cus_in := pre(customer1.out_);
    company1.fac_in := pre(factory1.out_);
    factory1.in_ := pre(company1.fac_out);
    annotation(Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})));
  end Test;

  function Get_Seed
    input Integer Seed;
    output Real First;
  protected
    Real[100] zrng;
  algorithm
    zrng := {1973272912.0, 281629770.0, 20006270.0, 1280689831.0, 2096730329.0, 1933576050.0, 913566091.0, 246780520.0, 1363774876.0, 604901985.0, 1511192140.0, 1259851944.0, 824064364.0, 150493284.0, 242708531.0, 75253171.0, 1964472944.0, 1202299975.0, 233217322.0, 1911216000.0, 726370533.0, 403498145.0, 993232223.0, 1103205531.0, 762430696.0, 1922803170.0, 1385516923.0, 76271663.0, 413682397.0, 726466604.0, 336157058.0, 1432650381.0, 1120463904.0, 595778810.0, 877722890.0, 1046574445.0, 68911991.0, 2088367019.0, 748545416.0, 622401386.0, 2122378830.0, 640690903.0, 1774806513.0, 2132545692.0, 2079249579.0, 78130110.0, 852776735.0, 1187867272.0, 1351423507.0, 1645973084.0, 1997049139.0, 922510944.0, 2045512870.0, 898585771.0, 243649545.0, 1004818771.0, 773686062.0, 403188473.0, 372279877.0, 1901633463.0, 498067494.0, 2087759558.0, 493157915.0, 597104727.0, 1530940798.0, 1814496276.0, 536444882.0, 1663153658.0, 855503735.0, 67784357.0, 1432404475.0, 619691088.0, 119025595.0, 880802310.0, 176192644.0, 1116780070.0, 277854671.0, 1366580350.0, 1142483975.0, 2026948561.0, 1053920743.0, 786262391.0, 1792203830.0, 1494667770.0, 1923011392.0, 1433700034.0, 1244184613.0, 1147297105.0, 539712780.0, 1545929719.0, 190641742.0, 1645390429.0, 264907697.0, 620389253.0, 1502074852.0, 927711160.0, 364849192.0, 2049576050.0, 638580085.0, 547070247.0};
    First := zrng[Seed];
  end Get_Seed;

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
  annotation(Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})));
end inventory;