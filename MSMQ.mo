package SSSQ
  package SSSQ_Model
    model End_Model
      input Integer event_in1;
      parameter Integer Number_Of_Customer(start = 1);
      Integer Finish_Count(start = 0);
      Boolean Event1;
    algorithm
      Event1 := edge(event_in1 <> 0);
      when Event1 then
        Finish_Count := pre(Finish_Count) + event_in1;
        if Finish_Count == Number_Of_Customer then
          terminate("simulation is finish");
        end if;
      end when;
      annotation(Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2}), graphics = {Ellipse(fillColor = {255, 255, 255}, lineThickness = 15, extent = {{-85, 85}, {85, -85}}, endAngle = 360), Text(extent = {{-100, 20}, {100, -20}}, textString = "END", fontSize = 100, textStyle = {TextStyle.Bold})}));
    end End_Model;

    model Start_Model
      parameter Real Mean_Interarrive_Time(start = 1.0);
      parameter Integer Number_Of_Customer(start = 1);
      Integer Generation_Count(start = 0);
      Real Generation_Time(start = Mean_Interarrive_Time);
      output Boolean event_out1(start = false);
      Boolean Event1(start = false);
    algorithm
      event_out1 := false;
      Event1 := time >= pre(Generation_Time);
      when Event1 then
        event_out1 := true;
        Generation_Count := pre(Generation_Count) + 1;
        if Generation_Count < Number_Of_Customer then
          Generation_Time := pre(Generation_Time) + Mean_Interarrive_Time;
        end if;
      end when;
    end Start_Model;

    model Big_Queue
      parameter Integer queue_size(start = 3);
      input Boolean event_in1;
      input Integer event_in2;
      Integer[queue_size] queue_counts;
      Integer selected_queue;
      Boolean Event1, Event2;
      output Integer event_out1;
      Boolean trigger;
      Integer i;
    initial algorithm
      trigger := true;
    algorithm
      Event1 := edge(event_in1);
      Event2 := edge(event_in2 <> 0);
      event_out1 := 0;
      when {Event1, Event2} then
        if Event1 then
          if trigger and event_in2 <> 0 then
            event_out1 := 1;
          else
            selected_queue := Get_Min(queue_size, queue_counts);
            queue_counts[selected_queue] := pre(queue_counts[selected_queue]) + 1;
            trigger := false;
          end if;
        end if;
        if Event2 then
          i := 1;
          while i <= event_in2 loop
            selected_queue := Get_Max(queue_size, queue_counts);
            if queue_counts[selected_queue] > 0 then
              queue_counts[selected_queue] := pre(queue_counts[selected_queue]) - 1;
              event_out1 := event_out1 + 1;
            end if;
            i := i + 1;
          end while;
        end if;
      end when;
    end Big_Queue;

    model Big_Server
      input Integer event_in1;
      output Integer event_out1;
      output Integer event_out2;
      parameter Integer server_count(start = 4);
      parameter Real[server_count] Mean_Server_Time(start = {1.2, 1.2, 1.2, 1.2});
      discrete Boolean[server_count] Server_Busy;
      discrete Real[server_count] Server_Time;
      Boolean Event1, Event2;
      //protected
      Real Server_Finish_Count(start = 0);
      Real min_server_time(start = 10000.0);
      Integer i(start = 1);
      Integer j(start = 1);
      Integer idx(start = 1);
      Integer idx2(start = 1);
      Integer idx3(start = 1);
    initial algorithm
      i := 1;
      //      idx := 1;
      while i <= server_count loop
        Server_Busy[i] := false;
        Server_Time[i] := 10000.0;
        i := i + 1;
      end while;
    initial algorithm
      event_out1 := server_count;
    algorithm
      Event1 := edge(event_in1 <> 0);
      Event2 := time > pre(min_server_time);
      event_out2 := 0;
      when {Event1, Event2} then
        idx3 := idx3 + 1;
        if Event1 then
          idx2 := idx2 + 1;
          j := 1;
          while j <= event_in1 loop
            i := 1;
            while i <= server_count loop
              if not Server_Busy[i] then
                Server_Busy[i] := true;
                Server_Time[i] := time + Mean_Server_Time[i];
                if min_server_time > Server_Time[i] then
                  min_server_time := Server_Time[i];
                end if;
                break;
              end if;
              i := i + 1;
            end while;
            j := j + 1;
            event_out1 := event_out1 - 1;
          end while;
          if Is_All_Server_Busy(server_count, Server_Busy) then
            event_out1 := 0;
          end if;
        end if;
        if Event2 then
          i := 1;
          while i <= server_count loop
            if time >= pre(Server_Time[i]) then
              Server_Busy[i] := false;
              Server_Time[i] := 10000.0;
              event_out1 := event_out1 + 1;
            end if;
            i := i + 1;
          end while;
          idx := Get_Min_Time(server_count, Server_Time);
          min_server_time := Server_Time[idx];
          Server_Finish_Count := Server_Finish_Count + event_out1;
          event_out2 := event_out1;
        end if;
      end when;
      //idx := Get_Min_Time(server_count, Server_Time);
      //min_server_time := Server_Time[idx];
      //idx := Get_Min_Time(server_count, Server_Time);
      //min_server_time := Server_Time[idx];
    equation

    end Big_Server;
    annotation(Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2}), graphics = {Text(extent = {{-100, 100}, {100, -100}}, textString = "M", fontSize = 500, textStyle = {TextStyle.Bold})}));
  end SSSQ_Model;

  package Example
    model MultiServerMultiQueue
      SSSQ_Model.Big_Queue big_Queue1(queue_size = 3) annotation(Placement(visible = true, transformation(origin = {-44, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      SSSQ_Model.Start_Model start_Model1(Mean_Interarrive_Time = 1.0, Number_Of_Customer = 1000) annotation(Placement(visible = true, transformation(origin = {-85, 9}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));
      SSSQ_Model.End_Model end_Model1(Number_Of_Customer = 1000) annotation(Placement(visible = true, transformation(origin = {66, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      SSSQ_Model.Big_Server big_Server1(server_count = 4, Mean_Server_Time = {4.0, 5.5, 5.0, 4.5}) annotation(Placement(visible = true, transformation(origin = {6, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    equation
      big_Queue1.event_in1 = pre(start_Model1.event_out1);
      big_Queue1.event_in2 = pre(big_Server1.event_out1);
      big_Server1.event_in1 = pre(big_Queue1.event_out1);
      end_Model1.event_in1 = pre(big_Server1.event_out2);
    end MultiServerMultiQueue;
    annotation(Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2}), graphics = {Text(extent = {{-100, 100}, {100, -100}}, textString = "M", fontSize = 200, textStyle = {TextStyle.Bold})}));
  end Example;

  function Get_Min
    input Integer arr_size;
    input Integer[arr_size] arr;
    output Integer result;
  protected
    Integer k(start = 1);
    Integer small(start = 100000);
  algorithm
    k := 1;
    small := 100000;
    while k <= arr_size loop
      if small > arr[k] then
        result := k;
        small := arr[k];
      end if;
      k := k + 1;
    end while;
    annotation(Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})));
  end Get_Min;

  function Get_Max
    input Integer arr_size;
    input Integer[arr_size] arr;
    output Integer result;
  protected
    Integer k(start = 1);
    Integer large(start = 0);
  algorithm
    k := 1;
    large := 0;
    while k <= arr_size loop
      if large < arr[k] then
        result := k;
        large := arr[k];
      end if;
      k := k + 1;
    end while;
    annotation(Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})));
  end Get_Max;

  function Find_Not_Busy
    input Integer arr_size;
    input Boolean[arr_size] arr;
    output Integer result;
  protected
    Integer k(start = 0);
  algorithm
    while k <> arr_size loop
      if arr[k] <> true then
        result := k;
      end if;
      k := k + 1;
    end while;
    annotation(Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})));
  end Find_Not_Busy;

  function Get_Min_Time
    input Integer arr_size;
    input Real[arr_size] arr;
    output Integer result;
  protected
    Integer k(start = 1);
    Real small(start = 100000);
  algorithm
    k := 1;
    small := 100000.0;
    while k <> arr_size loop
      if small > arr[k] then
        small := arr[k];
        result := k;
      end if;
      k := k + 1;
    end while;
  end Get_Min_Time;

  function Is_All_Server_Busy
    input Integer arr_size;
    input Boolean[arr_size] arr;
    output Boolean result;
  protected
    Integer k(start = 1);
  algorithm
    k := 1;
    result := true;
    while k <= arr_size loop
      if not arr[k] then
        result := false;
      end if;
      k := k + 1;
    end while;
  end Is_All_Server_Busy;

  function Interval_Event
    input Integer arr_size;
    input Real[arr_size] arr;
    input Real t;
    output Boolean result;
  protected
    Integer k(start = 1);
  algorithm
    k := 1;
    result := false;
    while k <> arr_size loop
      if t > arr[k] then
        result := true;
        break;
      end if;
      k := k + 1;
    end while;
  end Interval_Event;
  annotation(Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})));
end SSSQ;