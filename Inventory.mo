package SSSQ
  package Inventory
    model Inventory
      parameter Real mean_interdemand(start = 0.1, fixed = true);
      parameter Integer setup_cost(start = 30, fixed = true);
      parameter Real incremental_cost(start = 3.0, fixed = true);
      parameter Real holding_cost(start = 2, fixed = true);
      parameter Real shortage_cost(start = 7, fixed = true);
      parameter Real inter_arrive_time(start = 0.5, fixed = true);
      parameter Real mean_evaluate_time(start = 1.0, fixed = true);
      parameter Real item_price(start = 20, fixed = true);
      parameter Integer small(start = 20, fixed = true);
      parameter Integer big(start = 30, fixed = true);
      Integer user_demand(start = 2);
      Integer inv_level(start = 100);
      Integer amount(start = 0);
      Real total_ordering_cost(start = 0);
      Real total_item_price(start = 0);
      Real total_holding_cost(start = 0);
      Real total_shortage_cost(start = 0);
      Real interdemand(start = 0.0);
      Real arrive_time(start = 0.0);
      Real evaluate_time(start = 0.0);
      Real last_time(start = 0.0);
      Boolean is_evaluate(start = false);
      Boolean event_order_arrive(start = false);
      Boolean event_evaluate(start = false);
      Boolean event_demand(start = false);
      Integer random_seed(start = 8);
    algorithm
      when time > interdemand then
        interdemand := time + mean_interdemand;
        event_demand := true;
      end when;
      when time > arrive_time and is_evaluate then
        arrive_time := 0;
        is_evaluate := false;
        event_order_arrive := true;
      end when;
      when time > evaluate_time then
        evaluate_time := time + mean_evaluate_time;
        event_evaluate := true;
      end when;
      when event_order_arrive then
        if inv_level > 0 then
          total_holding_cost := total_holding_cost + (time - last_time) * holding_cost;
          last_time := time;
        end if;
        if inv_level < 0 then
          total_shortage_cost := total_shortage_cost + (time - last_time) * shortage_cost;
          last_time := time;
        end if;
        inv_level := pre(inv_level) + amount;
        event_order_arrive := false;
      end when;
      when event_demand then
        if inv_level > 0 then
          total_holding_cost := total_holding_cost + (time - last_time) * holding_cost;
          last_time := time;
        end if;
        if inv_level < 0 then
          total_shortage_cost := total_shortage_cost + (time - last_time) * shortage_cost;
          last_time := time;
        end if;
        random_seed := rem(5 * random_seed + 3, 524287);
        user_demand := rem(random_seed, 4) + 1;
        inv_level := pre(inv_level) - user_demand;
        total_item_price := total_item_price + item_price * user_demand;
        event_demand := false;
      end when;
      when event_evaluate then
        if inv_level < small then
          amount := big - inv_level;
          total_ordering_cost := total_ordering_cost + amount * incremental_cost + setup_cost;
          arrive_time := time + inter_arrive_time;
          is_evaluate := true;
        end if;
        event_evaluate := false;
      end when;
      annotation(Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})));
    end Inventory;
    annotation(Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})));
  end Inventory;
  annotation(Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})));
end SSSQ;
